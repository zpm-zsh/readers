#!/usr/bin/env zsh
DEPENDENCES_ARCH+=( curl bat )
DEPENDENCES_DEBIAN+=( curl bat )

function _create_file(){
  if [[ -z $1 ]]; then
    FILE=$(mktemp -u -t XXXXX)
    cat > $FILE
  else
    if [[ $1 == ("http:"|"https:"|"ftp:")* ]]; then
      FILE=$(mktemp -u -t "XXXXX$(basename $1)")
      curl -L --silent "$1" > $FILE
    else
      FILE="$1"
    fi
  fi
  echo $FILE
}


function hcat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never  $FILE
}


function htmlcat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l html $FILE
}
alias xmlcat=htmlcat

function csscat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l css $FILE
}

function jscat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l javascript $FILE
}

function jsoncat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l json $FILE
}

function cppcat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l cpp $FILE
}
alias javacat=cppcat

function shcat() {
  FILE=$(_create_file $@)
  $(whence bat) --style='numbers' --pager=never -l shell $FILE
}


DEPENDENCES_NPM+=( cli-md )
function mdcat() {
  FILE=$(_create_file $@)
  cli-md "$FILE"
}

DEPENDENCES_ARCH+=( gpg@gnupg )
DEPENDENCES_DEBIAN+=( gpg@gnupg )
function gpgcat() {
  FILE=$(_create_file $@)
  gpg --quiet --batch -d $FILE
}

function pdfcat() {
  FILE=$(_create_file $@)
  pdftotext -eol unix -nopgbrk "$FILE" -
}

DEPENDENCES_ARCH+=( icat convert@imagemagick )
DEPENDENCES_DEBIAN+=( icat convert@imagemagick )
function imgcat() {
  if [[ -z $1 ]]; then
    echo "Usege: image <path-to-image>"
    return -1
  fi

  FILE=$(_create_file $@)

  case "$FILE" in
      *.("jpg"|"jpeg"|"png"|"JPG"|"JPEG"|"PNG"))
        icat -m 24bit "$FILE"
      ;;
      *)
        NEWFILE=$(mktemp -t XXXXX.png)
        convert "$FILE" "$NEWFILE"
        icat -m 24bit "$NEWFILE"
      ;;
  esac
}
