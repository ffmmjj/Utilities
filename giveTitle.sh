#!/bin/bash

if [ "$#"  -ne 2 ] 
then
  echo "giveTitle nome_do_pdf.pdf titulo_do_pdf"
else
  keystr='InfoKey: Title'
  valuestr="InfoValue: $2"
  newdoc="$1"
  newdoc="${newdoc%'.pdf'}2.pdf"
  pdftk "$1" dump_data output ".tmp"
  awk 'BEGIN {FS = ":"; ignoreLine = 0 } ; {if (ignoreLine == 1){ ignoreLine = 0 ; next }}  {if ($1 == "InfoKey" && $2 == " Title") { ignoreLine = 1 } else { printf "%s:%s\n", $1, $2 } }' ".tmp" > ".tmp1"
  ( echo "$keystr"; echo "$valuestr"; cat ".tmp1"; ) > ".meta"
  rm ".tmp"
  rm ".tmp1"
  pdftk "$1" update_info ".meta" output "$newdoc"
  rm ".meta"
fi
