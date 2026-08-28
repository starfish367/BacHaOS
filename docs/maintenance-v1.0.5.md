# Bảo trì pipeline v1.0.5

## Phát hiện

Run v1.0.4 hoàn tất thành công, không còn annotation runtime Node.js 20. MATE mất khoảng 29 phút, còn Cinnamon mất khoảng 47 phút. Một lần chạy trước đó bị người vận hành hủy khi MATE ở bước remaster; để tránh build không phản hồi chiếm runner không giới hạn, workflow cần giới hạn thời gian công khai và đủ rộng.

## Kết luận bảo trì

Job `build` đã có `timeout-minutes: 110`. Ngưỡng này lớn hơn thời lượng build v1.0.4 đã ghi nhận cho cả hai desktop, đồng thời dừng rõ ràng một job thực sự treo. Vì v1.0.4 không có lỗi hoặc cảnh báo mới, v1.0.5 không thay đổi quy trình remaster, nội dung ISO, upload SourceForge, checksum hoặc release asset; chỉ phát hành lại qua pipeline đã được kiểm chứng.
