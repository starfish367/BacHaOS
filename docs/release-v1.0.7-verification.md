# Xác minh phát hành Bạc Hà OS v1.0.7

Workflow [33285105486][1] hoàn tất thành công tại commit `832754b`, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.7][2] không ở trạng thái draft và được xuất bản ngày 2026-08-30.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.7-20260830.iso][3] | `16c3e1bc2b9a6bbde9cc46f9c9f01599d528cac52b3eeb3842941f7cc0215e8c` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.7-20260830.iso][5] | `2a3d07ce6300ce48f1e35949635bdfedf1922bf9086c61e7c426b339c6890965` | 4,085,645,312 |

Tệp checksum trên SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng tại GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`, xác nhận liên kết công khai đã được lập chỉ mục và sẵn sàng phục vụ tải theo range. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Bản bảo trì này bổ sung guard `Refuse to overwrite an existing GitHub Release`: trước khi build, pipeline chứng minh tag v1.0.7 chưa tồn tại và sẽ dừng nếu tag release đã có mặt. Kiểm thử cục bộ YAML, Bash và ShellCheck đều đạt; landing page đã được đồng bộ với các dữ liệu nêu trên.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33285105486 "Workflow Build Bac Ha OS ISO v1.0.7"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.7 "GitHub Release Bạc Hà OS v1.0.7"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.7-20260830.iso/download "ISO Bạc Hà OS MATE v1.0.7"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.7-20260830.iso.sha256/download "Checksum MATE v1.0.7"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.7-20260830.iso/download "ISO Bạc Hà OS Cinnamon v1.0.7"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.7-20260830.iso.sha256/download "Checksum Cinnamon v1.0.7"
