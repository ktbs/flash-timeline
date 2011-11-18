SDKHOME:=$(if $(wildcard ../../../flex_sdk_4.5.1),../../../flex_sdk_4.5.1,$(error You must configure SDK path in Makefile))
SDKBIN:=${SDKHOME}/bin/
SWF=bin/Timeline.swf
DEPFILES:=src/TestTimeline.mxml

all: $(SWF)

$(SWF): $(DEPFILES)
	"${SDKBIN}mxmlc" -output $@ -strict=true -compiler.incremental -use-network="true" -compiler.include-libraries lib -compiler.locale="en_US" -show-unused-type-selector-warnings=false $<

clean:
	-$(RM) $(SWF) $(SWF).cache
