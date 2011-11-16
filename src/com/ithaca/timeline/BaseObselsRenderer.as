package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ResizeEvent;
	
	/**
	 * <p>The BaseObselsRenderer is the base class of ObselRenderers.
	 * It's contained by Traceline in both the tree structure and the zoomContext as preview.
	 * Common properties are defined and  handles listenners and callbacks to draw and redraw the obsels when needed. </p>
	 *
	 * <p>There're two main instances of this class : SimpleObselsRenderer that draws obsels from scratch and ObselsRenderer which uses skins to render the obsels. </p>
	 *
	 * <p>It should be an abstract class. The redraw function must be overrided. </p>
	 *
	 * @see SimpleObselsRenderer
	 * @see ObselsRenderer
	 */
	
	public class BaseObselsRenderer extends UIComponent
	{
		/**
		 * Reference to the Timeline
		 */
		protected var _timeline			: Timeline;
		/**
		 * Reference to the TraceLine that contains the BaseObselsRenderer
		 */
		protected var _traceline		: TraceLine;
		/**
		 * Reference to the TimeRange.
		 * There's two main possibilities, if the obselRenderer is in the tree structure the timeRange is the zoomContext.contextRange
		 * otherwise the obselRenderer is in the preview zone and the timeRange is the zoomContext.timelineRange
		 */
		protected var _timeRange		: TimeRange = null;
		/**
		 * 	the obsels collection displayed by this component
		 */
		protected var _obsels 			: ArrayCollection = null;
		/**
		 * 	Specifies if the borders of the obselsRenderer must be visible or not.
		 */
		public 	  var borderVisible 	: Boolean = true;
			
		/**
		 * Constructor
		 *
		 * @param tr The TimeRange that
		 * @param traceLine the TraceLine that contains the BaseObselsRenderer
		 * @param timeline the Timeline
		 */
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
		
		/**
		 * Change the obsels collection that is displayed by the obsels renderer.
		 *
		 * @param obsels The new obsels collection.
		 */
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
				
		/**
		 * The callback used when the TimeRange dispatch a TimelineEvent.TIMERANGES_CHANGE or TimelineEvent.TIMERANGES_SHIFT event.
		 *
		 * Should be override to optimise rendering.
		 *
		 * @param event
		 */
		public function  onTimerangeChange( event : TimelineEvent ) : void
		{
			_timeRange = event.currentTarget as TimeRange;
			
			redraw();
		}
		
		/**
		 * The callback used when the TimeRange dispatch a CollectionEvent.COLLECTION_CHANGE event.
		 *
		 * Should be override to optimise rendering.
		 *
		 * @param event
		 */
		public function  onObselsCollectionChange( event : CollectionEvent ) : void
		{
			redraw();
		}	
		
		/**
		 * The callback used when the component dispatch a ResizeEvent.RESIZE event.
		 *
		 * Should be override to optimise rendering.
		 *
		 * @param event
		 */
		public function  onResize( event : ResizeEvent ) : void
		{
			redraw();
		}	
		
		/**
		 * MUST BE OVERRIDED. Should do a full render process but do nothing in this base class.
		 *
		 * <p>
		 * By Default, this function is called by all the callbacks defined in this class and called when an event that requires redrawing is distpatched.
		 * To optimise the rendering, different functions should exist to handle the different events.
		 * </p>
		 *
		 * @param event
		 */
		public function  redraw( event : Event = null) : void
		{					
		}
	}
}