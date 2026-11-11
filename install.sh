#!/bin/bash
# =====================================================================
# ExOs Online Installer Launcher (Fix Abort Crash)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. GRAFİK EKRAN (X11) YETKİLERİNİ ROOT KULLANICISINA AÇMA
xhost +local:root > /dev/null 2>&1

# 2. GEÇİCİ ÇALIŞMA DİZİNİ OLUŞTURMA
EXOS_DIR="/tmp/exos-installer"
sudo rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

# 3. GEREKLİ PAKET KONTROLÜ VE YÜKLEME
if command -v dnf &> /dev/null; then
    sudo dnf install -y calamares git python3 2>/dev/null
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm calamares git python3 2>/dev/null
fi

# 4. GITHUB DEPOSUNU ÇEKME
echo "📥 ExOs Calamares Modülleri İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/ExOs.git .

# 5. CALAMARES'İ EKRAN YETKİLERİNİ KORUYARAK (-E) BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo -E calamares -c $EXOS_DIR/calamares/settings.conf -d
