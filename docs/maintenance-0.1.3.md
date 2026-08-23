# Bảo trì cho bản 0.1.3

Đợt bảo trì này thay đổi pipeline build theo hướng có thể kiểm tra hơn: đường dẫn được chuẩn hoá, shell strict mode được bật, mọi mount chroot được dọn qua trap khi build thất bại, output có manifest phát hành và mỗi ISO sinh ra tệp SHA-256 riêng. Workflow xác minh ISO Linux Mint tải về bằng `sha256sum.txt`, lint script bằng ShellCheck, kiểm tra output trước khi upload và chỉ tạo GitHub Release sau khi cả MATE lẫn Cinnamon hoàn tất.

Các liên kết SourceForge trong release được tạo từ manifest cùng tên tệp thực tế của mỗi build thay vì wildcard. Điều này giúp người dùng có liên kết ISO và checksum chính xác cho từng phiên bản.
