# Xác minh phát hành Bạc Hà OS v1.0.15

Workflow [34071879593][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.15][2] không ở trạng thái draft và được xuất bản ngày 2026-09-07.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.15-20260907.iso][3] | `c11d9de1aff676aa52b243636f915aeefac919eeb30da6cb6aa9c20915123f8a` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.15-20260907.iso][5] | `9c8fac890dc096d5af5cf8f6e23627880a511aebbd76880264645229e2f82d9b` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.15 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/34071879593 "Workflow Build Bac Ha OS ISO v1.0.15"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.15 "GitHub Release Bạc Hà OS v1.0.15"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.15-20260907.iso/download "ISO Bạc Hà OS MATE v1.0.15"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.15-20260907.iso.sha256/download "Checksum MATE v1.0.15"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.15-20260907.iso/download "ISO Bạc Hà OS Cinnamon v1.0.15"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.15-20260907.iso.sha256/download "Checksum Cinnamon v1.0.15"
