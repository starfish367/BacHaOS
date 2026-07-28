#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
VERSION=${1:-0.1}
EDITION=${2:-mate}

# --- Locale + timezone tiếng Việt ---
locale-gen vi_VN.UTF-8
update-locale LANG=vi_VN.UTF-8
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
echo "Asia/Ho_Chi_Minh" > /etc/timezone

# --- Chấp nhận EULA font Microsoft tự động ---
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
  | debconf-set-selections

apt-get update
apt-get install -y wget gnupg

# --- Thêm repo OnlyOffice ---
wget -qO- https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE \
  | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" \
  > /etc/apt/sources.list.d/onlyoffice.list

# --- Thêm repo Google Chrome ---
wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
  | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
  > /etc/apt/sources.list.d/google-chrome.list

# --- Thêm repo WineHQ (noble = Ubuntu 24.04, base Mint 22) ---
dpkg --add-architecture i386
wget -qO- https://dl.winehq.org/wine-builds/winehq.key \
  | gpg --dearmor -o /usr/share/keyrings/winehq.gpg
echo "deb [signed-by=/usr/share/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/ubuntu/ noble main" \
  > /etc/apt/sources.list.d/winehq.list

# --- Update 1 lần duy nhất sau khi đã thêm ĐỦ cả 3 repo ---
apt-get update

# --- Cài toàn bộ gói (1 lần duy nhất) ---
xargs -a /tmp/packages.list apt-get install -y
apt-get install -y google-chrome-stable
apt-get install -y fcitx5 fcitx5-unikey fcitx5-config-qt
im-config -n fcitx5

# --- Codec đa phương tiện (nghe nhạc, xem video định dạng phổ biến) ---
apt-get install -y ubuntu-restricted-extras || \
apt-get install -y gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly gstreamer1.0-libav ffmpeg

# --- Cài sẵn Flatpak + Flathub remote (để user tự cài Bottles/app khác sau nếu cần) ---
apt-get install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Không cài Bottles sẵn — để ISO nhẹ, user tự cài qua Software Manager khi cần

# --- Set Chrome làm trình duyệt mặc định ---
xdg-settings set default-web-browser google-chrome.desktop || true
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable || true

# --- Font cache ---
fc-cache -f -v

# --- Gỡ gói theo remove list ---
xargs -a /tmp/remove.list apt-get purge -y || true
apt-get autoremove -y

# --- Tắt/mask service không cần chạy nền ---
SERVICES_DISABLE=(
  bluetooth.service
  ModemManager.service
  cups.service
  cups-browsed.service
  avahi-daemon.service
  whoopsie.service
  kerneloops.service
  apport.service
  motd-news.timer
  apt-daily.timer
  apt-daily-upgrade.timer
  snapd.service
  snapd.socket
)
for svc in "${SERVICES_DISABLE[@]}"; do
  systemctl disable "$svc" 2>/dev/null || true
  systemctl mask "$svc" 2>/dev/null || true
done

# --- Branding ---
echo "bac-ha-os" > /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1	bac-ha-os/" /etc/hosts
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Bạc Hà OS ${VERSION} (${EDITION^})\"/" /etc/os-release
sed -i "s/^NAME=.*/NAME=\"Bạc Hà OS\"/" /etc/os-release

# --- Set Plymouth theme mặc định là Bạc Hà OS ---
if command -v plymouth-set-default-theme &>/dev/null; then
  update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth \
    /usr/share/plymouth/themes/bacha/bacha.plymouth 100
  plymouth-set-default-theme -R bacha || true
fi

# --- Set wallpaper mặc định (ảnh 02 - ruộng bậc thang buổi sáng) ---
# Thực thi an toàn: lỗi sẽ được bỏ qua nếu gsettings không tồn tại trong môi trường chroot
gsettings set org.mate.background picture-filename \
  "/usr/share/backgrounds/bacha/02-ruong-bac-thang.jpg" 2>/dev/null || true
gsettings set org.cinnamon.desktop.background picture-uri \
  "file:///usr/share/backgrounds/bacha/02-ruong-bac-thang.jpg" 2>/dev/null || true

# --- Đăng ký bộ wallpaper vào trình chọn hình nền (MATE/Cinnamon Backgrounds settings) ---
mkdir -p /usr/share/mate-background-properties
cat > /usr/share/mate-background-properties/bacha.xml <<'XMLEOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "mate-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>Bạc Hà - Vịnh Hạ Long</name>
    <filename>/usr/share/backgrounds/bacha/01-ha-long.jpg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bạc Hà - Ruộng bậc thang</name>
    <filename>/usr/share/backgrounds/bacha/02-ruong-bac-thang.jpg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bạc Hà - Ruộng bậc thang sương sớm</name>
    <filename>/usr/share/backgrounds/bacha/03-ruong-bac-thang-suong.jpg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bạc Hà - Vịnh Hạ Long xanh ngọc</name>
    <filename>/usr/share/backgrounds/bacha/04-ha-long-xanh.jpg</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bạc Hà - Phố cổ Hà Nội</name>
    <filename>/usr/share/backgrounds/bacha/05-pho-co-ha-noi.jpg</filename>
    <options>zoom</options>
  </wallpaper>
</wallpapers>
XMLEOF

# --- Dọn file thừa (LUÔN LÀ BƯỚC CUỐI CÙNG, sau khi đã cài hết mọi thứ) ---
rm -rf /usr/share/doc/* /usr/share/man/* /var/cache/fontconfig/*
find /usr/share/locale -mindepth 1 -maxdepth 1 \
  ! -name 'vi*' ! -name 'en*' -exec rm -rf {} +

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm -f /var/log/*.log
