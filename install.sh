#!/bin/bash
# =====================================================================
# ExOs Online Installer Launcher (Fix Qt6 xcb & Directory Bug)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. DİZİN BOŞA DÜŞME (getcwd) HATASINI ENGELLEME
cd /tmp

# 2. EKRAN YETKİLERİNİ ROOT KULLANICISINA TANIMLAMA
xhost +local:root > /dev/null 2>&1
export DISPLAY=${DISPLAY:-:0}

# 3. EKSİK QT6 XCB VE İMLEÇ KÜTÜPHANELERİNİ OTOMATİK YÜKLEME
echo "📦 Eksik Qt6 ve xcb Kütüphaneleri Yükleniyor..."
if command -v dnf &> /dev/null; then
    sudo dnf install -y calamares git python3 xcb-util-cursor 2>/dev/null
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm calamares git python3 xcb-util-cursor 2>/dev/null
elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y calamares git python3 libxcb-cursor0 2>/dev/null
fi

# 4. GEÇİCİ ÇALIŞMA DİZİNİNİ SIFIRLAMA
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

echo "📥 ExOs Dosyaları GitHub'dan İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 5. MARKA VE MODÜLLERİ RESMİ SİSTEM DİZİNLERİNE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/exos
sudo mkdir -p /usr/lib64/calamares/modules/exos_hardware
sudo mkdir -p /usr/lib/calamares/modules/exos_hardware

sudo cp -rf $EXOS_DIR/branding/exos/* /usr/share/calamares/branding/exos/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib64/calamares/modules/exos_hardware/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib/calamares/modules/exos_hardware/ 2>/dev/null

# 6. CALAMARES'İ BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E calamares -c $EXOS_DIR/calamares/settings.conf -d > /tmp/calamares_run.log 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Calamares Başlatılamadı! Hata Logu (/tmp/calamares_run.log):"
    echo "------------------------------------------------------------"
    tail -n 25 /tmp/calamares_run.log
fi
