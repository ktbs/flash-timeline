find ../src | egrep -i '\.as$|\.mxml$' > files
xgettext --package-name timeline --package-version 0.1 --default-domain timeline --output timeline.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files