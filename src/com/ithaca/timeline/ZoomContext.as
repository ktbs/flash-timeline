package com.ithaca.timeline
{
	import flash.display.Graphics;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class ZoomContext  extends SkinnableContainer
	{
		static public const  TIMES_CHANGE : String = "ZoomContext_times_change";
		
		[SkinPart(required="true")]
		public var maxRange	 		: Group;
		[SkinPart(required="true")]
		public var minRange			: Group;
		[SkinPart(required="true")]
		public var cursor	 		: Group;
		[SkinPart(required="true")]
		public var timelinePreview	: SkinnableContainer;
		
		private var _timeline	    : Timeline;
		
		public var startTime		: Number = 0;
		public var duration			: Number = 1000;
		public var firstInit		: Boolean = true;
		
		
		public function ZoomContext() : void 
		{
			super();
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
			_timeline.addEventListener( Timeline.TIMES_CHANGE, onTimelineTimesChange );
			_timeline.addEventListener( Timeline.LAYOUT_CHANGE, onTimelineLayoutChange );			
		}
		public function get timeline( ) : Timeline  { return  _timeline; }
				
		public function updateSkinPositionFromValues() : void
		{
			if ( cursor && _timeline && timelinePreview)
			{		
				cursor.width 	= duration * timelinePreview.width / _timeline.duration;
				cursor.x 		= timelinePreview.x +  (startTime - _timeline.startTime ) * timelinePreview.width / _timeline.duration;
				minRange.x 		=  cursor.x -minRange.width;
				maxRange.x 		=  Math.min(cursor.x + cursor.width, timelinePreview.width+timelinePreview.x -1);
			}
		}
		
		public function updateValuesFromSkinPosition() : void
		{
			//trace("ZC :: starttime : " + startTime + ", duration " + duration );
			
			startTime 	=  _timeline.startTime + (cursor.x -timelinePreview.x)* _timeline.duration / timelinePreview.width;
			duration 	=  cursor.width * _timeline.duration / timelinePreview.width;
			
			dispatchEvent( new Event( TIMES_CHANGE ) );
		}	
		
		public function onTracelineGroupsChange( event: CollectionEvent ) : void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each ( var tlg : LayoutNode in event.items )
					{
						var simpleObselsRenderer : SimpleObselsRenderer = new SimpleObselsRenderer();
						simpleObselsRenderer.startTime			= _timeline.startTime;
						simpleObselsRenderer.duration	    	= _timeline.duration; 
						simpleObselsRenderer._timeline		 	= _timeline;
						simpleObselsRenderer.obselsCollection 	= (tlg.value as TraceLineGroup)._trace.obsels;
						_timeline.addEventListener( Timeline.TIMES_CHANGE, simpleObselsRenderer.onTimelineChange );
						simpleObselsRenderer.percentWidth = 100;
						simpleObselsRenderer.percentHeight = 100;
						timelinePreview.addElement(simpleObselsRenderer);
					}
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
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
		
		private function onTimelineTimesChange( e : Event ) : void
		{
			startTime = Math.max( startTime, _timeline.startTime );
			
			if ( firstInit )
			{
				duration =  _timeline.duration * 0.3;
				firstInit = false;
			}
			else
				duration  = Math.min( duration , _timeline.endTime - startTime );
						 
		//	 trace("ZC :: starttime : " + startTime + ", duration " + duration );
			 
			 updateSkinPositionFromValues();			 
		}
	}
}