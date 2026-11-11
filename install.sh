#!/bin/bash
# =====================================================================
# ExOs Calamares Safe Launcher & Debugger (install.sh)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. EKRAN YETKİLERİNİ ROOT KULLANICISINA AKTARMA
xhost +local:root > /dev/null 2>&1
export DISPLAY=${DISPLAY:-:0}

# 2. GEÇİCİ DİZİNİ SIFIRLAMA VE DEPOYU ÇEKME
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

echo "📥 ExOs Dosyaları GitHub'dan İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 3. SİSTEM DİZİNLERİNİ ÖNCE OLUŞTURUP SONRA DOSYALARI HEDEF KONTROLÜYLE KOPYALAMA
sudo mkdir -p /usr/share/calamares/branding/exos
sudo mkdir -p /usr/lib64/calamares/modules/exos_hardware
sudo mkdir -p /usr/lib/calamares/modules/exos_hardware

sudo cp -rf $EXOS_DIR/branding/exos/* /usr/share/calamares/branding/exos/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib64/calamares/modules/exos_hardware/ 2>/dev/null
sudo cp -rf $EXOS_DIR/src/modules/exos_hardware/* /usr/lib/calamares/modules/exos_hardware/ 2>/dev/null

# 4. CALAMARES'İ ÇALIŞTIRMA VE HATA OLUŞURSA LOGU EKRANA BASMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E QT_QPA_PLATFORM=xcb calamares -c $EXOS_DIR/calamares/settings.conf -d > /tmp/calamares_run.log 2>&1

# Eğer Calamares SIGABRT ile kapanırsa log dosyasının son 25 satırını göster
if [ $? -ne 0 ]; then
    echo "❌ Calamares Başlatılamadı! Hata Logu (/tmp/calamares_run.log):"
    echo "------------------------------------------------------------"
    tail -n 25 /tmp/calamares_run.log
fi
