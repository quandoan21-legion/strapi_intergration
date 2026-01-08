# Tech-Events Hub

Ứng dụng Flutter + Strapi giúp Global Tech Solutions quản lý và nhận đăng ký cho các buổi hội thảo, workshop và tech-talk.

## Tính năng chính

- Splash screen với logo Global Tech Solutions, hiệu ứng chuyển cảnh mượt mà.
- BottomNavigationBar cho 2 màn hình chính: danh sách sự kiện & form đăng ký.
- Danh sách sự kiện kết nối trực tiếp Strapi, hỗ trợ phân trang vô hạn khi cuộn.
- Bộ lọc Category (lấy realtime từ Strapi).
- Form đăng ký với validate họ tên, email, số điện thoại và gửi POST vào content-type `Registration`.

## Yêu cầu môi trường

- Flutter 3.10+ (Dart 3)
- Node 18+ (cho Strapi v4)

## Cấu trúc

```
lib/                     # Flutter app
strapi/                  # Cấu hình Strapi CMS (content-types, config)
```

## Thiết lập Strapi

```
cd strapi
cp .env.example .env     # cập nhật khóa bảo mật
npm install
npm run develop
```

Trong trang admin:

1. Tạo Category, Event, Registration mẫu.
2. Vào *Settings → Users & Permissions → Roles → Public* và bật quyền `find` cho Category/Event, `findOne` cho Event, `create` cho Registration.

> API chạy mặc định tại `http://localhost:1337`. Triển khai server khác chỉ cần cập nhật biến môi trường `STRAPI_BASE_URL`.

## Chạy Flutter app

```bash
flutter pub get
flutter run --dart-define=STRAPI_BASE_URL=http://localhost:1337
```

### Kiểm thử flow (để quay video demo)

1. Mở app → Splash hiển thị logo GTS → chuyển vào Home.
2. Tab Sự kiện: scroll để thấy phân trang vô hạn; chọn danh mục để lọc.
3. Tab Đăng ký: nhập họ tên, email, số điện thoại và gửi. Sau khi success, kiểm tra mục Registrations trong Strapi để xác nhận dữ liệu lưu thành công.

## Tuỳ chỉnh

- Thay đổi màu sắc chính trong `ThemeData` tại `lib/main.dart`.
- Cập nhật endpoint Strapi bằng `--dart-define=STRAPI_BASE_URL=<url>`.
- Các models/services Flutter nằm ở `lib/models` và `lib/services/strapi_api_client.dart` để dễ mở rộng.
# strapi_intergration
