#!/bin/bash
# By default, the main CTAN mirror is used to fetch packages from. If this
# is distant from you, or you have a faster local mirror simply override
# this by setting the CTAN_MIRROR_URL environmental variable outside this
# script.
# A list of mirrors can be found at http://ctan.org/mirrors

PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH
DEFAULT_CTAN_MIRROR_URL='http://mirror.ctan.org'

wget \
  --continue \
  --directory-prefix /tmp \
  ${CTAN_MIRROR_URL:=DEFAULT_CTAN_MIRROR_URL}/systems/texlive/tlnet/install-tl-unx.tar.gz
tar \
  --extract \
  --gunzip \
  --directory /tmp \
  --file install-tl-unx.tar.gz

# Install texlive using the supplied texlive.profile (this just installs a
# basic LaTeX environment
sudo . /tmp/install-tl-*/install-tl \
  -repository ${CTAN_MIRROR_URL:=DEFAULT_CTAN_MIRROR_URL}/systems/texlive/tlnet \
  -no-gui \
  -profile texlive.profile

# Install packages required by this style
packages=(
  mdframed
  preprint
  enumitem
  etoolbox
  titlesec
  xmpincl
  comment
  latexmk
  lm
  memoir
  listings
  xcolor
  url
  l3packages
  l3kernel
  placeins
  microtype
  float
  latex-bin
  fancyhdr
  graphics
  psnfss
  pdftex-def
  oberdiek
  colortbl
  hyperref
)
sudo tlmgr \
  -repository ${CTAN_MIRROR_URL:=DEFAULT_CTAN_MIRROR_URL}/systems/texlive/tlnet \
  install \
    ${packages[@]}