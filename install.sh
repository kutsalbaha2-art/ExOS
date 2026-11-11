#!/bin/bash
# =====================================================================
# ExOs Online Installer Fix Launcher (install.sh)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. GRAFİK EKRAN (X11/Qt) YETKİSİNİ ROOT KULLANICISINA TANIMLAMA
xhost +local:root > /dev/null 2>&1

# 2. ÇALIŞMA DİZİNİNİ SIFIRLAMA VE GITHUB DEPOSUNU ÇEKME
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

echo "📥 ExOs Dosyaları GitHub'dan Çekiliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 3. TEMA VE MODÜLLERİ CALAMARES RESMİ SİSTEM DİZİNLERİNE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/
sudo mkdir -p /usr/lib64/calamares/modules/
sudo mkdir -p /usr/lib/calamares/modules/

# ExOs Tema ve Donanım Modülünü Sistem Yollarına Entegre Etme
sudo cp -rf $EXOS_DIR/branding/exos /usr/share/calamares/branding/
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware /usr/lib64/calamares/modules/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware /usr/lib/calamares/modules/ 2>/dev/null

# 4. CALAMARES'İ QT GRAPHICS VE EKRAN YETKİLERİYLE BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Çalıştırılıyor..."
sudo -E QT_QPA_PLATFORM=xcb calamares -c $EXOS_DIR/calamares/settings.conf -d
