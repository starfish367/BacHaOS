# Bảo trì cho Bạc Hà OS v1.0

Bản v1.0 chuyển trọng tâm sang một ISO gọn hơn nhưng vẫn giữ trải nghiệm tiếng Việt sẵn sàng. Firefox và toàn bộ LibreOffice không còn là ứng dụng mặc định; OnlyOffice vẫn là bộ văn phòng cài sẵn và sẽ có launcher chính thức trên Desktop/menu dùng icon do gói `onlyoffice-desktopeditors` cung cấp. BacHa OS Hello cung cấp lựa chọn cài LibreOffice khi người dùng chủ động yêu cầu và có kết nối mạng.

Tự gắn NTFS dùng `ntfs-3g` và các điểm gắn `/mnt/ocung1`, `/mnt/ocung2` theo thứ tự phân vùng được phát hiện. Tiện ích sẽ thử gắn đọc-ghi an toàn trước; nếu Windows đang hibernate hoặc Fast Startup thì chỉ dùng đọc, tuyệt đối không dùng `remove_hiberfile` và không xóa phiên Windows đang lưu. Mỗi kết quả được ghi log để BacHa OS Hello hiển thị trạng thái rõ ràng.

Nhận diện dùng logo Bạc Hà OS hiện có trong `assets/plymouth/bacha-logo-512.png`, giữ đồng nhất với splash screen. Phần branding desktop sẽ thay các logo Mint có thể tùy biến qua asset/configuration của bản remaster; không ghi đè tùy tiện các tệp thuộc gói hệ thống nếu chưa kiểm chứng vị trí hiển thị.

Audit dung lượng MATE ngày 2026-08-24 cho thấy OnlyOffice, Wine và Chrome là ba gói bên thứ ba chiếm dung lượng lớn nhất. V1.0 ưu tiên loại Firefox và LibreOffice theo yêu cầu, dọn cache build và không đưa gói văn phòng thứ hai vào ISO. Wine, Chrome và OnlyOffice vẫn được giữ nguyên cho tới khi có yêu cầu thay đổi riêng vì đây là thay đổi đáng kể về khả năng sử dụng, không chỉ là tối ưu kỹ thuật.

## Nguồn kỹ thuật

Tài liệu [`mount.ntfs-3g(8)`](https://linux.die.net/man/8/mount.ntfs-3g) xác nhận `windows_names`, UID/GID và mount chỉ đọc là các tuỳ chọn phù hợp; đồng thời nêu rõ `remove_hiberfile` sẽ làm mất phiên Windows đã lưu, nên v1.0 không sử dụng tuỳ chọn đó.

Schema [Mintmenu](https://github.com/linuxmint/mintmenu/blob/master/usr/share/glib-2.0/schemas/com.linuxmint.mintmenu.gschema.xml) định nghĩa khóa `applet-icon`, còn [Cinnamon Menu](https://github.com/linuxmint/Cinnamon/blob/master/files/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json) định nghĩa `menu-custom` và `menu-icon`. V1.0 sử dụng icon name `bacha-os` đã được cài vào hicolor theme thay vì thay đổi trực tiếp file logo của gói Linux Mint.
