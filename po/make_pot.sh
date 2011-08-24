find ../src | egrep -i '\.as$|\.mxml$' > files
/cygdrive/c/gettext-0.14.4-bin/bin/xgettext --package-name Timeline --package-version 0.1 --default-domain Timeline --output Timeline.pot --from-code=UTF-8 -L C --keyword=_:1 -f files
rm files