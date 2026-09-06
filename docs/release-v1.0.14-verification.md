# Xác minh phát hành Bạc Hà OS v1.0.14

Workflow [34002897184][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.14][2] không ở trạng thái draft và được xuất bản ngày 2026-09-06.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.14-20260906.iso][3] | `55c428040744069a742bda24d42fa57dfc5efc63d240759f618351832b2823e2` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.14-20260906.iso][5] | `205a38381088a0fa4d96c2a683898d946774ab7b1d7f6abce98feb31465537c9` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.14 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/34002897184 "Workflow Build Bac Ha OS ISO v1.0.14"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.14 "GitHub Release Bạc Hà OS v1.0.14"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.14-20260906.iso/download "ISO Bạc Hà OS MATE v1.0.14"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.14-20260906.iso.sha256/download "Checksum MATE v1.0.14"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.14-20260906.iso/download "ISO Bạc Hà OS Cinnamon v1.0.14"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.14-20260906.iso.sha256/download "Checksum Cinnamon v1.0.14"
