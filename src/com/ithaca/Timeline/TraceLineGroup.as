package com.ithaca.Timeline
{
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;

	public class TraceLineGroup
	{
		public var title : String;
		public var _trace : Trace;
		
		public function TraceLineGroup()
		{
		}
		
		public function get traceUri () : String { return _trace.uri; }
		
		public function onTraceChange () : void  {};
	}
}