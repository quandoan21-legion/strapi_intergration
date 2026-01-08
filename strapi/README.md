# Tech-Events Hub – Strapi CMS

CMS cấu hình sẵn cho ứng dụng Flutter **Tech-Events Hub**. Dự án sử dụng Strapi v4 với SQLite (Quickstart). Các Content-type yêu cầu đã được định nghĩa trong thư mục `src/api`.

## Chuẩn bị & cài đặt

```bash
cd strapi
cp .env.example .env   # cập nhật các khóa bảo mật trước khi chạy
npm install
npm run develop        # hoặc: yarn develop
```

> **Lưu ý:** dự án yêu cầu Node.js >= 18 và <= 20. Khi chạy lần đầu, Strapi sẽ yêu cầu tạo tài khoản admin.

## Content-types

| Tên            | Mục đích                                                         | Thuộc tính chính                                                                                   |
|----------------|------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `Category`     | Quản lý danh mục sự kiện (Web, AI, Mobile, Cloud, …)             | `name`, `slug`, `description`, quan hệ 1-n với `Event`                                              |
| `Event`        | Lưu trữ thông tin sự kiện                                        | `title`, `slug`, `description (richtext)`, `startDate`, `location`, `cover` (media), `category`     |
| `Registration` | Lưu thông tin người tham gia gửi từ ứng dụng Tech-Events Hub     | `fullName`, `email`, `phone`, `notes`, `source`, liên kết tuỳ chọn với `event`                      |

Mỗi API đều sử dụng controller/routing/service mặc định từ Strapi (`createCoreController`, ...), vì vậy có thể mở rộng khi cần nghiệp vụ đặc biệt.

## API endpoints dùng cho Flutter

| Mục đích                      | Endpoint                             | Ghi chú                                                                                                                                     |
|-------------------------------|--------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Lấy danh mục                  | `GET /api/categories?sort[0]=name:asc` | Cấp quyền Public (`find`, `findOne`).                                                                                                      |
| Lấy danh sách sự kiện         | `GET /api/events?populate[cover]=*&populate[category]=*&pagination[page]=1&pagination[pageSize]=10` | Có filter `filters[category][id][$eq]=<id>`.                                                                                                |
| Gửi đăng ký tham gia          | `POST /api/registrations`            | Payload dạng `{ "data": { "fullName": "...", "email": "...", "phone": "...", "notes": "...", "event": <id?> } }`. Cần bật quyền Public `create`. |

Sau khi khởi chạy Strapi, truy cập trang Admin → *Settings → Users & Permissions Plugin → Roles → Public* và bật các quyền:

- `Category`: `find`
- `Event`: `find`, `findOne`
- `Registration`: `create`

## Đồng bộ với ứng dụng Flutter

1. Đảm bảo Strapi chạy ở `http://localhost:1337`. Nếu chạy trên server khác, build ứng dụng Flutter với `--dart-define=STRAPI_BASE_URL=<URL>` để cập nhật endpoint.
2. Tạo ít nhất vài Category + Event để trang Event list hiển thị dữ liệu.
3. Theo dõi các lượt đăng ký tại menu `Content Manager → Registrations`. Dữ liệu gửi từ app sẽ hiển thị tức thì vì content-type không bật Draft/Publish.

## Scripts hữu ích

- `npm run develop`: chạy Strapi với hot-reload
- `npm run start`: chạy production build
- `npm run build`: build admin panel

Thư mục `strapi` có thể commit chung cùng mã Flutter để đảm bảo backend/frontend đồng bộ cấu hình.
