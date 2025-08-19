# Flutter Push Notification 설정 가이드

## 📱 프로젝트 개요
- **목적**: iOS Push Notification 문제 해결
- **현재 상황**: FlutterFlow에서 FCM 푸시 알림이 작동하지 않음 (BadEnvironmentKeyInToken 에러)
- **해결 방법**: Flutter 프로젝트로 직접 구현하여 문제 디버깅 및 해결

## 🔍 현재까지 확인된 문제점

### 1. APNs 환경 불일치
- **에러**: `BadEnvironmentKeyInToken (403)`
- **원인**: FCM 토큰이 개발 환경에서 생성되었으나, 프로덕션 APNs 사용 시도
- **TestFlight** 앱은 프로덕션 환경 필요

### 2. Firebase 설정
- ✅ Firebase 프로젝트: `notification-f1653`
- ✅ Bundle ID: `com.mycompany.luxappv1`
- ✅ APNs Key 업로드됨 (H2MJV57457)
- ❌ APNs Key가 Sandbox로만 제한됨

### 3. 테스트 결과
- Firebase Console 직접 테스트: ❌ 실패
- FCM v1 API 테스트: ❌ 실패 (같은 에러)
- 문제는 앱 설정이 아닌 APNs 설정

## 🎯 Flutter 프로젝트 설정 계획

### Step 1: Flutter 프로젝트 생성
```bash
flutter create myfinance_push_test
cd myfinance_push_test
```

### Step 2: 필요한 패키지 추가
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.3.0
```

### Step 3: iOS 설정
1. **Bundle ID 변경**
   - Xcode에서 `com.mycompany.luxappv1`로 설정
   
2. **Push Notifications Capability 추가**
   - Xcode > Signing & Capabilities > + Push Notifications
   
3. **Background Modes 추가**
   - Remote notifications 체크

### Step 4: Firebase 설정
1. **GoogleService-Info.plist 추가**
   - Firebase Console에서 다운로드
   - ios/Runner 폴더에 추가
   
2. **APNs 설정**
   - APNs Certificate 또는 Key 확인
   - Production 환경 지원 확인

### Step 5: Flutter 코드 구현
```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // FCM 설정
  await setupFCM();
  
  runApp(MyApp());
}

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  // 권한 요청
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // APNs 토큰 확인 (iOS)
    String? apnsToken = await messaging.getAPNSToken();
    print('APNs Token: $apnsToken');
    
    // FCM 토큰 가져오기
    String? fcmToken = await messaging.getToken();
    print('FCM Token: $fcmToken');
    
    // Supabase에 저장
    // await saveTokenToSupabase(fcmToken);
  }
  
  // 메시지 리스너 설정
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('포그라운드 메시지 수신: ${message.notification?.title}');
  });
  
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('알림 클릭으로 앱 열림: ${message.notification?.title}');
  });
}
```

## 🧪 테스트 계획

### 1. 개발 환경 테스트
- Xcode에서 직접 실행
- 콘솔 로그 확인
- FCM 토큰 생성 확인

### 2. TestFlight 테스트
- Archive 및 업로드
- TestFlight 설치
- Push Notification 테스트

### 3. 디버깅 체크리스트
- [ ] Firebase 프로젝트 ID 확인
- [ ] Bundle ID 일치 확인
- [ ] APNs 토큰 생성 확인
- [ ] FCM 토큰 생성 확인
- [ ] Firebase Console 테스트
- [ ] 실제 푸시 수신 확인

## 🔧 문제 해결 방법

### APNs Certificate 방식 사용
1. Apple Developer에서 Push Notification SSL Certificate 생성
2. .p12 파일로 export
3. Firebase Console에 업로드

### 환경 변수 확인
```dart
// 빌드 환경 확인
const bool isProduction = bool.fromEnvironment('dart.vm.product');
print('Production mode: $isProduction');
```

### 로그 수집
```dart
// FCM 토큰 갱신 리스너
FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
  print('새 FCM 토큰: $token');
  // Supabase 업데이트
});
```

## 📊 예상 결과

### 성공 시
- Xcode 콘솔에서 FCM 토큰 확인
- Firebase Console 테스트 성공
- iPhone에 푸시 알림 수신

### 실패 시 확인 사항
1. **UNREGISTERED**: FCM 토큰이 잘못된 프로젝트에서 생성
2. **BadEnvironmentKeyInToken**: APNs 환경 불일치
3. **MissingRegistration**: FCM 토큰 없음

## 📝 참고 사항

### Firebase 프로젝트 정보
- Project ID: `notification-f1653`
- Bundle ID: `com.mycompany.luxappv1`
- APNs Key ID: H2MJV57457
- Team ID: MF8K38N3NG

### Supabase 연동
- Project ID: `atkekzwgukdvucqntryo`
- users 테이블에 fcm_token 저장
- notifications 테이블에서 트리거

### 테스트 FCM 토큰
```
현재: ccmkZxCbCUtujitfdB9Co1:APA91bFpk4b3SwJ3_yPDZoFiQ4BvfbnFv21QHd5PUdeDY0dYnXdm9RvFGc7bh8r7MqXgh6E2IZa-k-uj7E6txZQFDWxmLX8UCk-IwNRxBhINWH7ca_x4rCw
```

## 🚀 다음 단계
1. Flutter 프로젝트 생성 및 설정
2. iOS 설정 완료
3. 개발 환경에서 테스트
4. 문제 확인 및 수정
5. TestFlight 배포 및 최종 테스트

---

**작성일**: 2025-08-18  
**목적**: FlutterFlow Push Notification 문제를 Flutter에서 직접 디버깅하여 해결
