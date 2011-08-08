package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import spark.components.Group;
	import spark.components.SkinnableContainer;

	public class ZoomContext  extends SkinnableContainer
	{		
		[SkinPart(required="true")]
		public var maxRange	 		: Group;
		[SkinPart(required="true")]
		public var minRange			: Group;
		[SkinPart(required="true")]
		public var cursor	 		: Group;
		[SkinPart(required="true")]
		public var timelinePreview	: Group;
		[SkinPart(required="true")]
		public var timeRuler		: TimeRuler;

		public var _timeline	    : Timeline;
		public var _timelineRange	: TimeRange;
		public var cursorRange		: TimeRange;
		
		public var zoomStart		: Number;
		public var zoomEnd			: Number;		
		
		public function ZoomContext() : void 
		{				
			super();	
			enabled = false;
		}	
		
		public function set timeline( value : Timeline ) : void 
		{
			if ( _timeline == value) 
				return;
				
			if ( _timeline )
			{
				//TODO Trying to bind ZoomContext to another timeline
			}
			
			_timeline = value; 
			timelinePreview.addEventListener( Event.RESIZE, updateSkinPositionFromValues );
			_timeline.addEventListener( TimelineEvent.TIMERANGES_CHANGE, onTimelineTimesChange );
			_timeline.addEventListener( TimelineEvent.TIMERANGES_CHANGE, timeRuler.onTimeRangeChange);
			_timeline.addEventListener( TimelineEvent.LAYOUT_CHANGE, onTimelineLayoutChange );						
		}
		public function get timeline( ) : Timeline  { return  _timeline; }
				
		public function updateSkinPositionFromValues( e: Event = null) : void
		{
			if ( cursor && _timeline && timelinePreview && cursorRange)
			{						
				cursor.x 		= timelinePreview.x + _timelineRange.timeToPosition( cursorRange.begin, timelinePreview.width ) - minRange.width;
				cursor.width 	= timelinePreview.x + _timelineRange.timeToPosition( cursorRange.end, timelinePreview.width ) + maxRange.width - cursor.x ;
				minRange.x 		= cursor.x;
				maxRange.x 		= cursor.x + cursor.width - maxRange.width;
			}
		}
		
		public function updateValuesFromSkinPosition() : void
		{	
			var begin 	: Number 	= _timelineRange.postionToTime( cursor.x + minRange.width - timelinePreview.x, timelinePreview.width );
			var end 	: Number 	= _timelineRange.postionToTime( cursor.x  + cursor.width - maxRange.width - timelinePreview.x, timelinePreview.width );	
			
			cursorRange.changeLimits(begin, end);
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , cursorRange )); 	
		}	
		
		public function onTracelineGroupsChange( event: CollectionEvent ) : void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each ( var tlg : LayoutNode in event.items )
					{
						var simpleObselsRenderer : SimpleObselsRenderer = new SimpleObselsRenderer( _timelineRange, _timeline );											
						simpleObselsRenderer.obselsCollection 	= (tlg.value as TraceLineGroup)._trace.obsels;
						_timeline.addEventListener( TimelineEvent.TIMERANGES_CHANGE, simpleObselsRenderer.onTimerangeChange );
						simpleObselsRenderer.percentWidth 	= 100;
						simpleObselsRenderer.percentHeight 	= 100;
						
						timelinePreview.addElement(simpleObselsRenderer);
					}
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
					timelinePreview.removeElementAt( event.location );
					break;
				}
				case CollectionEventKind.REPLACE :
				break;
				
				case CollectionEventKind.RESET :					
				break;				
				
				default:
			}
		}	
		
		private function onTimelineLayoutChange( e : Event ) : void
		{
			_timeline.timelineLayout.tracelineGroups.addEventListener(CollectionEvent.COLLECTION_CHANGE, onTracelineGroupsChange);				 
		}
		
		private function onTimelineTimesChange( e : TimelineEvent ) : void
		{			
			_timelineRange = e.value as TimeRange;
			
			var begin : Number;
			var duration : Number;
			if ( cursorRange == null)
			{
				begin 		= _timelineRange.begin;
				duration 	= ( _timelineRange.end - _timelineRange.begin )*Stylesheet.ZoomContextInitPercentWidth / 100;
				enabled  = true;
			}		
			else
			{
				begin 		= Math.max( cursorRange.begin, _timelineRange.begin );
				duration  	= Math.min( cursorRange.end, _timelineRange.end ) - begin;
			}
						
			cursorRange = _timelineRange.cloneMe();
			cursorRange.changeLimits(begin, begin + duration);
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , cursorRange )); 
			updateSkinPositionFromValues();		
		}
		
		public function setRange( beginValue : Number, endValue : Number ) : void
		{
			cursorRange.changeLimits(beginValue, endValue);
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , cursorRange )); 
			updateSkinPositionFromValues();			
		}
	}
}