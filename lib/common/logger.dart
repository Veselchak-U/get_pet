import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_pet/import.dart';
import 'package:logger/logger.dart';
// import 'package:logger/src/outputs/file_output.dart';
import 'package:path_provider/path_provider.dart';

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
    File logFile;
    try {
      // Get platform directory
      Directory directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        // Not mobile - return with log to console only
        _instance = Logger(
          printer: PlainPrinter(),
          output: ConsoleOutput(),
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
      printer: PlainPrinter(),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: logFile),
      ]),
    );

    // Write initial record
    _instance.i('---------------------------------');
    _instance.i('LOGGER STARTED.');
    _instance.i('---------------------------------');

    // Not-awaiting service functions:
    // ignore: unawaited_futures
    _deleteOldFiles(currentFile: logFile);
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

// Very simplified custom LogPrinter
class PlainPrinter extends LogPrinter {
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
class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink _sink;

  FileOutput({
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
    // _sink.writeAll(event.lines, '\n');
    for (final String line in event.lines) {
      _sink.writeln(line);
    }
  }

  @override
  void destroy() async {
    await _sink.flush();
    await _sink.close();
  }
}
