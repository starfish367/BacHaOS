# Nguồn dữ liệu công khai cho website Bạc Hà OS v1.0

## Lượt tải SourceForge

Nguồn chính thức: [SourceForge Download Stats API](https://sourceforge.net/p/forge/documentation/Download%20Stats%20API/).

Endpoint cấp dự án có dạng:

```text
https://sourceforge.net/projects/bac-ha-os/files/stats/json?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&period=monthly&os_by_country=false
```

`start_date` và `end_date` là bắt buộc; API trả JSON và có trường `stats_updated` cho thời điểm dữ liệu được cập nhật. Website chỉ hiển thị tổng được tính từ phản hồi này cùng thời điểm cập nhật, không tự tạo số liệu.

## Phản hồi cộng đồng

Website chỉ được đưa vào tín hiệu công khai có nguồn: số GitHub stars/forks/open issues qua GitHub REST API và, nếu có, số đánh giá/review công khai từ trang SourceForge. Không tạo, seed hoặc trình bày nhận xét/rating/testimonial giả.

## Snapshot đã xác minh

Ngày 2026-08-24, endpoint cho khoảng 2026-08-01 đến 2026-08-24 trả `total: 128`, với `stats_updated: 2026-08-24 06:01:13` UTC. Dữ liệu có `last_period_incomplete: true`, do đó nếu hiển thị trên website phải ghi rõ đây là lượt tải trong khoảng thời gian đang diễn ra, không phải tổng lịch sử.

Endpoint có header `Access-Control-Allow-Origin: *`, nên landing page tĩnh có thể đọc trực tiếp tại trình duyệt. Trang Reviews của SourceForge hiển thị `Downloads: 115 This Week` tại thời điểm kiểm tra nhưng chưa có review/rating công khai. GitHub REST API tại cùng thời điểm trả 1 star, 0 fork và 0 open issue. Website sẽ hiển thị các chỉ dấu này cùng liên kết nguồn và không suy diễn thành testimonial.
