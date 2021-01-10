import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_pet/import.dart';
import 'package:logger/logger.dart';
// import 'package:logger/src/outputs/file_output.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLogger {
  static Logger _instance;

  static Logger get logger {
    assert(_instance != null);
    return _instance;
  }

  static Future<void> init() async {
    if (_instance != null) {
      return;
    }
    final Level logLevel = kDebugMode ? Level.verbose : Level.warning;
    File logFile;
    try {
      final directory = await _getPlatformAppDirectory();
      if (directory == null) {
        // Not mobile - creale logger to console only
        _instance = Logger(
          filter: _LogFilter(),
          printer: _PlainPrinter(),
          output: ConsoleOutput(),
          level: logLevel,
        );
        return;
      }
      final logFolder = Directory('${directory.path}/logs/');
      if (!await logFolder.exists()) {
        await logFolder.create(recursive: true);
      }
      final fullPath =
          '${logFolder.path}${dateFormatter.format(DateTime.now())}.txt';
      logFile = File(fullPath);
    } on dynamic catch (error, stackTrace) {
      out(error);
    }

    _instance = Logger(
      filter: _LogFilter(),
      printer: _PlainPrinter(),
      output: MultiOutput([
        ConsoleOutput(),
        _FileOutput(file: logFile),
      ]),
      level: logLevel,
    );

    // Write initial record
    _instance.w('---------------------------------');
    _instance.w('LOGGER STARTED.');
    _instance.w('---------------------------------');

    // Not-awaiting service functions:
    // ignore: unawaited_futures
    _deleteOldFiles(currentFile: logFile);
  }

  static Future<Directory> _getPlatformAppDirectory() async {
    Directory directory;
    final bool isPermissionGranted = await _getPermission(Permission.storage);

    if (Platform.isAndroid) {
      if (isPermissionGranted) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      // Not mobile - return null
    }
    return directory;
  }

  static Future<bool> _getPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return false;
    }
    // Try to get permission
    status = await permission.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  static Future<void> _deleteOldFiles({
    @required File currentFile,
  }) async {
    assert(currentFile != null);

    final currentFilePath = currentFile.path;
    final currentFileDirectory = currentFile.parent;
    final fileStream = currentFileDirectory.list(followLinks: false);
    await for (final entity in fileStream) {
      if (entity is File && entity.path != currentFilePath) {
        await entity.delete();
      }
    }
  }
}

// Turn on logging in release mode
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    if (event.level.index >= level.index) {
      shouldLog = true;
    }
    return shouldLog;
  }
}

// Very simplified custom LogPrinter
class _PlainPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final messageStr = _stringifyMessage(event.message);
    final errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    // final timeStr = DateTime.now().toIso8601String();
    final timeStr = DateTime.now();
    return ['$timeStr $messageStr$errorStr'];
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      final encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}

// In package:logger/logger.dart:
// export 'src/log_output.dart' if (dart.io) 'src/outputs/file_output.dart';
class _FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink _sink;

  _FileOutput({
    this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  void init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink.writeAll(event.lines, '\n');
    _sink.writeln();
  }

  @override
  void destroy() async {
    await _sink.flush();
    await _sink.close();
  }
}
