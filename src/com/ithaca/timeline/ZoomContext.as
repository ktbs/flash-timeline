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
			
			_timeline 		= value; 
			_timelineRange 	= _timeline.range;
			cursorRange 	= new TimeRange();
			
			timelinePreview.addEventListener( Event.RESIZE, updateSkinPositionFromValues );
			_timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, onTimelineTimesChange );
			_timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, timeRuler.onTimeRangeChange);
			_timeline.addEventListener( TimelineEvent.LAYOUT_CHANGE, onTimelineLayoutChange );						
		}
		public function get timeline( ) : Timeline  { return  _timeline; }
				
		public function updateSkinPositionFromValues( e: Event = null) : void
		{
			if ( cursor && _timeline && timelinePreview && !cursorRange.isEmpty())
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
		}	
		
		public function addTraceLineGroupPreview( tlg : TraceLineGroup, index : Number  = -1  ) : void 
		{
			var simpleObselsRenderer : SimpleObselsRenderer = new SimpleObselsRenderer( _timelineRange, _timeline );											
			simpleObselsRenderer.obselsCollection 	= tlg._trace.obsels;
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
		
		public function onTracelineGroupsChange( event: CollectionEvent ) : void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each ( var tlg : TraceLineGroup in event.items )
						addTraceLineGroupPreview( tlg );
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
					removeTraceLineGroupPreviewAt( event.location );
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
		//	_timeline.timelineLayout.tracelineGroups.addEventListener(CollectionEvent.COLLECTION_CHANGE, onTracelineGroupsChange);				 
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
	}
}