SDKHOME:=$(if $(wildcard ../flex_sdk_4.5.1),../flex_sdk_4.5.1,$(error You must configure SDK path in Makefile))
SDKBIN:=${SDKHOME}/bin/
SDKFRAMEWORK:=${SDKHOME}/frameworks/libs
SWC=bin/Timeline.swc
DEPFILES:=$(shell find src -name "*.as" -or -name "*.mxml")
CLASSES:=$(shell find src/com -name "*.as" -or -name "*.mxml" | sed 's/src\///; s/\.as//; s/\.mxml//; s/\//./g')
POT=po/timeline.pot

all: $(SWC)

swc: $(SWC)

$(SWC): $(DEPFILES) src/default.css
	"${SDKBIN}compc" -swf-version 11 -as3 -external-library-path+=$(SDKFRAMEWORK)/framework.swc -external-library-path+=$(SDKFRAMEWORK)/spark.swc -external-library-path+=$(SDKFRAMEWORK)/mx/mx.swc -output $@ -source-path src -strict=true -incremental -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $(shell find src/images -type f | sed 's/\(src.\)\(.*\)/ -include-file \2 \1\2/') -include-file default.css src/default.css $(CLASSES)

clean:
	-$(RM) $(SWC) $(SWC).cache

doc: $(DEPFILES)
	mkdir -p doc && "${SDKBIN}asdoc" -external-library-path+=$(SDKFRAMEWORK)/mx/mx.swc -library-path lib $(SDKFRAMEWORK) -exclude-dependencies=true -source-path src -main-title "Generic Timeline API Documentation" -output doc -doc-classes $(CLASSES)

pot: $(POT)

$(POT): $(DEPFILES)
	xgettext --package-name timeline --package-version 0.1 --default-domain timeline --output $@ --from-code=UTF-8 -L C --keyword=_:1 $(DEPFILES)

update-po:
	cd po ; \
	for po in *.po; do \
		lingua=`basename $$po .po`; \
		mv $$lingua.po $$lingua.old.po; \
		if msgmerge -o $$lingua.po $$lingua.old.po `basename $(POT)`; then\
		    rm $$lingua.old.po; \
		else \
		    rm -f $$lingua.po; \
		    mv $$lingua.old.po $$lingua.po; \
		fi \
	done

.PHONY: locale
locale:
	for po in po/*.po; do \
		lingua=`basename $$po .po`; \
		msgfmt -o locale/$$lingua/LC_MESSAGES/timeline.mo $$po ;\
	done
