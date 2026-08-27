# Bảo trì pipeline v1.0.4

## Phát hiện và bản vá

Workflow v1.0.3 đã build được cả MATE/Cinnamon, xác minh SourceForge trước release và tạo release thành công. Tuy nhiên log release còn cảnh báo `actions/download-artifact@v6` dùng runtime Node.js 20 bị ép sang Node.js 24.

`actions/download-artifact@v7` và `actions/upload-artifact@v7` đều khai báo `runs.using: node24`, đồng thời giữ các input pipeline đang sử dụng: `path`, `pattern`, `merge-multiple` với download; `name`, `path`, `if-no-files-found` với upload. Vì vậy v1.0.4 nâng hai action cùng lúc, không thay đổi định dạng artifact/report hay cơ chế SourceForge.

## Nguồn

- [action.yml download-artifact v7](https://raw.githubusercontent.com/actions/download-artifact/v7/action.yml)
- [action.yml upload-artifact v7](https://raw.githubusercontent.com/actions/upload-artifact/v7/action.yml)
