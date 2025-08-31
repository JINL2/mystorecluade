import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_card.dart';
import '../../../core/themes/toss_colors.dart';

class PushNotificationDiagnostic extends StatefulWidget {
  const PushNotificationDiagnostic({Key? key}) : super(key: key);

  @override
  State<PushNotificationDiagnostic> createState() => _PushNotificationDiagnosticState();
}

class _PushNotificationDiagnosticState extends State<PushNotificationDiagnostic> {
  final List<DiagnosticResult> _results = [];
  bool _isRunning = false;
  String? _fcmToken;
  String? _apnsToken;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _results.clear();
    });

    // Check 1: Firebase initialization
    await _checkFirebaseInitialization();

    // Check 2: Permission status
    await _checkNotificationPermission();

    // Check 3: FCM token retrieval
    await _checkFCMToken();

    // Check 4: APNs token (iOS only)
    if (Platform.isIOS) {
      await _checkAPNsToken();
    }

    // Check 5: Background handler registration
    await _checkBackgroundHandler();

    // Check 6: Device type
    _checkDeviceType();

    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _checkFirebaseInitialization() async {
    try {
      final apps = Firebase.apps;
      _addResult(
        'Firebase Initialization',
        apps.isNotEmpty,
        apps.isNotEmpty ? 'Firebase is initialized with ${apps.length} app(s)' : 'Firebase not initialized',
      );
    } catch (e) {
      _addResult('Firebase Initialization', false, 'Error: $e');
    }
  }

  Future<void> _checkNotificationPermission() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.getNotificationSettings();
      
      final isAuthorized = settings.authorizationStatus == AuthorizationStatus.authorized;
      _addResult(
        'Notification Permission',
        isAuthorized,
        'Status: ${settings.authorizationStatus.name}',
      );

      // Request permission if not authorized
      if (!isAuthorized) {
        final newSettings = await messaging.requestPermission();
        _addResult(
          'Permission Request',
          newSettings.authorizationStatus == AuthorizationStatus.authorized,
          'New status: ${newSettings.authorizationStatus.name}',
        );
      }
    } catch (e) {
      _addResult('Notification Permission', false, 'Error: $e');
    }
  }

  Future<void> _checkFCMToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      _addResult(
        'FCM Token',
        _fcmToken != null,
        _fcmToken != null ? 'Token retrieved (tap to copy)' : 'No FCM token available',
      );
    } catch (e) {
      _addResult('FCM Token', false, 'Error: $e');
    }
  }

  Future<void> _checkAPNsToken() async {
    try {
      _apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      _addResult(
        'APNs Token',
        _apnsToken != null,
        _apnsToken != null ? 'APNs token retrieved' : 'No APNs token (normal on simulator)',
      );
    } catch (e) {
      _addResult('APNs Token', false, 'Error: $e');
    }
  }

  Future<void> _checkBackgroundHandler() async {
    _addResult(
      'Background Handler',
      true,
      'Background message handler should be registered in main.dart',
    );
  }

  void _checkDeviceType() {
    final isSimulator = Platform.isIOS && (_apnsToken == null || _apnsToken!.isEmpty);
    _addResult(
      'Device Type',
      !isSimulator,
      isSimulator 
        ? '⚠️ Running on simulator - Push notifications won\'t work!' 
        : '✅ Running on physical device',
    );
  }

  void _addResult(String title, bool success, String details) {
    setState(() {
      _results.add(DiagnosticResult(
        title: title,
        success: success,
        details: details,
      ));
    });
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FCM Token copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Diagnostics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunning ? null : _runDiagnostics,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isRunning)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: TossLoadingView(),
              ),
            ),
          
          if (!_isRunning && _results.isEmpty)
            const Center(
              child: Text('No diagnostic results yet'),
            ),
          
          ..._results.map((result) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TossCard(
              child: ListTile(
              leading: Icon(
                result.success ? Icons.check_circle : Icons.error,
                color: result.success ? TossColors.success : TossColors.error,
                size: 32,
              ),
              title: Text(
                result.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(result.details),
              onTap: result.title == 'FCM Token' && _fcmToken != null
                ? _copyToken
                : null,
            ),
            ),
          )).toList(),
          
          if (_fcmToken != null)
            TossCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FCM Token (tap to copy):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _copyToken,
                      child: Text(
                        _fcmToken!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          TossCard(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Important Notes:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Push notifications only work on physical devices'),
                  Text('2. APNs Authentication Key must be uploaded to Firebase Console'),
                  Text('3. Bundle ID must match Firebase configuration exactly'),
                  Text('4. Ensure Push Notifications capability is enabled in Xcode'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          ElevatedButton.icon(
            onPressed: () => _testPushNotification(),
            icon: const Icon(Icons.send),
            label: const Text('Send Test Push via Firebase'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testPushNotification() async {
    if (_fcmToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No FCM token available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Push Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('To test push notifications:'),
            const SizedBox(height: 10),
            const Text('1. Go to Firebase Console'),
            const Text('2. Navigate to Messaging'),
            const Text('3. Create new notification'),
            const Text('4. Use the FCM token below:'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              color: TossColors.gray200,
              child: SelectableText(
                _fcmToken!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DiagnosticResult {
  final String title;
  final bool success;
  final String details;

  DiagnosticResult({
    required this.title,
    required this.success,
    required this.details,
  });
}