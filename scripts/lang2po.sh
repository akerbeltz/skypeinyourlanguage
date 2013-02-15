#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Usage: bash lang2po.sh ../lang/xx.lang > ../po/xx.po"
	exit 1
fi
TEMPFILE=`mktemp`
TEMPFILE2=`mktemp`
cat "${1}" | iconv -f utf16 -t utf8 | tr -d "\015" | sed 's/["\\]/\\&/g' | sed 's/=/\t/' | LC_ALL=C sort -k1,1 > $TEMPFILE
(cat ../po/header.pot; cat ../lang/English.lang | iconv -f utf16 -t utf8 | tr -d "\015" | sed 's/["\\]/\\&/g' | sed 's/=/\t/' | LC_ALL=C sort -k1,1 | LC_ALL=C join -t $'\t' - $TEMPFILE | tr "\t" '~' | egrep -v '^[^~]+~([^~]+)~\1$' | sed 's/^\([^~]*\)~\([^~]*\)~\(.*\)$/msgctxt "\1"\nmsgid "\2"\nmsgstr "\3"\n/') > $TEMPFILE2
msgmerge $TEMPFILE2 ../po/skype.pot 2> /dev/null | sed '3d'
rm -f $TEMPFILE $TEMPFILE2
