# Xác minh phát hành Bạc Hà OS v1.0.8

Workflow [33346431751][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.8][2] không ở trạng thái draft và được xuất bản ngày 2026-08-31.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.8-20260831.iso][3] | `5d5b2739b70d7dd071c9d988b3986b464ebd6912f2496407a8829c4dc86aa0da` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.8-20260831.iso][5] | `a2c625fea241e0948547a9ccf93a7252570f19cd9435132a851ba9a317dfb0da` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.8 giữ nguyên guard chống ghi đè release tag. Kiểm thử cục bộ YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33346431751 "Workflow Build Bac Ha OS ISO v1.0.8"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.8 "GitHub Release Bạc Hà OS v1.0.8"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.8-20260831.iso/download "ISO Bạc Hà OS MATE v1.0.8"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.8-20260831.iso.sha256/download "Checksum MATE v1.0.8"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.8-20260831.iso/download "ISO Bạc Hà OS Cinnamon v1.0.8"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.8-20260831.iso.sha256/download "Checksum Cinnamon v1.0.8"
