#/bin/sh

# work for Yosemite and EI Capitan

set -e

source /etc/profile

username=`whoami`

sudo echo "Step 1: Create ~/Sites"
if [ -d ~/Sites ]; then
    read -p "The directory 'Site' exists, override it? (y/n) " yon
    if [ $yon = "n" -o $yon = "N" ]; then
        echo "exit"
        exit 0
    fi
fi
sudo rm -fr ~/Sites
mkdir ~/Sites
echo "Hooray! My site works!" > ~/Sites/index.html.en
cat >> ~/Sites/index.php << EOF
<?php echo phpinfo(); ?>
EOF

echo "Step 2: Modify httpd.conf"
sudo sed -Ei "" 's/^#(.*php5_module.*)/\1/g' /etc/apache2/httpd.conf
sudo sed -Ei "" 's/^#(.*userdir_module.*)/\1/g' /etc/apache2/httpd.conf
sudo sed -Ei "" 's/^#(.*httpd-userdir.*)/\1/g' /etc/apache2/httpd.conf

echo "Step 3: Modify httpd-userdir.conf"
sudo sed -Ei "" 's/^#(Include.*apache2.*users.*)/\1/g' /private/etc/apache2/extra/httpd-userdir.conf

echo "Step 4: Create /etc/apache2/users/$username.conf"
if [ -f /etc/apache2/users/$username.conf ]; then
    read -p "'/etc/apache2/users/$username.conf' exists, override it? (y/n) " yon
    if [ $yon = "n" -o $yon = "N" ]; then
        echo "exit"
        exit 0
    fi
fi
sudo rm -fr /etc/apache2/users/$username.conf
sudo sh -c 'cat >> /etc/apache2/users/'$username'.conf << EOF
<Directory "/Users/'$username'/Sites/">
    AddLanguage en .en
    LanguagePriority en fr de
    ForceLanguagePriority Fallback
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    Allow from localhost
    Require all granted
</Directory>
EOF'

echo "Step 5: restart apache"
sudo apachectl restart

echo "Successful!"
echo "Test these three URLs in your browser:"
echo "http://localhost"
echo "http://localhost/~$username"
echo "http://localhost/~$username/index.php"
