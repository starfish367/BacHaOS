# Xác minh phát hành Bạc Hà OS v1.0.2

Workflow [32918141869](https://github.com/starfish367/BacHaOS/actions/runs/32918141869) hoàn tất thành công sau khi pipeline nâng `checkout`, artifact và release action lên runtime Node.js 24. GitHub Release là [v1.0.2](https://github.com/starfish367/BacHaOS/releases/tag/v1.0.2), gồm SourceForge URL, hai tệp checksum, báo cáo package và báo cáo dung lượng.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.2-20260826.iso](https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.2-20260826.iso/download) | `759e555489ca7af4d92b62e3d78bd25765f94f9b92466f889fa3a6caaad5b9ba` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.2-20260826.iso](https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.2-20260826.iso/download) | `d3d84c30644886cf09e68ed98ad7dd565cedc63f10784076630bb43a15ec192d` | 4,085,645,312 |

Sau khi SourceForge hoàn tất lập chỉ mục, byte-range `0-0` trả HTTP 206 cho cả MATE lẫn Cinnamon. Nội dung GitHub Release có hai link SourceForge. Báo cáo package xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice Desktop Editors cùng `ntfs-3g` vẫn có trong hai bản ISO.
