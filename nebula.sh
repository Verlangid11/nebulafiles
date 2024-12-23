cd /var/www/pterodactyl
php artisan down
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

chmod -R 755 storage/* bootstrap/cache

composer install --no-dev --optimize-autoloader --no-interaction

php artisan view:clear
php artisan config:clear
php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan up
echo "Semua tema dan addon telah dihapus."
echo "PROSES PEMASANGAN NEBULA THEME"

# Pastikan Node.js kompatibel (gunakan Node.js 18)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
npm i -g yarn

cd /var/www/pterodactyl
yarn install --force
yarn add cross-env

apt install -y zip unzip git curl wget
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
unzip -o release.zip -d /var/www/pterodactyl

# Jalankan Blueprint
chmod +x blueprint.sh
bash blueprint.sh < <(yes "y")

# Pastikan direktori ada
sudo mkdir -p /var/www/pterodactyl/.blueprint/extensions/nebula/public

# Perbaiki kepemilikan direktori
sudo chown -R www-data:www-data /var/www/pterodactyl

# Ubah hak akses
sudo chmod -R 755 /var/www/pterodactyl/.blueprint/extensions/nebula/public

# Instalasi Nebula Theme langsung pake dev/null
cd /var/www/pterodactyl
blueprint -install nebula < /dev/null
