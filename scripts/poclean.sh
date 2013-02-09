#!/bin/bash
if [ $# -ne 2 ]
then
	echo "Usage: bash poclean.sh xx.po proj.pot > xx-cleaned.po"
	exit 1
fi
TEMPPO=`mktemp`
msgattrib --no-fuzzy "${1}" > ${TEMPPO}
msgmerge -N ${TEMPPO} "${2}" 2> /dev/null | msgen -
rm -f $TEMPPO
