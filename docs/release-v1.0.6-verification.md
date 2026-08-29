# Xác minh phát hành Bạc Hà OS v1.0.6

Workflow [33225677540][1] hoàn tất thành công tại commit `88d9311`, gồm build MATE và Cinnamon, upload ISO/checksum lên SourceForge và tạo GitHub Release công khai. Release [v1.0.6][2] không ở trạng thái draft và được xuất bản ngày 2026-08-29.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.6-20260829.iso][3] | `aaca91e0805958a8b76fd4c5258979d319aad7384af233de07d748e6dc3014e9` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.6-20260829.iso][5] | `14d4faa75ec58d3a947b179c15e9ccc74cb5ecdd27b4e89bde07fb3512b22714` | 4,085,645,312 |

Tệp checksum trên SourceForge [MATE][4] và [Cinnamon][6] trùng khớp với tài sản checksum tương ứng tại GitHub Release. Byte-range `0-0` của cả hai ISO trả HTTP `206`, xác nhận các liên kết công khai đã được lập chỉ mục và có thể phục vụ tải theo range. Báo cáo package của cả hai edition xác nhận Firefox và LibreOffice không có sẵn, còn OnlyOffice và `ntfs-3g` hiện diện.

Workflow được bổ sung guard `Refuse to overwrite an existing GitHub Release`: trước khi build, pipeline chứng minh tag v1.0.6 chưa tồn tại và sẽ dừng nếu một tag release đã có mặt. Guard này giảm nguy cơ chạy lại cùng phiên bản làm ghi đè hoặc tạo release không nhất quán.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33225677540 "Workflow Build Bac Ha OS ISO v1.0.6"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.6 "GitHub Release Bạc Hà OS v1.0.6"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.6-20260829.iso/download "ISO Bạc Hà OS MATE v1.0.6"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.6-20260829.iso.sha256/download "Checksum MATE v1.0.6"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.6-20260829.iso/download "ISO Bạc Hà OS Cinnamon v1.0.6"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.6-20260829.iso.sha256/download "Checksum Cinnamon v1.0.6"

## Ghi chú kỹ thuật

Cảnh báo timeout ở các lần thử mirror có thể xuất hiện trong log tải ISO, nhưng cả hai build v1.0.6 đã hoàn tất. Cảnh báo deprecation nội bộ của action tải artifact không chặn release; các action workflow vẫn dùng runtime Node.js 24 (`checkout@v5`, `upload-artifact@v7`, `download-artifact@v7`, `action-gh-release@v3`).
