# Bảo trì pipeline v0.1.4

Bản bảo trì này tập trung vào tính lặp lại và khả năng kiểm chứng của quy trình phát hành. Workflow chỉ chấp nhận phiên bản theo định dạng `MAJOR.MINOR.PATCH`, kiểm tra định dạng SHA-256 của ISO gốc và dùng retry, timeout cùng ngưỡng tốc độ tối thiểu khi tải dữ liệu nền.

Pipeline nay chạy ShellCheck, kiểm tra desktop entry và mock test BacHa OS Hello trước khi remaster. Script chroot dùng xử lý lỗi nghiêm ngặt, retry khi APT tải gói, keyring không tương tác và Flathub được khai báo ở phạm vi system. Báo cáo Flatpak được đưa vào artifact và GitHub Release, cùng checksum của hai ISO.

Upload SourceForge vẫn dùng `rsync --append-verify`, nhưng khóa SSH tạm được xóa sau job và workflow kiểm tra tệp ISO cùng checksum ở đích trước khi release job tạo GitHub Release. Release notes luôn đặt liên kết ISO và checksum từ SourceForge cho cả MATE lẫn Cinnamon.
