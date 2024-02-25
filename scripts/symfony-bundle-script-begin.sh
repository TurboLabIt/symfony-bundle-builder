## Symfony Bundle Builder https://github.com/TurboLabIt/symfony-bundle-builder
# 🛑 Don't run this script directly! 📚 RTFM: https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/README.md

## https://github.com/TurboLabIt/bash-fx
if [ -f "/usr/local/turbolab.it/bash-fx/bash-fx.sh" ]; then
  source "/usr/local/turbolab.it/bash-fx/bash-fx.sh"
else
  source <(curl -s https://raw.githubusercontent.com/TurboLabIt/bash-fx/main/bash-fx.sh)
fi
## bash-fx is ready

fxHeader "${SCRIPT_TITLE}"


PROJECT_DIR=$(pwd)/
fxInfo "Working in ##${PROJECT_DIR}##"


if [ -f "scripts/symfony-bundle-builder.sh" ]; then
  fxCatastrophicError "You can only run this command from your own directory. RTFM: https://github.com/TurboLabIt/symfony-bundle-builder"
fi


fxTitle "Requirements check..."
function checkReqCommand()
{
  if [ -z $(command -v $1) ]; then

    echo "🛑 $1 is missing!"
    REQ_CHECK_FAILURE=1

  else

    echo "✅ $1 is installed"
  fi
}

checkReqCommand php
checkReqCommand composer
checkReqCommand symfony

if [ -s "${PROJECT_DIR}.php-version" ]; then

  echo "✅ .php-version exists. PHP version set to ##$(cat .php-version)##"

else

  echo "🛑 ##${PROJECT_DIR}.php-version## is missing or empty! It must contain the PHP version to use. This will build it for you:"
  fxMessage "echo '8.3' > .php-version"
  touch .php-version
  REQ_CHECK_FAILURE=1
fi


function getTemplateFile()
{
  if [ -f "${SBB_INSTALL_DIR}template/$1" ] && [ -z "$2" ]; then

    cp "${SBB_INSTALL_DIR}template/$1" .

  elif [ -f "${SBB_INSTALL_DIR}template/$1" ]; then

    cp "${SBB_INSTALL_DIR}template/$1" "$2"

  elif [ ! -f "${SBB_INSTALL_DIR}template/$1" ] && [ -z "$2" ]; then

    curl -O <(curl -s "${SBB_RAW_REPO_URL}template/$1")

  else

    curl -o "$2" <(curl -s "${SBB_RAW_REPO_URL}template/$1")
  fi
}


function replaceVendorPackageNameInFile()
{
  sed -i "s|myvendorname/mypackagename|${SBB_BUNDLE_VENDOR_NAME,,}/${SBB_BUNDLE_PACKAGE_NAME,,}|g" "$1"
  sed -i "s|MyVendorName\\\\\\\\MyPackageName|${SBB_BUNDLE_VENDOR_NAME}\\\\\\\\${SBB_BUNDLE_PACKAGE_NAME}|g" "$1"

  sed -i "s|MyVendorName\\\\\\MyPackageName|${SBB_BUNDLE_VENDOR_NAME}\\\\\\${SBB_BUNDLE_PACKAGE_NAME}|g" "$1"
  sed -i "s|MyVendorNameMyPackageName|${SBB_BUNDLE_VENDOR_NAME}${SBB_BUNDLE_PACKAGE_NAME}|g" "$1"

  sed -i "s|MyDeveloperName|${SBB_DEVELOPER_NAME}|g" "$1"
  sed -i "s|MyDeveloperEmailAddress|${SBB_DEVELOPER_EMAIL}|g" "$1"
}
