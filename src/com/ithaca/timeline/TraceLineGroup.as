package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	import spark.components.SkinnableContainer;
	
	/**
	 * 
	 */
	[Style(name = "fillColors", type = "Array", format = "Color", inherit = "no")]
	
	/**
	 * The space between the top of the TraceLineGroup and the top of the first Traceline
	 */
	[Style(name = "headerHeight", type = "Number", inherit = "no")]	
	
	/**
	 * The background color of the preview for this TracelineGroup in the zoomContext ; if 'auto' the color is the backgroundColor of the TracelineGroup.
	 */
	[Style(name = "previewBgColor", type = "String", inherit = "no")]	
	
	/**
	 * The TraceLineGroup class extends LayoutNode and it is a direct child of the timeline in the layout ; it contains the reference to the trace.
	 */	
	public class TraceLineGroup  extends LayoutNode
	{	
		public var title 			: String;
		protected var _trace 		: Trace;
		public var traceBegin 		: Number;
		public var traceEnd  		: Number;
		
		/**
		 * The traceline used to represent this tracelinegroup in the preview zone. In the XML descriptor, this traceline has the attribute : preview="true".	
		 * @see ZoomContext
		 */
		public var contextPreviewTraceLine 	: TraceLine;
				
		/**
		 * The traceline displayed in the background of the TraceLineGroup. In the XML descriptor, this traceline has the attribute : style="background".	 
		 */
		public var backgroundTraceLine 		: TraceLine;
		
		public var backgroundColor : uint;
				
		/**
		 * 
		 * @param	tl a reference to the timeline that contains this TraceLineGroup
		 * @param	trac the trace displayed by this TraceLineGroup
		 * @param	title the title and the name of the TraceLineGroup.
		 * @param	style the styleName of the TraceLineGroup and the TraceLineGroupTitle too.
		 */
		public function TraceLineGroup( tl : Timeline, trac : Trace, title : String = null, style : String = null )
		{
			this.title		= title;
			titleComponent	= new TraceLineGroupTitle( this );
			this.name 		= title;
			trace			= trac;
			_timeline 		= tl;
			if ( style )
			{
				styleName 	= style;
				titleComponent.styleName = style;
			}
		}
		
		/**
		 * @return the trace displayed by this TraceLineGroup
		 */
		public function get trace ( ) : Trace
		{ 
			return _trace;
		}
		
		/**
		 * Set the trace displayed by this TraceLineGroup
		 */
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
		
		/**
		 * @return the URI of the trace displayed by this TraceLineGroup
		 */
		public function get traceUri () : String { return _trace.uri; }
	}
}