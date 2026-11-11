#!/bin/bash
# =====================================================================
# ExOs Online Installer Launcher (Guaranteed Qt6 & Path Fix)
# =====================================================================

# 1. TERMINAL DİZİNİNİ GÜVENE ALMA
cd /tmp || exit 1

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 2. EKRAN VE X11 YETKİLERİ
xhost +local:root > /dev/null 2>&1
export DISPLAY=${DISPLAY:-:0}

# 3. EKSİK QT6 XCB VE İMLEÇ KÜTÜPHANELERİNİ YÜKLEME (HATA GİZLENMEDEN)
echo "📦 Eksik Qt6 ve xcb Kütüphaneleri Denetleniyor..."
if command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm calamares git python3 xcb-util-cursor
elif command -v dnf &> /dev/null; then
    sudo dnf install -y calamares git python3 xcb-util-cursor
elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y calamares git python3 libxcb-cursor0
fi

# 4. GEÇİCİ ÇALIŞMA DİZİNİNİ TEMİZLEME VE DEPOYU ÇEKME
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf "$EXOS_DIR"
mkdir -p "$EXOS_DIR"
cd "$EXOS_DIR" || exit 1

echo "📥 ExOs Dosyaları GitHub'dan İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 5. MARKA VE MODÜLLERİ SİSTEM DİZİNLERİNE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/exos
sudo mkdir -p /usr/lib64/calamares/modules/exos_hardware
sudo mkdir -p /usr/lib/calamares/modules/exos_hardware

sudo cp -rf $EXOS_DIR/branding/exos/* /usr/share/calamares/branding/exos/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib64/calamares/modules/exos_hardware/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib/calamares/modules/exos_hardware/ 2>/dev/null

# 6. CALAMARES'İ BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E calamares -c $EXOS_DIR/calamares/settings.conf -d
