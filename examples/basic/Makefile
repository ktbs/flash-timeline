SDKHOME:=$(if $(wildcard ../../../flex_sdk_4.5.1),../../../flex_sdk_4.5.1,$(error You must configure SDK path in Makefile))
SDKBIN:=${SDKHOME}/bin/
SWF=bin/Timeline.swf
DEPFILES:=src/TestTimeline.mxml
DEBUG=true

all: $(SWF)

$(SWF): src/default.css lib/Timeline.swc lib/TALES.swc lib/Traces.swc $(DEPFILES)
	"${SDKBIN}mxmlc" -output $@ -strict=true -compiler.incremental -debug=$(DEBUG) -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $(DEPFILES)

upload:
	rsync -L --exclude=traces/ -av bin/ advene:public_html/ithaca/timeline/

clean:
	-$(RM) $(SWF) $(SWF).cache
