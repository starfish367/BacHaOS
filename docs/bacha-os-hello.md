# BacHa OS Hello

**BacHa OS Hello** là tiện ích một chạm của Bạc Hà OS v1.0. Ứng dụng nằm trên Desktop và trong menu hệ thống. Khi đăng nhập MATE hoặc Cinnamon, tác vụ autostart sẽ quét các phân vùng NTFS chưa gắn và thử gắn chúng một cách an toàn.

## Gắn ổ NTFS

Các phân vùng NTFS được gắn tuần tự bằng `ntfs-3g` tại `/mnt/ocung1`, `/mnt/ocung2` và tiếp tục tăng số khi có nhiều ổ. Tệp tạo trong ổ dùng UID/GID của người dùng desktop hiện tại, có `windows_names` để tránh đặt tên không tương thích Windows, cùng `noatime,norecover` để không tự ý dọn journal Windows.

Nếu Windows đang hibernate hoặc Fast Startup làm phân vùng không thể gắn đọc-ghi, BacHa OS Hello chỉ thử gắn **chỉ đọc**. Tiện ích không dùng `remove_hiberfile`, không ép ghi và không xóa phiên Windows đã lưu. Muốn gắn đọc-ghi trở lại, hãy khởi động vào Windows, tắt hoàn toàn máy và tắt Fast Startup trước khi quay lại Bạc Hà OS.

Kết quả mỗi lần chạy được lưu trong `~/.local/state/bacha-os-hello/mount.log`. Mở BacHa OS Hello để chọn gắn ổ, xem trạng thái hoặc chạy lựa chọn cài LibreOffice.

## LibreOffice theo yêu cầu

OnlyOffice là bộ văn phòng mặc định và có launcher/icon riêng trên Desktop/menu. Để giảm dung lượng ISO, LibreOffice không được cài sẵn. Người dùng có thể chọn **Cài LibreOffice theo yêu cầu** trong BacHa OS Hello; hệ thống sẽ hỏi xác nhận, tải gói LibreOffice và gói tiếng Việt từ kho phần mềm khi có kết nối mạng.

## Tắt tự động gắn kết

Người dùng có thể tắt autostart riêng cho tài khoản của mình bằng cách tạo tệp `~/.config/autostart/bacha-os-hello-autostart.desktop` với nội dung sau:

```ini
[Desktop Entry]
Hidden=true
```

## Tham khảo

[1] https://linux.die.net/man/8/mount.ntfs-3g — tài liệu `mount.ntfs-3g`, gồm quyền sở hữu, `windows_names`, mount chỉ đọc và cảnh báo với `remove_hiberfile`.

[2] https://specifications.freedesktop.org/autostart/latest/ — chuẩn autostart cho desktop Linux.
