# Si on utilise un translator, utiliser ce script, sinon, recopier � partir du template les nouvelles entr�es dans les fichiers po
#!/bin/sh

pot=`find . | grep -i \.pot$`

#msginit --no-translator --locale fr_FR --output-file fr_FR.po --input $pot
#msginit --no-translator --locale fr_FR --output-file en_US.po --input $pot

#echo "Missing locale: usage ./make_po.sh <locale>"
