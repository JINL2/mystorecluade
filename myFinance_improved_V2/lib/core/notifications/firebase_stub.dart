// Temporary Firebase stub for testing without Firebase
class FirebaseMessaging {
  static FirebaseMessaging? _instance;
  static FirebaseMessaging get instance => _instance ??= FirebaseMessaging();
  
  static const Stream<RemoteMessage> onMessage = Stream.empty();
  static const Stream<RemoteMessage> onMessageOpenedApp = Stream.empty();
  
  Future<String?> getToken() async => null;
  Future<String?> getAPNSToken() async => null;
  Stream<String> get onTokenRefresh => const Stream.empty();
  Future<RemoteMessage?> getInitialMessage() async => null;
  Future<void> deleteToken() async {}
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) async {}
  
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) async {
    return NotificationSettings(
      authorizationStatus: AuthorizationStatus.authorized,
      alert: AppleNotificationSetting.enabled,
      announcement: AppleNotificationSetting.notSupported,
      badge: AppleNotificationSetting.enabled,
      carPlay: AppleNotificationSetting.notSupported,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.always,
      timeSensitive: AppleNotificationSetting.notSupported,
      criticalAlert: AppleNotificationSetting.notSupported,
      sound: AppleNotificationSetting.enabled,
    );
  }
  
  Future<NotificationSettings> getNotificationSettings() async {
    return NotificationSettings(
      authorizationStatus: AuthorizationStatus.authorized,
      alert: AppleNotificationSetting.enabled,
      announcement: AppleNotificationSetting.notSupported,
      badge: AppleNotificationSetting.enabled,
      carPlay: AppleNotificationSetting.notSupported,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.always,
      timeSensitive: AppleNotificationSetting.notSupported,
      criticalAlert: AppleNotificationSetting.notSupported,
      sound: AppleNotificationSetting.enabled,
    );
  }
  
  Future<void> subscribeToTopic(String topic) async {}
  Future<void> unsubscribeFromTopic(String topic) async {}
  
  static void Function(RemoteMessage)? onBackgroundMessage(Function(RemoteMessage) handler) => null;
}

class RemoteMessage {
  final RemoteNotification? notification;
  final Map<String, dynamic> data;
  final String? messageId;
  final String? category;
  final String? from;
  final String? collapseKey;
  final DateTime? sentTime;
  
  RemoteMessage({
    this.notification, 
    this.data = const {}, 
    this.messageId,
    this.category,
    this.from,
    this.collapseKey,
    this.sentTime,
  });
}

class RemoteNotification {
  final String? title;
  final String? body;
  final AndroidNotification? android;
  final AppleNotification? apple;
  
  RemoteNotification({this.title, this.body, this.android, this.apple});
}

class AndroidNotification {
  final String? imageUrl;
  AndroidNotification({this.imageUrl});
}

class AppleNotification {
  final String? imageUrl;
  AppleNotification({this.imageUrl});
}

enum AuthorizationStatus {
  authorized,
  denied,
  notDetermined,
  provisional,
}

enum AppleNotificationSetting {
  disabled,
  enabled,
  notSupported,
}

enum AppleShowPreviewSetting {
  always,
  whenAuthenticated,
  never,
  notSupported,
}

class NotificationSettings {
  final AuthorizationStatus authorizationStatus;
  final AppleNotificationSetting alert;
  final AppleNotificationSetting announcement;
  final AppleNotificationSetting badge;
  final AppleNotificationSetting carPlay;
  final AppleNotificationSetting lockScreen;
  final AppleNotificationSetting notificationCenter;
  final AppleShowPreviewSetting showPreviews;
  final AppleNotificationSetting timeSensitive;
  final AppleNotificationSetting criticalAlert;
  final AppleNotificationSetting sound;
  
  NotificationSettings({
    required this.authorizationStatus,
    required this.alert,
    required this.announcement,
    required this.badge,
    required this.carPlay,
    required this.lockScreen,
    required this.notificationCenter,
    required this.showPreviews,
    required this.timeSensitive,
    required this.criticalAlert,
    required this.sound,
  });
}

class Firebase {
  static List<FirebaseApp> apps = [];
  static Future<FirebaseApp> initializeApp({FirebaseOptions? options}) async {
    return FirebaseApp();
  }
}

class FirebaseApp {}

class FirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? storageBucket;
  final String? iosBundleId;

  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.storageBucket,
    this.iosBundleId,
  });
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
  );
}