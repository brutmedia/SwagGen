#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_DIR="$( cd -P "$( dirname "$0" )" && pwd )"

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

readonly BIN_PATH=$SCRIPT_DIR/.build/release/swaggen
readonly RELEASE_FOLDER=$SCRIPT_DIR/release
readonly RELEASE_ZIP_PATH=$SCRIPT_DIR/release.zip
readonly TEMPLATES_PATH=$SCRIPT_DIR/Templates

check_binary_presence() {
  if [ ! -e "$BIN_PATH" ]; then
    fatal "No binary find at path '$BIN_PATH', build the tool in release first using 'make'"
  fi
}

delete_path_if_exists() {
  local path=$1
  if [ -e "$path" ]; then
    info "Deleting existing '$path'"
    rm -rf "$path"
  fi
}

cleanup_previous_artifacts() {
  delete_path_if_exists "$RELEASE_FOLDER"
  delete_path_if_exists "$RELEASE_ZIP_PATH"
}

package_release() {
  info "Creating temporary packaging folder"
  mkdir "$RELEASE_FOLDER"

  info "Copying binary"
  cp "$BIN_PATH" "$RELEASE_FOLDER"
  info "Copying templates"
  cp -R "$TEMPLATES_PATH" "$RELEASE_FOLDER"

  info "Creating zip"
  cd "$RELEASE_FOLDER" || exit
  zip -r "$RELEASE_ZIP_PATH" -- *
  cd - > /dev/null || exit

  info "Cleaning up temporary packaging folder"
  rm -rf "$RELEASE_FOLDER"
}

main() {
  check_binary_presence

  cleanup_previous_artifacts

  package_release

  info "Release packaged: $RELEASE_ZIP_PATH"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main
fi
