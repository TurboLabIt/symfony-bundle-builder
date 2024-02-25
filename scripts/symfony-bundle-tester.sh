## Symfony Bundle Builder https://github.com/TurboLabIt/symfony-bundle-builder
# 🛑 Don't run this script directly! 📚 RTFM: https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/README.md

SCRIPT_TITLE="🧪 Symfony Bundle Tester"

if [ -f "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh" ]; then
  source "${SBB_INSTALL_DIR}scripts/symfony-bundle-script-begin.sh"
else
  source <(curl -s "${SBB_RAW_REPO_URL}scripts/symfony-bundle-script-begin.sh")
fi


if [ -s "${PROJECT_DIR}composer.json" ]; then

  fxOK "composer.json exists"

else

  fxWarning "composer.json is missing or empty!"
  REQ_CHECK_FAILURE=1
fi


if [ ! -z ${REQ_CHECK_FAILURE} ]; then
  fxCatastrophicError "Some required tools are missing!"
fi


fxTitle "Running composer..."
symfony local:php:refresh
symfony composer update
rm -rf composer.lock


fxTitle "Looking for phpunit.xml.dist..."
if [ ! -f "${PROJECT_DIR}phpunit.xml.dist" ]; then

  fxInfo "##${PROJECT_DIR}phpunit.xml.dist## not found. Downloading..."
  curl -O https://raw.githubusercontent.com/TurboLabIt/webstackup/master/script/php-pages/phpunit.xml.dist

else

  fxOK "phpunit.xml.dist found, nothing to do"
fi


fxTitle "Looking for PHPUnit..."
if [ ! -d "${PROJECT_DIR}vendor/phpunit" ]; then

  fxInfo "PHPUnit not found. Composer req it now..."
  symfony composer require  phpunit/phpunit --dev

else

  fxOK "PHPUnit is already installed"
fi


rm -rf composer.lock


fxTitle "🔬 Checking input..."
if [ ! -z "$@" ]; then
  ADDITIONAL_PARAMS="$@"
else
  fxInfo "No arguments"
fi


fxTitle "👢 Bootstrap"
BOOTSTRAP_FILE=${PROJECT_DIR}tests/bootstrap.php
fxInfo "phpunit bootstrap file set to ##${BOOTSTRAP_FILE}##"

if [ ! -f "${BOOTSTRAP_FILE}" ]; then

  fxInfo "Bootstrap file non found. Downloading..."
  curl -Lo "${BOOTSTRAP_FILE}" https://raw.githubusercontent.com/TurboLabIt/webstackup/master/script/php-pages/phpunit-bootstrap.php
fi


fxTitle "🚕 Migrating/upgrading phpunit config..."
XDEBUG_MODE=off ./vendor/bin/phpunit --bootstrap "${BOOTSTRAP_FILE}" --migrate-configuration


fxTitle "🐛 Xdebug"
if [ ! -z "$XDEBUG_PORT" ]; then

  export XDEBUG_CONFIG="remote_host=127.0.0.1 client_port=$XDEBUG_PORT"
  export XDEBUG_MODE="develop,debug"
  fxOK "Xdebug enabled to port ##$XDEBUG_PORT##. Good hunting!"
  fxInfo "To disable: export XDEBUG_PORT="

else

  export XDEBUG_MODE="off"
  fxInfo "Xdebug disabled (to enable: export XDEBUG_PORT=9xxx)"
fi


fxTitle "🤖 Testing with PHPUnit..."
SYMFONY_DEPRECATIONS_HELPER=disabled ./vendor/bin/phpunit \
  --bootstrap "${BOOTSTRAP_FILE}" \
  --display-warnings \
  --stop-on-failure $ADDITIONAL_PARAMS \
  tests


PHPUNIT_RESULT=$?
echo ""

if [ "${PHPUNIT_RESULT}" = 0 ]; then

  fxMessage "🎉 TEST RAN SUCCESSFULLY!"
  fxCountdown 3
  echo ""

else

  fxMessage "🛑 TEST FAILED | phpunit returned ${PHPUNIT_RESULT}"
fi


fxEndFooter
