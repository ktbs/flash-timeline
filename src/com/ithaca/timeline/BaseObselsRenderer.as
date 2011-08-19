package com.ithaca.timeline 
{
	import com.ithaca.timeline.events.TimelineEvent;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ResizeEvent;
	
	public class BaseObselsRenderer extends UIComponent 
	{
		protected var _timeline			: Timeline;
		protected var _traceline		: TraceLine;
		protected var _timeRange		: TimeRange = null;
		protected var _obsels 			: ArrayCollection = null;
		public 	  var borderVisible 	: Boolean = true;
			
		public function BaseObselsRenderer( tr : TimeRange, traceLine :  TraceLine, timeline : Timeline ) 
		{
			super();						
			_timeRange = tr;
			_traceline = traceLine;
			_timeline = timeline;
			addEventListener( ResizeEvent.RESIZE, onResize );
			_timeRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, onTimerangeChange);		
			_timeRange.addEventListener( TimelineEvent.TIMERANGES_SHIFT, onTimerangeChange);
		}
	
		public function get timeRange ( ) : TimeRange 
		{
			return _timeRange;
		}
		
		public function set obselsCollection( obsels : ArrayCollection ) : void
		{			
			if ( _obsels)
				_obsels.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onObselsCollectionChange);
			_obsels = obsels;		
			
			_obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE, onObselsCollectionChange);
			
			var e : CollectionEvent = new CollectionEvent( CollectionEvent.COLLECTION_CHANGE);
			e.kind = CollectionEventKind.RESET;
			onObselsCollectionChange( e );
		}
				
		public function  onTimerangeChange( event : TimelineEvent ) : void
		{
			_timeRange = event.currentTarget as TimeRange;
			
			redraw();
		}
		
		public function  onObselsCollectionChange( event : CollectionEvent ) : void
		{
			redraw();
		}	
		
		public function  onResize( event : ResizeEvent ) : void
		{
			redraw();
		}	
		
		public function  redraw( event : Event = null) : void
		{					
		}
	}
}