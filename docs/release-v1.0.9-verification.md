# Xác minh phát hành Bạc Hà OS v1.0.9

Workflow [33457862624][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.9][2] không ở trạng thái draft và được xuất bản ngày 2026-09-01.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.9-20260901.iso][3] | `971cbf1df7e26fe242979980a7abc04825fdb795ef74fd6ee2f4c5955ed2a5a3` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.9-20260901.iso][5] | `e053bb1aea5948785756802e08348036a44174b94fd58af8d0dd81036f9b4cb9` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.9 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33457862624 "Workflow Build Bac Ha OS ISO v1.0.9"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.9 "GitHub Release Bạc Hà OS v1.0.9"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.9-20260901.iso/download "ISO Bạc Hà OS MATE v1.0.9"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.9-20260901.iso.sha256/download "Checksum MATE v1.0.9"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.9-20260901.iso/download "ISO Bạc Hà OS Cinnamon v1.0.9"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.9-20260901.iso.sha256/download "Checksum Cinnamon v1.0.9"
