#!/usr/bin/env bash
## Symfony Bundle Tester https://github.com/TurboLabIt/symfony-bundle-builder
# 📚 RTFM: https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/README.md

clear

if [ -z $(command -v curl) ]; then sudo apt update && sudo apt install curl -y; fi

SBB_INSTALL_DIR=/usr/local/turbolab.it/symfony-bundle-builder/
if [ -f "${SBB_INSTALL_DIR}scripts/symfony-bundle-tester.sh" ]; then
  source "${SBB_INSTALL_DIR}scripts/symfony-bundle-tester.sh"
else
  source <(curl -s "https://raw.githubusercontent.com/TurboLabIt/symfony-bundle-builder/main/scripts/symfony-bundle-tester.sh")
fi
