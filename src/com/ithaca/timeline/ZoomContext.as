package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import flash.events.Event;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.events.ElementExistenceEvent;

	[Style(name = "backgroundColor", type = "Number", format="Color", inherit = "no")]
	public class ZoomContext  extends SkinnableContainer
	{		
		[SkinPart(required="true")]
		public var cursor	 		: UIComponent;
		[Bindable]
		[SkinPart(required="true")]
		public var timelinePreview	: Group;
		[SkinPart(required="true")]
		public var inputTimeRuler	: TimeRuler;

		public var _timeline	    : Timeline;
		
		public var _timelineRange	: TimeRange;
		public var cursorRange		: TimeRange;	
		
		public function ZoomContext() : void 
		{				
			super();	
			enabled = false;
		}	
		
		public function set timeline( value : Timeline ) : void 
		{
			if ( _timeline == value) 
				return; 
			
			_timeline 		= value; 
			_timelineRange 	= _timeline.range;
			cursorRange 	= new TimeRange();
			
			timelinePreview.addEventListener( Event.RESIZE, updateSkinPositionFromValues );
			_timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, onTimelineTimesChange );
			_timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, inputTimeRuler.onTimeRangeChange);
			_timeline.addEventListener( ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange);				 
			_timeline.addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);
			_timeline.addEventListener( TimelineEvent.LAYOUT_CHANGE, onTimelineLayoutChange );						
		}
		public function get timeline( ) : Timeline  { return  _timeline; }
				
		public function updateSkinPositionFromValues( e: Event = null) : void
		{
			if ( cursor && _timeline && timelinePreview && !cursorRange.isEmpty())
			{						
				cursor.x 		= timelinePreview.x + _timelineRange.timeToPosition( cursorRange.begin, timelinePreview.width );
				cursor.width 	= timelinePreview.x + _timelineRange.timeToPosition( cursorRange.end, timelinePreview.width ) - cursor.x ;
			}
		}
		
		public function updateValuesFromSkinPosition( e: Event = null ) : void
		{	
			switch (e.type)
			{
				case MoveEvent.MOVE :
					var oldPos 	: Number 	= _timelineRange.positionToTime( (e as MoveEvent).oldX - timelinePreview.x, timelinePreview.width );
					var newPos 	: Number 	= _timelineRange.positionToTime( cursor.x - timelinePreview.x, timelinePreview.width );
					cursorRange.shiftLimits( newPos - oldPos );					
				break;
				default:
					var begin 	: Number 	= _timelineRange.positionToTime( cursor.x  - timelinePreview.x, timelinePreview.width );
					var end 	: Number 	= _timelineRange.positionToTime( cursor.x  + cursor.width  - timelinePreview.x, timelinePreview.width );					
					cursorRange.changeLimits(begin, end);
			}
		}	
		
		public function addTraceLineGroupPreview( tlg : TraceLineGroup, index : Number  = -1  ) : void 
		{
			var simpleObselsRenderer : SimpleObselsRenderer = new SimpleObselsRenderer( _timelineRange, _timeline );
			simpleObselsRenderer.borderVisible = false;
			if ( tlg.contextPreviewTraceLine ) 
				simpleObselsRenderer.obselsCollection 	= tlg.contextPreviewTraceLine._obsels;
			else
				simpleObselsRenderer.obselsCollection 	= 	tlg.trace.obsels;			
			
			_timeline.addEventListener( TimelineEvent.TIMERANGES_CHANGE, simpleObselsRenderer.onTimerangeChange );
			simpleObselsRenderer.percentWidth 	= 100;
			simpleObselsRenderer.percentHeight 	= 100;
			
			if (index < 0 )
				timelinePreview.addElement(simpleObselsRenderer);
			else
				timelinePreview.addElementAt(simpleObselsRenderer, index );
		}
		
		public function removeTraceLineGroupPreviewAt( i : uint ) : void 
		{
			timelinePreview.removeElementAt( i ) ;
		}
		
		public function onTracelineGroupsChange( event: ElementExistenceEvent ) : void
		{
			if ( event.type == ElementExistenceEvent.ELEMENT_ADD )			
				addTraceLineGroupPreview( event.element as TraceLineGroup, event.index );
			else if ( event.type == ElementExistenceEvent.ELEMENT_REMOVE )
				removeTraceLineGroupPreviewAt( event.index );
		}	
		
		private function onTimelineLayoutChange( e : Event ) : void
		{
							 
		}
		
		private function onTimelineTimesChange( e : TimelineEvent ) : void
		{			
			_timelineRange = e.currentTarget as TimeRange;
			
			var begin : Number;
			var duration : Number;
			
			if ( cursorRange.isEmpty() )
			{
				enabled  = true;
				begin 		= _timelineRange.begin;
				duration 	= ( _timelineRange.end - _timelineRange.begin )*Stylesheet.ZoomContextInitPercentWidth / 100;
			}		
			else
			{
				begin 		= Math.max( cursorRange.begin, _timelineRange.begin );
				duration  	= Math.min( cursorRange.end, _timelineRange.end ) - begin;
			}
			
			cursorRange.clone( _timelineRange );
			cursorRange.changeLimits(begin, begin + duration);
			updateSkinPositionFromValues();		
		}
		
		public function setRange( beginValue : Number, endValue : Number ) : void
		{
			cursorRange.changeLimits(beginValue, endValue);
			updateSkinPositionFromValues();			
		}
		
		public function shiftContext( deltaTime : Number ) : void
		{				
			var delta: Number = 0;
			if (deltaTime > 0 )
				delta	=	Math.min(deltaTime, _timelineRange.end - cursorRange.end);
			else
				delta	=	Math.max(deltaTime, _timelineRange.begin- cursorRange.begin);
			cursorRange.shiftLimits( delta );
			updateSkinPositionFromValues();			
		}
	}
}