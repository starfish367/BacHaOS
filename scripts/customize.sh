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

# --- Chấp nhận EULA font Microsoft tự động (tránh build đứng lại chờ input) ---
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
  | debconf-set-selections

# --- Thêm repo OnlyOffice ---
apt-get update
apt-get install -y wget gnupg
wget -qO- https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE \
  | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" \
  > /etc/apt/sources.list.d/onlyoffice.list

# --- Thêm repo Google Chrome ---
wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
  | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
  > /etc/apt/sources.list.d/google-chrome.list

apt-get update
xargs -a /tmp/packages.list apt-get install -y
apt-get install -y google-chrome-stable

# --- Bộ gõ tiếng Việt: fcitx5-unikey ---
apt-get install -y fcitx5 fcitx5-unikey fcitx5-config-qt
im-config -n fcitx5

# --- Set Chrome làm trình duyệt mặc định, giữ Firefox song song ---
xdg-settings set default-web-browser google-chrome.desktop || true
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable || true

# --- Font Unicode tiếng Việt mặc định ---
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
sed -i "s/127.0.1.1.*/127.0.1.1\tbac-ha-os/" /etc/hosts
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Bạc Hà OS ${VERSION} (${EDITION^})\"/" /etc/os-release
sed -i "s/^NAME=.*/NAME=\"Bạc Hà OS\"/" /etc/os-release

# --- Dọn file thừa ---
rm -rf /usr/share/doc/* /usr/share/man/* /var/cache/fontconfig/*
find /usr/share/locale -mindepth 1 -maxdepth 1 \
  ! -name 'vi*' ! -name 'en*' -exec rm -rf {} +

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm -f /var/log/*.log
