#!/bin/bash

RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

show_progress() {
    local percent=$1
    local message=$2

    if [ "$percent" -le 40 ]; then
        COLOR=$RED
    elif [ "$percent" -le 70 ]; then
        COLOR=$ORANGE
    else
        COLOR=$GREEN
    fi

    clear
    echo -e "${CYAN}============================================================${RESET}"
    echo -e "${BOLD}${COLOR}PROSES: ${percent}% - ${message}${RESET}"
    echo -e "${GREEN}      © VERLANGID X NEBULA THEME${RESET}"
    echo -e "${CYAN}============================================================${RESET}"
    sleep 2
}

clear
echo -e "${CYAN}============================================================${RESET}"
echo -e "${BOLD}${CYAN}          🚀 SELAMAT DATANG DI VERLANGID INSTALLER 🚀${RESET}"
echo -e "${CYAN}============================================================${RESET}"
echo -e "${GREEN}            © NEBULA INSTALLER BY VERLANGID   ${RESET}"
echo -e "${CYAN}============================================================${RESET}"
sleep 3

show_progress 10 "Masuk ke direktori Pterodactyl..."
cd /var/www/pterodactyl
php artisan down > /dev/null 2>&1

show_progress 20 "Mengunduh dan mengekstrak file panel terbaru..."
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv > /dev/null 2>&1

show_progress 30 "Mengatur izin folder penting..."
chmod -R 755 storage/* bootstrap/cache > ©

show_progress 40 "Menginstal dependensi composer..."
composer install --no-dev --optimize-autoloader --no-interaction > /dev/null 2>&1

show_progress 50 "Membersihkan cache..."
php artisan view:clear > /dev/null 2>&1
php artisan config:clear > /dev/null 2>&1

show_progress 60 "Menjalankan migrasi database..."
php artisan migrate --seed --force > /dev/null 2>&1

show_progress 70 "Mengatur hak milik folder..."
chown -R www-data:www-data /var/www/pterodactyl/* > /dev/null 2>&1
php artisan up > /dev/null 2>&1

show_progress 80 "Memasang dependensi Nebula..."
apt-get install -y nodejs > /dev/null 2>&1
npm i -g yarn > /dev/null 2>&1

show_progress 90 "Menyesuaikan konfigurasi Nebula..."
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip > /dev/null 2>&1
cd /var/www/pterodactyl
unzip -o release.zip > /dev/null 2>&1
chmod +x blueprint.sh
bash /var/www/pterodactyl/blueprint.sh < <(yes "y") > /dev/null 2>&1

show_progress 100 "Instalasi Nebula Theme Selesai!"
clear
echo -e "${CYAN}============================================================${RESET}"
echo -e "${GREEN}                   🎉 INSTALL SELESAI 🎉                   ${RESET}"
echo -e "${GREEN}                      © VERLANGID                       ${RESET}"
echo -e "${CYAN}============================================================${RESET}"
