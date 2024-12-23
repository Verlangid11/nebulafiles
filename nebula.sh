#!/bin/bash

echo "MEMULAI INSTALISASI THEMA NEBULA - VERLANG ID'
echo "PROSES OTOMATIS DIBUAT KHUSUS OLEH VERLANG - ID"
echo "================================================"

${REPO_URL}="https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz"
${NODE_REPO}="https://deb.nodesource.com/node_20.x"
${BLUEPRINT_URL}="https://api.github.com/repos/BlueprintFramework/framework/releases/latest"
${THEME_NAME}="nebula"

cd /var/www/pterodactyl || exit
php artisan down

curl -L ${REPO_URL} | tar -xzv

chmod -R 755 storage/* bootstrap/cache

composer install --no-dev --optimize-autoloader --no-interaction

php artisan view:clear
php artisan config:clear

# Jalankan migrasi database
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl/*

php artisan up
echo "Semua tema dan addon telah dihapus."
echo "================================================"
echo "PROSES PEMASANGAN ${THEME_NAME^^} THEME DIMULAI..."

sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/nodesource.gpg
curl -fsSL ${NODE_REPO}/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] ${NODE_REPO} nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install -y nodejs
npm i -g yarn
cd /var/www/pterodactyl || exit
yarn
yarn add cross-env

apt install -y zip unzip git curl wget

wget "$(curl -s ${BLUEPRINT_URL} | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
mv release.zip /var/www/pterodactyl/release.zip
cd /var/www/pterodactyl || exit
yes A | unzip release.zip

${WEBUSER}="www-data"
${USERSHELL}="/bin/bash"
${PERMISSIONS}="www-data:www-data"
sed -i -E -e "s|WEBUSER=\"www-data\"|WEBUSER=\"${WEBUSER}\"|g" -e "s|USERSHELL=\"/bin/bash\"|USERSHELL=\"${USERSHELL}\"|g" -e "s|OWNERSHIP=\"www-data:www-data\"|OWNERSHIP=\"${PERMISSIONS}\"|g" blueprint.sh
chmod +x blueprint.sh
bash /var/www/pterodactyl/blueprint.sh < <(yes "y")

cd /var/www/pterodactyl || exit
blueprint -install ${THEME_NAME} < /dev/null

echo "================================================"
echo "PEMASANGAN THEME ${THEME_NAME^^} BERHASIL!"
echo "DIBUAT OLEH VERLANG - ID"
