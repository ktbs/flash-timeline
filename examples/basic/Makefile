SDKHOME:=$(if $(wildcard ../../../flex_sdk_4.5.1),../../../flex_sdk_4.5.1,$(error You must configure SDK path in Makefile))
SDKBIN:=${SDKHOME}/bin/
SWF=bin/Timeline.swf
DEPFILES:=src/TestTimeline.mxml

all: $(SWF)

$(SWF): src/default.css lib/Timeline.swc lib/TALES.swc lib/Traces.swc $(DEPFILES)
	"${SDKBIN}mxmlc" -output $@ -strict=true -compiler.incremental -debug=true -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $(DEPFILES)

clean:
	-$(RM) $(SWF) $(SWF).cache
