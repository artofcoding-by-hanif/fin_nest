import { FieldValue, getFirestore, Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

import {
  Allowance,
  Bucket,
  exhaustedMessage,
  periodKey,
  premiumOnlyMessage,
} from "./limits.js";

/**
 * Per-user AI usage counters in Firestore, one document per bucket and
 * period: `aiUsage/{uid}/usage/{bucket}_{period}`. They hold only a count.
 * Old counters are deleted by a Firestore TTL policy on `expireAt`.
 */
const RETENTION_DAYS = 40;

function expireAt(): Timestamp {
  return Timestamp.fromMillis(Date.now() + RETENTION_DAYS * 24 * 60 * 60 * 1000);
}

function counterRef(uid: string, bucket: Bucket, allowance: Allowance) {
  return getFirestore()
    .collection("aiUsage")
    .doc(uid)
    .collection("usage")
    .doc(`${bucket}_${periodKey(allowance.period, new Date())}`);
}

export interface Plan {
  bucket: Bucket;
  allowance: Allowance;
  premium: boolean;
}

/** Takes one unit of the allowance; returns how many are left */
export async function consumeQuota(uid: string, plan: Plan): Promise<number> {
  const { bucket, allowance, premium } = plan;
  if (allowance.limit <= 0) {
    throw new HttpsError("failed-precondition", premiumOnlyMessage(bucket), {
      reason: "premium_required",
    });
  }

  const ref = counterRef(uid, bucket, allowance);
  return getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const used = (snap.get("count") as number | undefined) ?? 0;
    if (used >= allowance.limit) {
      throw new HttpsError("resource-exhausted", exhaustedMessage(bucket, allowance, premium), {
        reason: "quota",
        premium,
      });
    }
    tx.set(
      ref,
      {
        count: FieldValue.increment(1),
        updatedAt: FieldValue.serverTimestamp(),
        expireAt: expireAt(),
      },
      { merge: true },
    );
    return allowance.limit - used - 1;
  });
}

/** Gives back a unit that failed through no fault of the user */
export async function refundQuota(uid: string, plan: Plan): Promise<void> {
  await counterRef(uid, plan.bucket, plan.allowance).set(
    { count: FieldValue.increment(-1), updatedAt: FieldValue.serverTimestamp() },
    { merge: true },
  );
}
