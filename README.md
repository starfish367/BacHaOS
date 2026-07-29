# Bạc Hà OS

Bạc Hà OS là bản remaster dựa trên Linux Mint, được thiết kế cho người dùng Việt Nam. Hệ thống có giao diện tiếng Việt mặc định, hỗ trợ gõ tiếng Việt, tích hợp các ứng dụng quen thuộc và được tối ưu để chạy tốt trên cả những máy có cấu hình khiêm tốn.

## Điểm nổi bật

- **Tiếng Việt mặc định:** ngôn ngữ hệ thống và múi giờ `Asia/Ho_Chi_Minh`.
- **Gõ tiếng Việt:** cài sẵn `fcitx5-unikey`.
- **Ứng dụng văn phòng:** OnlyOffice với các lối tắt riêng cho Word, Excel và PowerPoint.
- **Trình duyệt:** Google Chrome làm trình duyệt mặc định, đồng thời giữ Firefox.
- **Ứng dụng web:** lối tắt cho Zalo và YouTube, chạy như các ứng dụng riêng.
- **Tương thích Windows:** hỗ trợ Wine; Bottles có thể được cài từ trình quản lý ứng dụng của Bạc Hà OS.
- **Phông chữ:** bộ font Unicode gồm Noto và Microsoft Core Fonts.
- **Tối ưu máy yếu:** giảm các dịch vụ nền không cần thiết như Snap, Bluetooth và CUPS khi phù hợp.
- **Hai phiên bản:** MATE nhẹ và tiết kiệm tài nguyên; Cinnamon hiện đại với hiệu ứng đầy đủ.

## Cấu trúc repository

```text
BacHaOS/
├── .github/workflows/
│   └── build.yml                 # GitHub Actions tự động build ISO
├── assets/
│   ├── zalo/                     # Icon và lối tắt Zalo Web
│   ├── youtube/                  # Icon và lối tắt YouTube Web
│   └── onlyoffice-templates/     # Template và lối tắt OnlyOffice
├── config/
│   ├── packages.list             # Danh sách gói cài thêm
│   ├── remove-mate.list          # Gói loại bỏ cho bản MATE
│   ├── remove-cinnamon.list      # Gói loại bỏ cho bản Cinnamon
│   └── preseed.cfg               # Thiết lập tự động ngôn ngữ và múi giờ
├── scripts/
│   ├── build.sh                  # Script build remaster chính
│   └── customize.sh              # Tùy biến hệ thống trong môi trường chroot
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Build ISO

Cách đơn giản nhất là dùng GitHub Actions:

1. Mở tab **Actions** của repository.
2. Chọn workflow **Build Bac Ha OS ISO**.
3. Chọn **Run workflow**.
4. Nhập số phiên bản, ví dụ `0.1`, rồi bắt đầu workflow.
5. Chờ quá trình build hoàn tất. Việc build cả hai phiên bản thường mất khoảng 20–40 phút.
6. Tải file `.iso` từ phần **Releases** hoặc artifact của workflow.

## Đóng góp

Bạn có thể báo lỗi, đề xuất cải tiến bằng cách tạo **Issue**, hoặc gửi **Pull Request** với thay đổi cụ thể. Vui lòng đọc `CONTRIBUTING.md` trước khi đóng góp.

## Giấy phép

Dự án dựa trên Linux Mint và được phát hành theo **GNU General Public License v3.0 (GPL-3.0)**. Các script, cấu hình và phần mã nguồn do dự án này cung cấp cũng được phát hành theo GPL-3.0. Xem chi tiết trong file [LICENSE](LICENSE).

Nếu bạn fork, sửa đổi hoặc phân phối lại dự án, hãy tuân thủ các điều khoản của GPL-3.0 và công khai mã nguồn của phần đã sửa theo yêu cầu của giấy phép.
