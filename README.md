# symfony-bundle-builder

The quickest way to startup a new Symfony Bundle


## How to...?

From a new, empty folder:

````shell
sudo apt update && sudo apt install curl -y && curl -s https://raw.githubusercontent.com/TurboLabIt/symfony-bundle-builder/main/start.sh?$(date +%s) | bash

````


## Non-interactive (unattended) execution example

````shell
echo '8.3' > .php-version
export SBB_BUNDLE_VENDOR_NAME=TurboLabIt
export SBB_BUNDLE_PACKAGE_NAME=Encryptor
export SBB_DEVELOPER_NAME=Zane
export SBB_DEVELOPER_EMAIL=info@turbolab.it

sudo apt update && sudo apt install curl -y
curl -s https://raw.githubusercontent.com/TurboLabIt/symfony-bundle-builder/main/start.sh?$(date +%s) | bash

````
