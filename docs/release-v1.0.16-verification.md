# Xác minh phát hành Bạc Hà OS v1.0.16

Workflow [34175757719][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.16][2] không ở trạng thái draft và được xuất bản ngày 2026-09-08.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.16-20260908.iso][3] | `530f255d0db024988c628dad7644032cf97f5b57075b67934e861d73748f5e6b` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.16-20260908.iso][5] | `68c0dff757528dbb751eb37a385c72e5cb50feb33609b29814fea89b872b8231` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.16 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/34175757719 "Workflow Build Bac Ha OS ISO v1.0.16"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.16 "GitHub Release Bạc Hà OS v1.0.16"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.16-20260908.iso/download "ISO Bạc Hà OS MATE v1.0.16"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.16-20260908.iso.sha256/download "Checksum MATE v1.0.16"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.16-20260908.iso/download "ISO Bạc Hà OS Cinnamon v1.0.16"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.16-20260908.iso.sha256/download "Checksum Cinnamon v1.0.16"
