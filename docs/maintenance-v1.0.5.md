# Bảo trì pipeline v1.0.5

## Phát hiện

Run v1.0.4 hoàn tất thành công, không còn annotation runtime Node.js 20. MATE mất khoảng 29 phút, còn Cinnamon mất khoảng 47 phút. Một lần chạy trước đó bị người vận hành hủy khi MATE ở bước remaster; để tránh build không phản hồi chiếm runner không giới hạn, workflow cần giới hạn thời gian công khai và đủ rộng.

## Bản vá tải mirror

Run v1.0.5 đầu tiên thất bại trước remaster vì hai GitHub runner gặp lỗi TLS/timeout khi tải ISO từ mirror kernel.org. Workflow giờ thử lần lượt mirror kernel.org, NetCologne và IBCP; cả hai mirror dự phòng xuất hiện trong danh sách mirror công khai của Linux Mint và có thư mục ISO 22.3 cùng `sha256sum.txt`.

Mỗi mirror được xử lý như một cặp: workflow tải checksum trước, tải ISO từ **cùng mirror**, sau đó bắt buộc `sha256sum --check --strict` thành công mới chuyển sang build. Một mirror lỗi, thiếu checksum hoặc checksum không khớp sẽ bị bỏ qua. Job `build` vẫn giữ giới hạn 110 phút; không thay đổi remaster, nội dung ISO, upload SourceForge, checksum phát hành hay release asset.

## Nguồn

- [Linux Mint Mirrors](https://linuxmint.com/mirrors.php)
- [NetCologne: Linux Mint ISO 22.3](https://mirror.netcologne.de/linuxmint/iso/stable/22.3/)
- [IBCP: Linux Mint ISO 22.3](https://mirror.ibcp.fr/pub/linuxmint/iso/stable/22.3/)
