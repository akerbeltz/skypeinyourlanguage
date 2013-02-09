
po/skype.pot : lang/English.lang po/header.pot
	(cat po/header.pot; cat lang/English.lang | iconv -f utf16 -t utf8 | tr -d "\015" | sed 's/["\\]/\\&/g' | sed 's/^\([^=]*\)=\(.*\)$$/msgctxt "\1"\nmsgid "\2"\nmsgstr ""\n/') > $@

updatepos: FORCE
	ls po/*.po | while read x; do echo "Updating $$x..."; msgmerge -q --backup=off -U $$x po/skype.pot > /dev/null 2>&1; done

po2lang: FORCE
	ls po/*.po | sed 's/^po.//' | sed 's/\.po$$//' | while read x; do echo "Generating .lang file from po/$$x.po..."; msgen po/$$x.po | tr -d "\n" | sed 's/msgctxt "/\n&/g' | sed '1d' | sed 's/^msgctxt "//' | sed 's/"msgid ".*msgstr "/=/' | sed 's/\([^\\]\)""/\1/g' | sed 's/"$$//' | sed 's/\\\(["\\]\)/\1/g' | iconv -f utf8 -t utf16 > lang/`egrep "^$$x " LINGUAS | sed 's/^[^ ]* //'`; done

clean :
	rm -f po/skype.pot

FORCE:
