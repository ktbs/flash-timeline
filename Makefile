SDKHOME:=$(if $(wildcard /home/oaubert/src/flex_sdk_4.5.1),/home/oaubert/src/flex_sdk_4.5.1/bin/,$(error You must configure SDK path in Makefile))
SWF=bin/TestTimeline.swf
DEPFILES:=$(shell find src -name "*.as" -or -name "*.mxml")
PLAY:=$(if $(wildcard /usr/bin/play),/usr/bin/play -V0 -q,/usr/bin/true)
SOUND_ERROR:=/usr/share/sounds/sound-icons/trumpet-1.wav 
SOUND_DONE:=/usr/share/sounds/sound-icons/trumpet-12.wav 

all: $(SWF)

$(SWF): src/TestTimeline.mxml $(ASSETSFILE) $(DEPFILES)
	"${SDKHOME}mxmlc" -output $@ -strict=true -compiler.incremental -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $< || ${PLAY} ${SOUND_ERROR}
	${PLAY} ${SOUND_DONE}

clean:
	-$(RM) $(SWF)
