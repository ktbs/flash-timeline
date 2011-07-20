package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	import spark.components.SkinnableContainer;
	
	[Style(name = "fillColors", type = "Array", format = "Color", inherit = "no")]
	public class TraceLineGroup  extends SkinnableContainer
	{
		public var title : String;
		public var _trace : Trace;
		public var  node : LayoutNode;
		public var traceBegin 	: Number = 0;
		public var traceEnd  	: Number = 0;
		
		
		public function TraceLineGroup( trac : Trace, title : String = null)
		{
			this.title = title;
			this.id = title;
			trace = trac;
		}
		
		public function set trace ( value : Trace ) : void
		{ 
			_trace = value
		
			 if (_trace.obsels && _trace.obsels.length )
			 {
				traceBegin 	 = (_trace.obsels[0] as Obsel).begin;
				traceEnd 	 = (_trace.obsels[0] as Obsel).begin;
				
				for each ( var obsel :Obsel in _trace.obsels)
				{	
					traceBegin 	= Math.min( traceBegin, obsel.begin );
					traceEnd 	= Math.max( traceEnd, 	obsel.end );
				}
			 }
		}
		
		public function get traceUri () : String { return _trace.uri; }
		
		public function onTimelineLayoutChange( event : TimelineEvent ) : void
		{
		}
	}
}