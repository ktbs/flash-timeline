package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.timeline.PlayPauseButton;
	import com.ithaca.traces.Trace;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.ElementExistenceEvent;	
	
	
	[Style(name = "timeMode", 			type = "String", inherit = "no")]
	[Event(name = "timeRulerClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	[Event(name = "playButtonClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	[Event(name = "pauseButtonClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	[Event(name = "endAlert", 			type = "com.ithaca.timeline.events.TimelineEvent")]
	[Event(name = "endReached", 		type = "com.ithaca.timeline.events.TimelineEvent")]
	public class Timeline  extends LayoutNode
	{
		static public const  RECORD_MODE_INCREMENT : Number = 10 * 60 * 1000;
		
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		public  var range			: TimeRange;
		
		[SkinPart(required="true")]
		public  var titleGroup		: Group;
		
		[SkinPart(required="true")]
		public  var zoomContext		: ZoomContext;
				
		[SkinPart(required="true")]
		public  var globalCursor	: UIComponent;
		
		[SkinPart(required="true")]
		public  var contextCursor	: UIComponent;
		
		public var endAlertThreshold			: Number = 90;
		private var endAlertEventDispatched 	: Boolean = false;
		private var endReachedEventDispatched 	: Boolean = false;

		public var contextFollowCursor : Boolean = false;
		public var recordMode		   : Boolean = false;
		
		public function Timeline( xmlLayout : XML = null )
		{
			super(); 
			if (xmlLayout)			
				layoutXML = xmlLayout;	
			else 
				layoutXML = <root> <tlg /> </root>;
			
			timelineLayout = new Layout( this ) ;				
			_styleSheet = new Stylesheet();
			range = new TimeRange( );
		}
		
		override protected function partAdded(partName:String, instance:Object):void 
		{ 
			super.partAdded(partName, instance);			
			if ( partName == "zoomContext" )
			{
				zoomContext.timeline = this;
			}
			if ( partName == "titleGroup" )
			{
				addEventListener( ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange );				 
				addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);		
			}
		}	
		
		public function onTracelineGroupsChange( event: ElementExistenceEvent ) : void
		{
			if ( event.type == ElementExistenceEvent.ELEMENT_ADD )		
				titleGroup.addElementAt( (event.element as TraceLineGroup).titleComponent, event.index );
			else if ( event.type == ElementExistenceEvent.ELEMENT_REMOVE )
				titleGroup.removeElementAt( event.index );
		}	
		
		public function addTrace (  pTrace : Trace, index : int = -1, style : String = null  )  : TraceLineGroup 
		{
			var tlg : TraceLineGroup  =  timelineLayout.createTracelineGroupTree( pTrace, style );
			
			if ( !isNaN(tlg.traceBegin ) && !isNaN(tlg.traceEnd ) )
				range.addTime( tlg.traceBegin, tlg.traceEnd);
			
			timelineLayout.addTracelineGroup( tlg, index );	
			
			return tlg;
		}
		
		public function removeTrace ( tr : Trace ) : Boolean 
		{
			for (var i : int = 0; i < numElements; i++)
			{
				var tlg : TraceLineGroup = getElementAt(i) as TraceLineGroup;
				if ( tlg.trace == tr )
					{
						removeTraceLineGroup ( tlg );
						return true;
					}
			}
			return false;
		}
		
		public function removeTraceLineGroup ( tlg : TraceLineGroup ) : void
		{
			if ( tlg )
				removeElement( tlg );				
		}
		
		public function moveTraceLineGroup( fromIndex : uint, toIndex : uint) : void
		{	
			addElementAt( getElementAt(fromIndex) as TraceLineGroup, toIndex );	
		}

		public function get timelineLayout() : Layout 			{ return _layout; }
		public function set timelineLayout( value:Layout ):void 
		{ 						
			if (_layout)
			{
				var traceArray : Array = new Array();
			 
				for (var i : uint = 0; i < numElements; i++ )
				{					
					var tlg : TraceLineGroup = getElementAt(i) as  TraceLineGroup;
					traceArray.push ( (getElementAt(i) as  TraceLineGroup).trace );
				}
				removeAllElements();
				
				_layout = value;
				
				while (traceArray.length > 0 )
					addTrace( traceArray.shift() as Trace );
			}
			else
				_layout = value;
			
			dispatchEvent( new TimelineEvent( TimelineEvent.LAYOUT_CHANGE  ));
		}
		public function get begin() 				: Number 	{ return range.begin; }
		public function get end() 					: Number 	{ return range.end; }
		public function get duration() 				: Number 	{ return range.duration; }
		public function get styleSheet() 			: Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }

		public function setTimeRangeLimits( startValue : Number, endValue : Number ) : void
		{
			range.changeLimits( startValue, endValue );	
		}
		
		public function resetTimeRangeLimits( ) : void
		{
			range.reset();
		}
		
		public function makeTimeHole( startValue : Number, endValue : Number ) : void
		{
			range.makeTimeHole( startValue, endValue);
			zoomContext.setRange( range.begin, range.end );
		}		
		
		public function get currentTime( ) : Number
		{
			return zoomContext._timelineRange.positionToTime( globalCursor.x - Stylesheet.renderersSidePadding, zoomContext.width - 2 * Stylesheet.renderersSidePadding);
		}
		
		public function get currrentRelativeTime() : Number
		{
			return currentTime - range._ranges[0];
		}
		
		public function set currentTime(  timeValue : Number ) : void
		{
			var timerangeEnd : Number = range._ranges[ range._ranges.length -1 ];
			var timerangeBegin : Number = range._ranges[ 0 ];
			
			if ( timeValue > timerangeEnd )
			{
				dispatchEvent( new TimelineEvent( TimelineEvent.END_REACHED ) );
				timeValue = timerangeEnd;
			}
			
			if ( timeValue >= timerangeEnd - (timerangeEnd-timerangeBegin)*( 100 - endAlertThreshold)/100 )
			{
				if ( !endAlertEventDispatched )
				{
					endAlertEventDispatched = true;
					dispatchEvent( new TimelineEvent( TimelineEvent.END_ALERT ) );
				}
			}
			else
				endAlertEventDispatched = false;
			
			changeCursorValue( timeValue );
			dispatchEvent( new TimelineEvent( TimelineEvent.CURRENT_TIME_CHANGE, true) )
		}
				
		private function changeCursorValue( timeValue : Number ) : void
		{
			if ( timeValue >= begin && timeValue <= end ) 
			{
				globalCursor.visible = true;
				globalCursor. x = Stylesheet.renderersSidePadding + zoomContext._timelineRange.timeToPosition(timeValue, zoomContext.width - 2 * Stylesheet.renderersSidePadding);
			}
			else
				globalCursor.visible = false;			
			
			var minPosition : Number = zoomContext.cursorRange.begin;
			var maxPosition : Number = zoomContext.cursorRange.end 	 - zoomContext.cursorRange.duration*0.15;
						
			if ( contextFollowCursor && ( timeValue > maxPosition || timeValue < minPosition  ))
			{
				var  delta : Number;					
				delta = zoomContext.shiftContext( timeValue - zoomContext.cursorRange.begin );				
			}	
			
			if ( timeValue >= zoomContext.cursorRange.begin && timeValue <= zoomContext.cursorRange.end ) 
			{
				contextCursor.visible = true;								
				contextCursor. x = Stylesheet.renderersSidePadding + zoomContext.cursorRange.timeToPosition(timeValue, zoomContext.width - 2 * Stylesheet.renderersSidePadding);
			}
			else
				contextCursor.visible = false;
		}			
		
		public function get isRelativeTimeMode( ) : Boolean
		{
			return getStyle('timeMode') == 'relative';
		}
	}
}