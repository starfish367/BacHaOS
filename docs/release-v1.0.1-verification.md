# Xác minh phát hành Bạc Hà OS v1.0.1

Workflow GitHub Actions [32796571295](https://github.com/starfish367/BacHaOS/actions/runs/32796571295) hoàn tất thành công ngày 2026-08-25. GitHub Release là [v1.0.1](https://github.com/starfish367/BacHaOS/releases/tag/v1.0.1); release công khai liên kết SourceForge cho cả hai ISO và hai tệp checksum.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.1-20260825.iso](https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.1-20260825.iso/download) | `1b4ed65ce3e27972e9bfcf989ee15095addaf8503d6d57294ca9b9cbbbdb88ed` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.1-20260825.iso](https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.1-20260825.iso/download) | `fd9bf3d3046cadecd8223882e9cd8fe57b581d43d2804c2fa07b63597d6e7c4d` | 4,081,647,616 |

Byte-range `0-0` trên cả hai URL SourceForge trả HTTP 206. Nội dung hai checksum SourceForge khớp checksum asset GitHub Release. Báo cáo package release xác nhận Firefox và LibreOffice không có sẵn, trong khi OnlyOffice Desktop Editors và `ntfs-3g` hiện diện ở cả MATE lẫn Cinnamon.
