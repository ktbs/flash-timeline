#!/bin/sh

find . | egrep -i '\.po$' > po

sed -i -e 's/\.po//g' po
locales=`cat po`
rm po

out=../locale
mkdir -p $out

for locale in $locales; do
    echo "Processing "$locale".po ..."
    mkdir -p $out/$locale/LC_MESSAGES
    "/cygdrive/c/Program Files/GnuWin32/bin/msgfmt" --check --verbose --output-file $out/$locale/LC_MESSAGES/timeline.mo $locale.po
done