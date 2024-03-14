## Symfony Bundle Builder https://github.com/TurboLabIt/symfony-bundle-builder
# 🛑 Don't run this script directly! 📚 RTFM: https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/README.md

SCRIPT_TITLE="📦 Symfony Bundle Builder"

if [ -f "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh" ]; then
  source "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh"
else
  source <(curl -s "${SBB_RAW_REPO_URL}scripts/symfony-bundle-script-begin.sh")
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


fxTitle "Looking for a .gitignore..."
if [ ! -f ".gitignore" ]; then

  fxInfo ".gitignore not found. Downloading..."
  curl -O https://raw.githubusercontent.com/TurboLabIt/webdev-gitignore/master/.gitignore

else

  fxOK ".gitignore found, nothing to do"
fi


fxTitle "Checking root-level files..."
for ROOT_LEVEL_FILE in composer.json .env .env.dev.local readme.md; do

  if [ ! -f "${ROOT_LEVEL_FILE}" ]; then

    fxInfo "##${ROOT_LEVEL_FILE}## file not found. Downloading..."
    getTemplateFile "${ROOT_LEVEL_FILE}"

  else

    fxOK "${ROOT_LEVEL_FILE} found, nothing to do"
  fi

  replaceVendorPackageNameInFile ${ROOT_LEVEL_FILE}

done


fxTitle "Running composer..."
symfony local:php:refresh
symfony composer update
rm -rf composer.lock


fxTitle "Building the bundle structure..."
## 📚 https://symfony.com/doc/current/bundles.html#bundle-directory-structure
for DIR_NAME in assets config public src/Service templates translations scripts tests; do

  if [ ! -d "${DIR_NAME}" ]; then

    fxInfo "##${DIR_NAME}## folder not found. Creating..."
    mkdir -p "${DIR_NAME}"

  else

    fxOK "##${DIR_NAME}## folder found, nothing to do"
  fi

done


fxTitle "Checking services.yaml..."
if [ ! -f "config/services.yaml" ]; then

  fxInfo "services.yaml not found. Downloading..."
  cd config
  getTemplateFile config/services.yaml
  cd ..

else

  fxOK "services.yaml found, nothing to do"
fi

replaceVendorPackageNameInFile "config/services.yaml"


fxTitle "Checking symfony-bundle-tester.sh..."
if [ ! -f "scripts/symfony-bundle-tester.sh" ]; then

  fxInfo "symfony-bundle-tester.sh not found. Downloading..."
  cd scripts
  getTemplateFile scripts/symfony-bundle-tester.sh
  cd ..

else

  fxOK "symfony-bundle-tester.sh found, nothing to do"
fi


fxTitle "Checking the main Bundle file..."
BUNDLE_FILENAME=${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}Bundle.php
if [ ! -f "src/${BUNDLE_FILENAME}" ]; then

  fxInfo "${BUNDLE_FILENAME} not found. Downloading..."
  cd src
  getTemplateFile src/MyVendorNameMyPackageNameBundle.php "${BUNDLE_FILENAME}"
  cd ..

else

  fxOK "${BUNDLE_FILENAME} found, nothing to do"
fi

replaceVendorPackageNameInFile "src/${BUNDLE_FILENAME}"


fxTitle "Checking test files..."
for TEST_FILE in BundleTest.php BaseT.php; do

  if [ ! -f "tests/${TEST_FILE}" ]; then

    fxInfo "##${TEST_FILE}## file not found. Downloading..."
    cd tests
    getTemplateFile tests/${TEST_FILE}
    cd ..

  else

    fxOK "${TEST_FILE} found, nothing to do"
  fi

  replaceVendorPackageNameInFile "tests/${TEST_FILE}"

done


fxEndFooter
