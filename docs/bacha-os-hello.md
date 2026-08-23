# BacHa OS Hello

**BacHa OS Hello** là tiện ích một chạm để người dùng gắn các phân vùng NTFS dữ liệu sau khi đăng nhập vào Bạc Hà OS. Ứng dụng nằm trên Desktop và trong menu hệ thống; đồng thời một tác vụ autostart chạy lặng lẽ khi vào MATE hoặc Cinnamon.

## Nguyên tắc an toàn

Ứng dụng chỉ tìm các phân vùng có filesystem NTFS chưa được mount. Mọi phân vùng đã được gắn kết đều bị bỏ qua. Thao tác mount đi qua `udisksctl` trong phiên người dùng, do đó sử dụng các tuỳ chọn an toàn của UDisks và không cần script chạy quyền root. Nếu phân vùng Windows đang ngủ đông hoặc Fast Startup đang bật, ứng dụng không ép ghi; thay vào đó, nó báo lỗi để người dùng tắt hoàn toàn Windows trước khi thử lại.

## Cách dùng

Mở **BacHa OS Hello** rồi bấm một lần để ứng dụng quét và gắn các phân vùng NTFS phù hợp. Khi có kết quả, cửa sổ sẽ cho biết phân vùng nào đã gắn, phân vùng nào đã được gắn từ trước và phân vùng nào cần xử lý thêm. Nhật ký theo người dùng được lưu ở `~/.local/state/bacha-os-hello/mount.log`.

## Tắt tự động gắn kết

Người dùng có thể tắt autostart riêng cho tài khoản của mình bằng cách tạo tệp `~/.config/autostart/bacha-os-hello-autostart.desktop` với nội dung sau:

```ini
[Desktop Entry]
Hidden=true
```

## Tham khảo

[1] https://manpages.ubuntu.com/manpages/bionic/man1/udisksctl.1.html — `udisksctl` mount qua UDisks.

[2] https://storaged.org/udisks/docs/mount_options.html — chính sách mount option và bảo mật UDisks.

[3] https://specifications.freedesktop.org/autostart/latest/ — chuẩn autostart cho desktop Linux.
