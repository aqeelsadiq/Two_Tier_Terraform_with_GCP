        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl enable apache2
        sudo apt install php php-mysqli -y
        sudo apt install mysql-client-core-8.0 -y
        sudo apt-get install wget unzip -y
        sudo wget https://wordpress.org/latest.zip
        sudo unzip latest.zip
        sudo cp -r wordpress/* /var/www/html/
        sudo chown -R www-data:www-data /var/www/html/
        sudo chmod 777 /var/www/html/wp-config.php
        sudo rm -rf /var/www/html/index.html
        sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
        PROJECT_ID=""
        INSTANCE_NAME=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/sql-instance-name" -H "Metadata-Flavor: Google")
        SQL_PRIVATE_IP=$(gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(ipAddresses[0].ipAddress)")
        sudo sed -i "s/database_name_here/database/g" /var/www/html/wp-config.php
        sudo sed -i "s/username_here/root/g" /var/www/html/wp-config.php
        sudo sed -i "s/password_here/password/g" /var/www/html/wp-config.php
        sudo sed -i "s/localhost/${SQL_PRIVATE_IP}/g" /var/www/html/wp-config.php
