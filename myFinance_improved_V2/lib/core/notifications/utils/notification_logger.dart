import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_stub.dart';

/// Logger specifically for notification debugging
class NotificationLogger {
  static final NotificationLogger _instance = NotificationLogger._internal();
  factory NotificationLogger() => _instance;
  NotificationLogger._internal();

  // final Logger _logger = Logger(
  //   printer: PrettyPrinter(
  //     methodCount: 2,
  //     errorMethodCount: 8,
  //     lineLength: 120,
  //     colors: true,
  //     printEmojis: false,
  //     dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  //   ),
  // );
  
  File? _logFile;
  final List<NotificationLog> _logs = [];
  
  /// Initialize the notification logger
  Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/notification_logs');
      
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      _logFile = File('${logDir.path}/notification_log_$timestamp.txt');
      
      await _logFile!.writeAsString('=== Notification Log Started at $timestamp ===\n');
      
      // Notification logger initialized
      
    } catch (e) {
      // Failed to initialize notification logger
    }
  }
  
  /// Log a notification
  void logNotification(RemoteMessage message) {
    final log = NotificationLog(
      timestamp: DateTime.now(),
      type: 'FCM',
      messageId: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      category: message.category,
      from: message.from,
      collapseKey: message.collapseKey,
      sentTime: message.sentTime,
    );
    
    _addLog(log);
    _writeToFile(log);
    _printLog(log);
  }
  
  /// Log a test notification
  void logTestNotification() {
    final log = NotificationLog(
      timestamp: DateTime.now(),
      type: 'TEST',
      messageId: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      body: 'This is a test notification',
      data: {'test': true},
    );
    
    _addLog(log);
    _writeToFile(log);
    _printLog(log);
  }
  
  /// Log an error
  void logError(String error, {dynamic details}) {
    final log = NotificationLog(
      timestamp: DateTime.now(),
      type: 'ERROR',
      error: error,
      errorDetails: details?.toString(),
    );
    
    _addLog(log);
    _writeToFile(log);
    // Log error: $error
  }
  
  /// Add log to memory
  void _addLog(NotificationLog log) {
    _logs.add(log);
    
    // Keep only last 100 logs in memory
    if (_logs.length > 100) {
      _logs.removeAt(0);
    }
  }
  
  /// Write log to file
  Future<void> _writeToFile(NotificationLog log) async {
    if (_logFile == null) return;
    
    try {
      // Ensure the directory exists before writing
      final directory = _logFile!.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      final logString = _formatLog(log);
      await _logFile!.writeAsString('$logString\n', mode: FileMode.append);
    } catch (e) {
      // Don't log the error to avoid infinite loop
      if (kDebugMode) {
        // Failed to write to log file: $e
      }
    }
  }
  
  /// Print log to console (only in debug mode)
  void _printLog(NotificationLog log) {
    if (kDebugMode) {
      // ${log.type} notification: ${log.title ?? "N/A"}
    }
  }
  
  /// Format log for file writing
  String _formatLog(NotificationLog log) {
    final buffer = StringBuffer();
    
    buffer.writeln('--- ${log.timestamp.toIso8601String()} ---');
    buffer.writeln('Type: ${log.type}');
    
    if (log.messageId != null) buffer.writeln('Message ID: ${log.messageId}');
    if (log.title != null) buffer.writeln('Title: ${log.title}');
    if (log.body != null) buffer.writeln('Body: ${log.body}');
    if (log.data != null) buffer.writeln('Data: ${jsonEncode(log.data)}');
    if (log.category != null) buffer.writeln('Category: ${log.category}');
    if (log.from != null) buffer.writeln('From: ${log.from}');
    if (log.collapseKey != null) buffer.writeln('Collapse Key: ${log.collapseKey}');
    if (log.sentTime != null) buffer.writeln('Sent Time: ${log.sentTime}');
    if (log.error != null) buffer.writeln('Error: ${log.error}');
    if (log.errorDetails != null) buffer.writeln('Error Details: ${log.errorDetails}');
    
    return buffer.toString();
  }
  
  
  /// Get all logs
  List<NotificationLog> getLogs() => List.unmodifiable(_logs);
  
  /// Get logs filtered by type
  List<NotificationLog> getLogsByType(String type) {
    return _logs.where((log) => log.type == type).toList();
  }
  
  /// Get recent logs
  List<NotificationLog> getRecentLogs(int count) {
    final start = _logs.length > count ? _logs.length - count : 0;
    return _logs.sublist(start);
  }
  
  /// Export logs to JSON
  String exportLogsToJson() {
    final logsJson = _logs.map((log) => log.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(logsJson);
  }
  
  /// Clear logs
  Future<void> clearLogs() async {
    _logs.clear();
    
    if (_logFile != null) {
      final timestamp = DateTime.now().toIso8601String();
      await _logFile!.writeAsString('=== Logs cleared at $timestamp ===\n');
    }
    
    // Notification logs cleared
  }
  
  /// Get debug statistics
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{
      'total_logs': _logs.length,
      'fcm_count': _logs.where((l) => l.type == 'FCM').length,
      'local_count': _logs.where((l) => l.type == 'LOCAL').length,
      'test_count': _logs.where((l) => l.type == 'TEST').length,
      'error_count': _logs.where((l) => l.type == 'ERROR').length,
    };
    
    if (_logs.isNotEmpty) {
      stats['first_log'] = _logs.first.timestamp.toIso8601String();
      stats['last_log'] = _logs.last.timestamp.toIso8601String();
    }
    
    return stats;
  }
}

/// Model for notification log entries
class NotificationLog {
  final DateTime timestamp;
  final String type; // FCM, LOCAL, TEST, ERROR
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final String? category;
  final String? from;
  final String? collapseKey;
  final DateTime? sentTime;
  final String? error;
  final String? errorDetails;
  
  NotificationLog({
    required this.timestamp,
    required this.type,
    this.messageId,
    this.title,
    this.body,
    this.data,
    this.category,
    this.from,
    this.collapseKey,
    this.sentTime,
    this.error,
    this.errorDetails,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      if (messageId != null) 'messageId': messageId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (data != null) 'data': data,
      if (category != null) 'category': category,
      if (from != null) 'from': from,
      if (collapseKey != null) 'collapseKey': collapseKey,
      if (sentTime != null) 'sentTime': sentTime?.toIso8601String(),
      if (error != null) 'error': error,
      if (errorDetails != null) 'errorDetails': errorDetails,
    };
  }
}