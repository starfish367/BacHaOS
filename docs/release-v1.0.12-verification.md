# Xác minh phát hành Bạc Hà OS v1.0.12

Workflow [33824824521][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.12][2] không ở trạng thái draft và được xuất bản ngày 2026-09-04.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.12-20260904.iso][3] | `16a4c2b85f9ca215d5f550911f9732b78b957362d98fab910ae6f08cdd0acc0b` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.12-20260904.iso][5] | `6fdf6983b34a45258be3919db7fb33dd8920e8a9bc0504426910e9af9659f8a3` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.12 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33824824521 "Workflow Build Bac Ha OS ISO v1.0.12"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.12 "GitHub Release Bạc Hà OS v1.0.12"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.12-20260904.iso/download "ISO Bạc Hà OS MATE v1.0.12"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.12-20260904.iso.sha256/download "Checksum MATE v1.0.12"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.12-20260904.iso/download "ISO Bạc Hà OS Cinnamon v1.0.12"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.12-20260904.iso.sha256/download "Checksum Cinnamon v1.0.12"
