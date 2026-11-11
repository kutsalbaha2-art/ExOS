#!/bin/bash
# =====================================================================
# ExOs Calamares Safe Launcher (install.sh)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. EKRAN YETKİLERİ VE QT PLATFORMU TANIMLARI
xhost +local:root > /dev/null 2>&1
export DISPLAY=${DISPLAY:-:0}
export XAUTHORITY=${XAUTHORITY:-$HOME/.Xauthority}

# 2. GEÇİCİ DİZİN VE GITHUB KONTROLÜ
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

echo "📥 ExOs Dosyaları İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 3. MARKA VE MODÜLLERİ SİSTEM DİZİNLERİNE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/exos
sudo mkdir -p /usr/lib64/calamares/modules/exos_hardware
sudo mkdir -p /usr/lib/calamares/modules/exos_hardware

sudo cp -rf $EXOS_DIR/branding/exos/* /usr/share/calamares/branding/exos/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib64/calamares/modules/exos_hardware/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib/calamares/modules/exos_hardware/ 2>/dev/null

# 4. CALAMARES'İ CANLI LOG İZLEME MODUNDA ÇALIŞTIRMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E Calamares_DEBUG=1 QT_QPA_PLATFORM=xcb calamares -c $EXOS_DIR/calamares/settings.conf -d
