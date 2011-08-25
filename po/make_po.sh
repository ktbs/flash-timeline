# Si on utilise un translator, utiliser ce script, sinon, recopier à partir du template les nouvelles entrées dans les fichiers po
#!/bin/sh

pot=`find . | grep -i \.pot$`

#msginit --no-translator --locale fr_FR --output-file fr_FR.po --input $pot
#msginit --no-translator --locale fr_FR --output-file en_US.po --input $pot

#echo "Missing locale: usage ./make_po.sh <locale>"
