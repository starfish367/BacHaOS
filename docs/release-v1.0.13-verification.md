# Xác minh phát hành Bạc Hà OS v1.0.13

Workflow [33935321570][1] hoàn tất thành công, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.13][2] không ở trạng thái draft và được xuất bản ngày 2026-09-05.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.13-20260905.iso][3] | `90eee2558939f2133308bf6e6e197d96e841808a6ea5e6959b5872c342c386ea` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.13-20260905.iso][5] | `dcc7b4f88ba798c0b6e843c8e4e508268e0114e5033176022c72d7ccf94df52e` | 4,085,645,312 |

Checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng trên GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì v1.0.13 giữ guard chống ghi đè release tag. Kiểm thử YAML, Bash, ShellCheck, TypeScript và production build đều đạt; landing page đã được đồng bộ với dữ liệu phát hành thực tế.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33935321570 "Workflow Build Bac Ha OS ISO v1.0.13"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.13 "GitHub Release Bạc Hà OS v1.0.13"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.13-20260905.iso/download "ISO Bạc Hà OS MATE v1.0.13"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.13-20260905.iso.sha256/download "Checksum MATE v1.0.13"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.13-20260905.iso/download "ISO Bạc Hà OS Cinnamon v1.0.13"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.13-20260905.iso.sha256/download "Checksum Cinnamon v1.0.13"
