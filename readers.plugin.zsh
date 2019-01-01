#!/usr/bin/env zsh
DEPENDENCES_ARCH+=( curl pygmentize@pygmentize )
DEPENDENCES_DEBIAN+=( curl pygmentize@python-pygments )

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
  $(whence pygmentize) -g $FILE
}


function htmlcat() {
  FILE=$(_create_file $@)
  $(whence pygmentize) -l html $FILE
}
alias xmlcat=htmlcat

function csscat() {
  FILE=$(_create_file $@)
  $(whence pygmentize) -l css $FILE
}

function jscat() {
  FILE=$(_create_file $@)
  $(whence pygmentize) -l javascript $FILE
}

function jsoncat() {
  FILE=$(_create_file $@)
  $(whence pygmentize) -l json $FILE
}

function cppcat() {
  FILE=$(_create_file $@)
  $(whence pygmentize) -l c_cpp $FILE
}
alias javacat=cppcat



DEPENDENCES_NPM+=( msee )
function mdcat() {
  FILE=$(_create_file $@)
  msee "$FILE"
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
