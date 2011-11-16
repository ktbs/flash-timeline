package com.ithaca.timeline.events 
{
	import com.ithaca.timeline.TimeRange;
	import flash.events.Event;
	
	/**
	 * Define the new types of events needed by the timeline.
	 * Most of these events are dispatched by the Timeline class. 
	 * 
	 * <p> 
	 *	There's only one property 'value' which change according to the type of the event :
	 * 	<ol>
	 *		<li>TIMERULER_CLICK : 'value' contains the time in milliseconds where the user clicked </li>
	 *		<li>GENERATE_NEW_TRACELINE : 'value' is an Object with 3 properties : { generator, obsel, traceline } where  : 'generator' is the LayoutModier which just created a Traceline, 'traceline' the new traceline, and 'obsel' is the obsel by which the creation has been triggerered.</li>
	 *	  	<li>LAYOUT_NODE_ADDED :   'value' is the new added LayoutNode </li>
	 *	</ol>
	 * In the other cases, 'value' is not used.
	 * </p>
	 * 	
	 * @see com.ithaca.timeline.Timeline
	 */
	public class TimelineEvent extends Event 
	{		
		// constants
		static public const TIMERANGES_CHANGE 	: String = "timeranges_change";
		static public const TIMERANGES_SHIFT 	: String = "timeranges_shift";
		static public const TIMES_CHANGE 		: String = "times_change";
		static public const LAYOUT_CHANGE 		: String = "layout_change";	
		static public const TIMERULER_CLICK 	: String = "timeRulerClick";	
		static public const PLAY 				: String = "playButtonClick";
		static public const PAUSE				: String = "pauseButtonClick";
		static public const END_ALERT			: String = "endAlert";
	    static public const END_REACHED			: String = "endReached";
		static public const CURRENT_TIME_CHANGE	: String = "currentTimeChange";
		static public const ZOOM_CONTEXT_MANUAL_CHANGE : String = "zoomContextManualChange";
		static public const GENERATE_NEW_TRACELINE : String = "generateNewTraceline";
		static public const LAYOUT_NODE_ADDED :  String = "layoutNodeAdded";

		// properties
		public var value : *;		
		
		public function TimelineEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new TimelineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TimelineEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}		
	}	
}