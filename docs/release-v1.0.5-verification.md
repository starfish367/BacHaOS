# Xác minh phát hành Bạc Hà OS v1.0.5

Workflow [33132541476][1] hoàn tất với trạng thái thành công tại commit `211157f359272c3a3a258a10df2decf1214c2f3a`. GitHub Release [v1.0.5][2] được xuất bản công khai, không phải bản nháp, với tám tài sản gồm hai tệp checksum, hai báo cáo danh sách gói và hai báo cáo dung lượng.

| Edition | ISO SourceForge | SHA-256 | ISO bytes |
|---|---|---|---:|
| MATE | [bac-ha-os-mate-1.0.5-20260828.iso][3] | `f7186d97ed7a5cd5411b0329c5e18adb849953580b1ec71528f44041630f5a0b` | 4,119,134,208 |
| Cinnamon | [bac-ha-os-cinnamon-1.0.5-20260828.iso][5] | `8cf7058c5e56de04d2cf3e08a82dfa2573c23fb6ce10b7376b44160da4619fbe` | 4,085,645,312 |

Thử byte-range `0-0` trên hai liên kết ISO SourceForge đều nhận HTTP `206`. Nội dung hai tệp checksum SourceForge [MATE][4] và [Cinnamon][6] trùng khớp từng hash với tài sản checksum gắn tại GitHub Release. Báo cáo package của cả hai edition xác nhận **Firefox** và **LibreOffice** không có sẵn; **OnlyOffice Desktop Editors** và `ntfs-3g` vẫn hiện diện.

Pipeline v1.0.5 đã vượt qua các lỗi timeout kết nối tạm thời nhờ cơ chế thử mirror Linux Mint theo thứ tự có đối chiếu `sha256sum.txt` cùng mirror. Log không còn cảnh báo ngừng hỗ trợ Node.js 20; có một cảnh báo không chặn `DEP0005` liên quan `Buffer()` ở bước tải build report, nhưng workflow vẫn hoàn tất thành công. Cảnh báo này được ghi nhận để tiếp tục theo dõi ở các lần nâng action sau, không ảnh hưởng đến tính toàn vẹn ISO đã đối chiếu checksum.

## Tài liệu tham chiếu

[1]: https://github.com/starfish367/BacHaOS/actions/runs/33132541476 "Workflow Build Bac Ha OS ISO v1.0.5"
[2]: https://github.com/starfish367/BacHaOS/releases/tag/v1.0.5 "GitHub Release Bạc Hà OS v1.0.5"
[3]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.5-20260828.iso/download "ISO Bạc Hà OS MATE v1.0.5"
[4]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-mate-1.0.5-20260828.iso.sha256/download "Checksum MATE v1.0.5"
[5]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.5-20260828.iso/download "ISO Bạc Hà OS Cinnamon v1.0.5"
[6]: https://sourceforge.net/projects/bac-ha-os/files/bac-ha-os-cinnamon-1.0.5-20260828.iso.sha256/download "Checksum Cinnamon v1.0.5"
