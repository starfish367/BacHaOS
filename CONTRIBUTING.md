# Đóng góp cho Bạc Hà OS

Cảm ơn bạn quan tâm đóng góp cho dự án! Đây là hướng dẫn nhanh để bắt đầu.

## Cách đóng góp

### 1. Báo lỗi (Bug report)
Tạo Issue mới, mô tả:
- Bản build nào bị lỗi (MATE hay Cinnamon, version nào)
- Log lỗi từ GitHub Actions (copy nguyên đoạn báo lỗi)
- Các bước tái hiện lỗi (nếu là lỗi sau khi cài lên máy thật)

### 2. Đề xuất tính năng
Tạo Issue với nhãn `enhancement`, mô tả tính năng muốn thêm và lý do.

### 3. Gửi Pull Request
1. Fork repo
2. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`
3. Sửa code, test kỹ trước khi commit
4. Push lên fork của bạn, tạo Pull Request về nhánh `main`

## Cấu trúc code cần biết trước khi sửa

| File | Vai trò |
|---|---|
| `scripts/build.sh` | Điều phối toàn bộ quá trình remaster ISO |
| `scripts/customize.sh` | Chạy **bên trong chroot** — cài gói, gỡ gói, đổi branding |
| `config/packages.list` | Thêm/bớt gói cài sẵn |
| `config/remove-*.list` | Thêm/bớt gói cần gỡ theo từng edition |
| `assets/*/` | Icon + file `.desktop` cho từng ứng dụng shortcut |

## Quy tắc khi sửa `customize.sh`

**Thứ tự bắt buộc phải giữ:**
1. Thêm repo (OnlyOffice, Chrome, WineHQ...)
2. `apt-get update` (chỉ 1 lần, sau khi đã thêm đủ mọi repo)
3. Cài đặt gói
4. Gỡ gói / tắt service
5. Branding (hostname, os-release)
6. **Dọn dẹp — luôn là bước cuối cùng** (`apt-get clean`, xoá cache/log)

Đảo lộn thứ tự này (đặc biệt là dọn dẹp không nằm cuối) là lỗi phổ biến nhất từng gặp trong dự án.

## Quy tắc khi thêm app mới dạng overlay (giống Zalo/YouTube)

1. Tạo thư mục `assets/ten-app/`
2. Thêm icon (`.png`) + file `.desktop`
3. Copy đoạn overlay trong `build.sh`, đặt **trước** dòng `mksquashfs` (không đặt sau — sẽ không có tác dụng vì ISO đã đóng gói xong)

## Test trước khi gửi PR

Chạy thử workflow trên fork của bạn (tab Actions → Run workflow) trước khi tạo Pull Request, đảm bảo build không lỗi.

## Quy tắc đặt tên commit

Dùng tiếng Việt hoặc tiếng Anh đều được, miễn rõ ràng:
- `Fix: sửa lỗi thứ tự cài đặt Wine`
- `Add: thêm shortcut Google Docs`
- `Update: cập nhật danh sách gói gỡ bỏ cho Cinnamon`
