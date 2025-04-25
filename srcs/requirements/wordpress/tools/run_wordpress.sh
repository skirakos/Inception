#!/bin/bash

setup_directory() {
    mkdir -p $WP_PATH
    cd $WP_PATH || exit
    chmod -R 755 $WP_PATH
    chown -R www-data:www-data $WP_PATH
}

download_wordpress() {
    echo "Downloading WordPress..."
    rm -rf $WP_PATH/*
    wp core download --allow-root
}

configure_wordpress() {
    echo "Configuring WordPress..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/username_here/$DB_USER/g" wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$DB_HOST/g" wp-config.php
    sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
}

install_wordpress() {
    echo "Installing WordPress..."
    wp core install --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ROOT_USER_USERNAME" \
                    --admin_password="$WP_ROOT_USER_PASSWORD" \
                    --admin_email="$WP_ROOT_USER_EMAIL" \
                    --skip-email --allow-root

    wp user create "$WP_USER_USERNAME" "$WP_USER_EMAIL" --role="$WP_USER_ROLE" --user_pass="$WP_USER_PASSWORD" --allow-root
}

setup_permissions() {
    echo "Setting up permissions..."
    chmod -R 755 $WP_PATH
    chown -R www-data:www-data $WP_PATH
}

update_wordpress() {
    echo "Updating WordPress..."
    wp core update --allow-root && echo "WordPress updated successfully." || echo "WordPress update failed."
}

install_plugins() {
    echo "Installing and updating plugins..."
    wp plugin update --all --allow-root
    wp plugin install redis-cache --activate --allow-root
}

cleanup() {
    echo "Cleaning up installation..."
    rm -rf wp-config-sample.php
}

start_php() {
    echo "Starting PHP-FPM..."
    sleep 10
    exec /usr/sbin/php-fpm7.4 -F
}

setup_directory

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    download_wordpress
    configure_wordpress
    install_wordpress
    setup_permissions
    install_plugins
    cleanup
fi

update_wordpress
start_php
