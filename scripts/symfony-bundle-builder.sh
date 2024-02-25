## Symfony Bundle Builder https://github.com/TurboLabIt/symfony-bundle-builder
# 🛑 Don't run this script directly! 📚 RTFM: https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/README.md

SCRIPT_TITLE="📦 Symfony Bundle Builder"

if [ -f "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh" ]; then
  source "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh"
else
  source <(curl -s "${SBB_RAW_REPO_URL}script/symfony-bundle-script-begin.sh")
fi


if [ ! -z "${REQ_CHECK_FAILURE}" ]; then
  fxCatastrophicError "Some required tools are missing!"
fi


fxTitle "🏢 Enter your VENDOR name"
fxInfo "For example: \"TurboLabIt\". A-Z and 0-9 only"
while [ -z "$SBB_BUNDLE_VENDOR_NAME" ]; do

  echo "🤖 Provide the name"
  read -p ">> " SBB_BUNDLE_VENDOR_NAME  < /dev/tty

done

fxOK "OK, the vendor name is ##$SBB_BUNDLE_VENDOR_NAME##"


fxTitle "📦 Enter your PACKAGE name"
fxInfo "For example: \"BaseCommand\". A-Z and 0-9 only, skip the word BUNDLE at the end"
while [ -z "$SBB_BUNDLE_PACKAGE_NAME" ]; do

  echo "🤖 Provide the name"
  read -p ">> " SBB_BUNDLE_PACKAGE_NAME  < /dev/tty

done

fxOK "Acknowledged, ##$SBB_BUNDLE_PACKAGE_NAME## is going to rock"


fxTitle "📦 Enter your DEVELOPER name"
fxInfo "For example: \"Zane di TurboLab.it\". Anything but quotes goes"
while [ -z "$SBB_DEVELOPER_NAME" ]; do

  echo "🤖 Provide the name"
  read -p ">> " SBB_DEVELOPER_NAME  < /dev/tty

done

fxOK "Nice to meet you, ##$SBB_DEVELOPER_NAME##"


fxTitle "📦 Enter your EMAIL address"
fxInfo "For example: \"info@turbolab.it\". Anything but quotes goes"
while [ -z "$SBB_DEVELOPER_EMAIL" ]; do

  echo "🤖 Provide your email"
  read -p ">> " SBB_DEVELOPER_EMAIL  < /dev/tty

done

fxOK "Got it, ##$SBB_DEVELOPER_EMAIL##"


fxTitle "Looking for composer.json..."
if [ ! -f "${PROJECT_DIR}composer.json" ]; then

  fxInfo "##${PROJECT_DIR}composer.json## not found. Downloading..."
  getTemplateFile "composer.json"

else

  fxOK "composer.json found, nothing to do"
fi

replaceVendorPackageNameInFile ${PROJECT_DIR}composer.json


symfony local:php:refresh
symfony composer update
rm -rf composer.lock


fxTitle "Looking for a .gitignore..."
if [ ! -f "${PROJECT_DIR}.gitignore" ]; then

  fxInfo "##${PROJECT_DIR}.gitignore## not found. Downloading..."
  curl -O https://raw.githubusercontent.com/TurboLabIt/webdev-gitignore/master/.gitignore

else

  fxOK ".gitignore found, nothing to do"
fi


fxTitle "Building the bundle structure..."
## 📚 https://symfony.com/doc/current/bundles.html#bundle-directory-structure
for DIR_NAME in assets config public templates translations scripts; do

  if [ ! -d "${PROJECT_DIR}${DIR_NAME}" ]; then

    fxInfo "##${PROJECT_DIR}${DIR_NAME}## folder not found. Creating..."
    mkdir "${PROJECT_DIR}${DIR_NAME}"

  else

    fxOK "${DIR_NAME} found, nothing to do"
  fi

done


fxTitle "Checking the main Bundle file..."
if [ ! -f "${PROJECT_DIR}*Bundle.php" ]; then

  fxInfo "No Bundle file found. Downloading..."
  getTemplateFile MyVendorNameMyPackageNameBundle.php "${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}Bundle.php"

else

  fxOK "src found, nothing to do"
fi

replaceVendorPackageNameInFile "${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}Bundle.php"


fxTitle "Checking config/..."
if [ ! -f "${PROJECT_DIR}config/services.yaml" ]; then

  fxInfo "##${PROJECT_DIR}config/services.yaml## not found. Downloading..."
  cd config
  getTemplateFile config/services.yaml
  cd ..

else

  fxOK "services.yaml found, nothing to do"
fi

replaceVendorPackageNameInFile "config/services.yaml"


fxTitle "Checking src/DependencyInjection/..."
if [ ! -d "${PROJECT_DIR}src/DependencyInjection" ]; then

  fxInfo "##${PROJECT_DIR}src/DependencyInjection## folder not found. Creating..."
  mkdir -p src/Service
  mkdir -p src/DependencyInjection
  cd src/DependencyInjection
  getTemplateFile src/DependencyInjection/MyVendorNameMyPackageNameExtension.php "${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}Extension.php"
  cd ../..

else

  fxOK "src/DependencyInjection found, nothing to do"
fi

replaceVendorPackageNameInFile "src/DependencyInjection/${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}Extension.php"


fxTitle "Checking tests/..."
if [ ! -d "${PROJECT_DIR}tests" ]; then

  fxInfo "##${PROJECT_DIR}tests## folder not found. Creating..."
  mkdir tests
  cd tests
  getTemplateFile tests/BundleTest.php
  cd ..

else

  fxOK "tests found, nothing to do"
fi

replaceVendorPackageNameInFile "tests/BundleTest.php"


fxTitle "Checking scripts/symfony-bundle-tester.sh..."
if [ ! -f "${PROJECT_DIR}scripts/symfony-bundle-tester.sh" ]; then

  fxInfo "##${PROJECT_DIR}scripts/symfony-bundle-tester.sh## not found. Downloading..."
  cd scripts
  getTemplateFile scripts/symfony-bundle-tester.sh
  cd ..

else

  fxOK "symfony-bundle-tester.sh found, nothing to do"
fi


## dependencies
fxTitle "Looking for Symfony Framework..."
if [ ! -d "${PROJECT_DIR}vendor/symfony/framework-bundle" ]; then

  fxInfo "Symfony Framework not found. Composer req it now..."
  symfony composer require symfony/framework-bundle --dev

else

  fxOK "Symfony Framework is already installed"
fi

rm -rf composer.lock


fxEndFooter
