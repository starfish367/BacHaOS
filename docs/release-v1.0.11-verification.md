# Xác minh phát hành Bạc Hà OS v1.0.11

Workflow [33702591812][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.11][2] không ở trạng thái draft và được xuất bản ngày 2026-09-03.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.11-20260903.iso][3] | `f272a6ba7ff2c0492b8d3c522d3e923ca9e56a1c17ae06e76a38701c3b4eb8a1` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.11-20260903.iso][5] | `4e1ef650cd0aa0d36f9dd71b9e91db5e312b1f75f6b0012d3914066303d7499b` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.11 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33702591812 "Workflow Build Bac Ha OS ISO v1.0.11"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.11 "GitHub Release Bạc Hà OS v1.0.11"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.11-20260903.iso/download "ISO Bạc Hà OS MATE v1.0.11"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.11-20260903.iso.sha256/download "Checksum MATE v1.0.11"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.11-20260903.iso/download "ISO Bạc Hà OS Cinnamon v1.0.11"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.11-20260903.iso.sha256/download "Checksum Cinnamon v1.0.11"
