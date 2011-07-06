package com.ithaca.timeline
{
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;

	public class TraceLineGroup
	{
		public var title : String;
		public var _trace : Trace;
		
		public function TraceLineGroup( trac : Trace, title : String = null)
		{
			_trace = trac
			this.title = title;
		}
		
		public function get traceUri () : String { return _trace.uri; }
	}
}