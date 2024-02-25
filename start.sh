#!/usr/bin/env bash
clear

SBB_INSTALL_DIR=/usr/local/turbolab.it/symfony-bundle-builder/
SBB_RAW_REPO_URL=https://raw.githubusercontent.com/TurboLabIt/symfony-bundle-builder/main/

if [ -f "${SBB_INSTALL_DIR}scripts/symfony-bundle-builder.sh" ]; then
  source "${SBB_INSTALL_DIR}scripts/symfony-bundle-builder.sh"
else
  source <(curl -s "${SBB_RAW_REPO_URL}script/symfony-bundle-builder.sh")
fi
