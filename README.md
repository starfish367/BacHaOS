# Bạc Hà OS

Bản Linux Mint (MATE / Cinnamon) remaster dành cho người Việt — cài đặt tiếng Việt mặc định, driver đầy đủ, tối ưu cho máy cấu hình yếu, và cài sẵn các ứng dụng phổ biến ở Việt Nam.

## Tính năng

- 🇻🇳 Ngôn ngữ tiếng Việt + múi giờ Asia/Ho_Chi_Minh mặc định
- ⌨️ Bộ gõ tiếng Việt: fcitx5-unikey
- 📝 Bộ Office: OnlyOffice (Word/Excel/PowerPoint riêng biệt trên Desktop)
- 🌐 Trình duyệt: Google Chrome (mặc định), Firefox (giữ song song)
- 💬 Zalo, YouTube: shortcut web app chạy như ứng dụng riêng
- 🍷 Wine + Bottles: chạy được ứng dụng/game Windows
- 🔤 Font Unicode đầy đủ (Noto + Microsoft core fonts)
- 🪶 Tối ưu máy yếu: gỡ/tắt các dịch vụ nền không cần thiết (snap, bluetooth, cups...)
- 📦 2 phiên bản: **MATE** (nhẹ) và **Cinnamon** (đẹp, đầy đủ hiệu ứng)

## Cấu trúc repo
BacHaOS/
├── .github/workflows/build.yml   # GitHub Actions build ISO tự động
├── config/
│   ├── packages.list             # Danh sách gói cài thêm
│   ├── remove-mate.list          # Gói gỡ bỏ (bản MATE)
│   ├── remove-cinnamon.list      # Gói gỡ bỏ (bản Cinnamon)
│   └── preseed.cfg               # Tự động chọn ngôn ngữ/timezone lúc cài
├── scripts/
│   ├── build.sh                  # Script remaster chính
│   └── customize.sh              # Tuỳ biến bên trong ISO (chạy trong chroot)
└── assets/
├── zalo/                     # Icon + shortcut Zalo Web
├── youtube/                  # Icon + shortcut YouTube Web
└── onlyoffice-templates/     # File mẫu + shortcut Word/Excel/PowerPoint


## Cách build ISO

1. Vào tab **Actions** → chọn workflow **"Build Bac Ha OS ISO"**
2. Bấm **"Run workflow"**, nhập số phiên bản (ví dụ `0.1`)
3. Đợi build xong (khoảng 20-40 phút cho cả 2 edition)
4. Vào tab **Releases** để tải file `.iso`

## Đóng góp

Mọi ý kiến đóng góp, báo lỗi vui lòng tạo Issue hoặc Pull Request.

## Giấy phép

Dự án dựa trên Linux Mint (GPL). Bản thân các script trong repo này được phát hành dưới giấy phép MIT.
