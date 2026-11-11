#!/bin/bash
# =====================================================================
# ExOs Online Installer Launcher (install.sh)
# =====================================================================

echo "⚡ ExOs Kurulum Ortamı Hazırlanıyor..."

# 1. GEÇİCİ ÇALIŞMA DİZİNİ OLUŞTURMA
EXOS_DIR="/tmp/exos-installer"
rm -rf $EXOS_DIR
mkdir -p $EXOS_DIR
cd $EXOS_DIR

# 2. GEREKLİ PAKETLERİ YÜKLEME (Fedora / RHEL / Arch Uyumlu)
if command -v dnf &> /dev/null; then
    sudo dnf install -y calamares git python3 2>/dev/null
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm calamares git python3 2>/dev/null
fi

# 3. GITHUB DEPOSUNDAN EXOS DOSYALARINI ÇEKME
echo "📥 ExOs Calamares Modülleri GitHub'dan İndiriliyor..."
git clone https://github.com/kutsalbaha2-art/SpeedyOS-.git .

# 4. CALAMARES'İ EXOS YAPILANDIRMASIYLA BAŞLATMA
echo "🚀 ExOs Kurulum Sihirbazı Başlatılıyor..."
sudo calamares -c $EXOS_DIR/calamares/settings.conf -d
