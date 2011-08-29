package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	import spark.components.SkinnableContainer;
	
	[Style(name = "fillColors", type = "Array", format = "Color", inherit = "no")]
	[Style(name = "headerHeight", type = "Number", inherit = "no")]	
	public class TraceLineGroup  extends LayoutNode
	{	
		public var title 			: String;
		protected var _trace 			: Trace;
		public var traceBegin 		: Number;
		public var traceEnd  		: Number;
		
		public var contextPreviewTraceLine 	: TraceLine;
		public var backgroundTraceLine 		: TraceLine;
		
		[SkinPart(required="true")]
		public var backgroundColor : uint;
				
		public function TraceLineGroup( tl : Timeline, trac : Trace, title : String = null, style : String = null )
		{
			this.title = title;
			titleComponent = new TraceLineGroupTitle( this );
			this.id = title;
			trace = trac;
			_timeline = tl;
			if ( style )
			{
			 styleName = style;
			 titleComponent.styleName = style;
			}
		}
		
		public function get trace ( ) : Trace
		{ 
			return _trace;
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