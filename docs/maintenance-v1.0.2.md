# Bảo trì pipeline v1.0.2

## Phát hiện

Hai build gần nhất hoàn tất thành công, nhưng GitHub Actions phát cảnh báo rằng `actions/checkout@v4` và các action artifact v4 chạy runtime Node.js 20 đã bị ép qua Node.js 24. Đây là tín hiệu bảo trì, không phải lỗi ISO, nhưng nên loại bỏ để release tiếp theo không phụ thuộc compatibility mode.

## Quyết định

Pipeline sử dụng GitHub-hosted runner nên đáp ứng yêu cầu runner tối thiểu của action Node.js 24. Nâng `actions/checkout` lên major Node.js 24, `actions/upload-artifact`/`actions/download-artifact` lên major Node.js 24, và `softprops/action-gh-release` lên major Node.js 24. Vẫn giữ nguyên quy trình build, SourceForge rsync, kiểm tra SHA-256 và các release asset.

## Nguồn tham khảo

- [actions/checkout](https://github.com/actions/checkout): checkout runtime Node.js 24 yêu cầu runner từ `v2.327.1`.
- [actions/upload-artifact releases](https://github.com/actions/upload-artifact/releases): artifact v6 dùng Node.js 24 và yêu cầu runner từ `v2.327.1`.
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release): major v3 là dòng action release mới dùng Node.js 24.
