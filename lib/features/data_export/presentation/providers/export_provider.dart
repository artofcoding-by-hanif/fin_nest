import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/settings_service.dart';
import '../../services/data_export_service.dart';
import '../../domain/models/export_data.dart';

/// Provider for DataExportService
final dataExportServiceProvider = Provider<DataExportService>((ref) {
  return DataExportService(
    database: GetIt.instance<AppDatabase>(),
    settingsService: SettingsService.instance,
  );
});

/// State for export operation
class ExportState {
  final bool isLoading;
  final String? filePath;
  final String? error;

  const ExportState({
    this.isLoading = false,
    this.filePath,
    this.error,
  });

  ExportState copyWith({
    bool? isLoading,
    String? filePath,
    String? error,
  }) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
    );
  }
}

/// Notifier for export operations
class ExportNotifier extends StateNotifier<ExportState> {
  final DataExportService _exportService;

  ExportNotifier(this._exportService) : super(const ExportState());

  /// Export all data to file
  Future<void> exportData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Export data
      final exportData = await _exportService.exportAllData();

      // Save to file
      final filePath = await _exportService.saveExportToFile(exportData);

      state = state.copyWith(isLoading: false, filePath: filePath);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Share exported file
  Future<void> shareExportedFile() async {
    if (state.filePath == null) {
      state = state.copyWith(error: 'No file to share');
      return;
    }

    try {
      await _exportService.shareExportFile(state.filePath!);
    } catch (e) {
      state = state.copyWith(error: 'Share failed: ${e.toString()}');
    }
  }

  /// Reset state
  void reset() {
    state = const ExportState();
  }
}

/// Provider for export state
final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>((ref) {
  final exportService = ref.watch(dataExportServiceProvider);
  return ExportNotifier(exportService);
});

/// State for import operation
class ImportState {
  final bool isLoading;
  final ImportResult? result;
  final String? error;

  const ImportState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  ImportState copyWith({
    bool? isLoading,
    ImportResult? result,
    String? error,
  }) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

/// Notifier for import operations
class ImportNotifier extends StateNotifier<ImportState> {
  final DataExportService _exportService;

  ImportNotifier(this._exportService) : super(const ImportState());

  /// Import data from file
  Future<void> importData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'No file selected');
        return;
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        state = state.copyWith(isLoading: false, error: 'Invalid file path');
        return;
      }

      // Import data
      final importResult = await _exportService.importFromFile(filePath);

      state = state.copyWith(isLoading: false, result: importResult);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Import failed: ${e.toString()}',
      );
    }
  }

  /// Reset state
  void reset() {
    state = const ImportState();
  }
}

/// Provider for import state
final importProvider = StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  final exportService = ref.watch(dataExportServiceProvider);
  return ImportNotifier(exportService);
});

