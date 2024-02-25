#!/usr/bin/env bash
clear

INSTALL_DIR=/usr/local/turbolab.it/symfony-bundle-builder/
RAW_REPO_URL=https://raw.githubusercontent.com/TurboLabIt/symfony-bundle-builder/main/

if [ -f "${INSTALL_DIR}scripts/symfony-bundle-builder.sh" ]; then
  source "${INSTALL_DIR}scripts/symfony-bundle-builder.sh"
else
  source <(curl -s "${RAW_REPO_URL}script/symfony-bundle-builder.sh")
fi
