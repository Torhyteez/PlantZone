# plantzone

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🛠 Setup & Configuration

Dự án này sử dụng Firebase. Vì lý do bảo mật, các file cấu hình (`firebase_options.dart`) không được public. Vui lòng làm theo các bước sau để thiết lập môi trường:

### Yêu cầu:
- Đã cài đặt [Flutter SDK](https://flutter.dev/docs/get-started/install).
- Đã cài đặt [Firebase CLI](https://firebase.google.com/docs/cli).

### Các bước thiết lập:

1. **Clone dự án:**
   ```bash
   git clone https://github.com/Torhyteez/PlantZone
   cd [TEN_THU_MUC]
2. **Cài đặt thư viện**
    flutter pub get
3. Cấu hình firebase
    - Đăng nhập vào firebase
        firebase login
    - Kích hoạt FlutterFire CLI
        dart pub global activate flutterfire_cli
    - Kết nối dự án với Firebase của bạn
        flutterfire configure
