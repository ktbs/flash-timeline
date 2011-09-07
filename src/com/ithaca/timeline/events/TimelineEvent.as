package com.ithaca.timeline.events 
{
	import com.ithaca.timeline.TimeRange;
	import flash.events.Event;
		
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