
po/skype.pot : lang/English.lang po/header.pot
	(cat po/header.pot | sed "s/XXXX-XX-XX XX:XX-XXXX/`date '+%Y-%m-%d %H:%M:%S%z' | sed 's/00$$$$/:00/'`/"; cat lang/English.lang | iconv -f utf16 -t utf8 | tr -d "\015" | egrep -v '=$$' | sed 's/["\\]/\\&/g' | sed 's/^\([^=]*\)=\(.*\)$$/msgctxt "\1"\nmsgid "\2"\nmsgstr ""\n/') > $@

updatepos: po/skype.pot FORCE
	ls po/*.po | while read x; do echo "Updating $$x..."; msgmerge -q --backup=off -U $$x po/skype.pot > /dev/null 2>&1; done

po2lang: FORCE
	ls po/*.po | sed 's/^po.//' | sed 's/\.po$$//' | while read x; do echo "Generating .lang file from po/$$x.po..."; bash scripts/poclean.sh po/$$x.po po/skype.pot | tr -d "\n" | sed 's/msgctxt "/\n&/g' | sed '1d' | sed 's/^msgctxt "//' | sed 's/"msgid ".*msgstr "/=/' | sed 's/\([^\\]\)""/\1/g' | sed 's/"$$//' | sed 's/\\\(["\\]\)/\1/g' | iconv -f utf8 -t utf16 > lang/`egrep "^$$x " LINGUAS | sed 's/^[^ ]* //'`; done

clean :
	rm -f po/skype.pot

FORCE:
