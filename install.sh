#!/bin/bash
# =====================================================================
# ExOs Online Installer Launcher (Fully Automated Fix)
# =====================================================================

# 1. TERMINAL DİZİNİNİ GÜVENE ALMA
cd /tmp || exit 1

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 2. EKRAN YETKİLERİ VE QT PLATFORMU
xhost +local:root > /dev/null 2>&1
export DISPLAY=${DISPLAY:-:0}
export QT_QPA_PLATFORM=xcb

# 3. EKSİK PAKETLERİ TERMINAL GİRDİSİNE TAKILMADAN OTOMATİK YÜKLEME
echo "📦 Bağımlılıklar Denetleniyor ve Yükleniyor..."
if command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm --needed xcb-util-cursor libxkbcommon-x11 qt6-base calamares git python3 < /dev/tty
elif command -v dnf &> /dev/null; then
    sudo dnf install -y xcb-util-cursor libxkbcommon calamares git python3 < /dev/tty
elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y libxcb-cursor0 libxkbcommon-x11-0 calamares git python3 < /dev/tty
fi

# 4. GEÇİCİ ÇALIŞMA DİZİNİ VE GITHUB DEPOSU
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf "$EXOS_DIR"
mkdir -p "$EXOS_DIR"
cd "$EXOS_DIR" || exit 1

echo "📥 ExOs Dosyaları GitHub'dan İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 5. TEMA VE MODÜLLERİ SİSTEM DİZİNLERİNE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/exos
sudo mkdir -p /usr/lib64/calamares/modules/exos_hardware
sudo mkdir -p /usr/lib/calamares/modules/exos_hardware

sudo cp -rf $EXOS_DIR/branding/exos/* /usr/share/calamares/branding/exos/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib64/calamares/modules/exos_hardware/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib/calamares/modules/exos_hardware/ 2>/dev/null

# 6. CALAMARES'İ BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E calamares -c $EXOS_DIR/calamares/settings.conf -d
