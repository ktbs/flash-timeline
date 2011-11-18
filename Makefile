SDKHOME:=$(if $(wildcard ../flex_sdk_4.5.1),../flex_sdk_4.5.1/bin/,$(error You must configure SDK path in Makefile))
SWF=bin/Timeline.swf
DEPFILES:=$(shell find src -name "*.as" -or -name "*.mxml")
PLAY:=$(if $(wildcard /usr/bin/play),/usr/bin/play -V0 -q,/usr/bin/true)
SOUND_ERROR:=/usr/share/sounds/sound-icons/trumpet-1.wav 
SOUND_DONE:=/usr/share/sounds/sound-icons/trumpet-12.wav 
POT=po/timeline.pot

all: $(SWF)

$(SWF): src/TestTimeline.mxml $(ASSETSFILE) $(DEPFILES)
	"${SDKHOME}mxmlc" -output $@ -strict=true -compiler.incremental -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $< || ${PLAY} ${SOUND_ERROR}
	${PLAY} ${SOUND_DONE}

clean:
	-$(RM) $(SWF)

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
