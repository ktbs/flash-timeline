This software is a computer program whose purpose is to provide an
generic timeline visualisation for activity traces.

It depends on the following packages:

* com.ithaca.traces which can be obtained from the http://github.com/oaubert/astraces1 repository (Traces.swc
component).
* com.ithaca.tales which can be obtained from the http://github.com/oaubert/tales4as repository (TALES.swc
component).
* F*CSS 1.1.1 for CSS parsing. 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!! The custom https://github.com/oaubert/fcss/ version must be used. !!!
!!! Version is at least 1.1.1                                         !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

For each package, the swc file must be placed (or linked) in the lib/
directory for compilation of the Timeline.swc component.

To compile examples with the Makefiles, all SWC files (Timeline.swc,
Traces.swc, TALES.swc) components must be copied or linked in the lib/
directory of each example.
