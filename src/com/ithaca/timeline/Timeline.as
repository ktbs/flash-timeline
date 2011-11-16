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
	import mx.events.ResizeEvent;
	
	/**
	 * This style change the zoomContext cursor behavior.
	 * <p>
	 * If set to 'follow', the cursor follow the current time and it cannot be edited until the 'lock/unlock' button is clicked.
	 * If set to 'auto' the cursor follow the current time until this cursor is edited. After editing, the 'lock/unlock' button can be change to restart following.
	 * If set to 'manual' the cursor don't follow the current time and can be freely edited.
	 * </p>
	 * @default manual
	 */
	[Style(name = "cursorMode",			type = "String", inherit = "no")]
	/**
	 * This style could be used in ths skins to allow layout editing for example
	 */
	[Style(name = "adminMode",			type = "Boolean", inherit = "no")]
	/**
	 * if 'relative', the time labels starts from 0 otherwise the time labels start from the beginning of the traces
	 */
	[Style(name = "timeMode", 			type = "String", inherit = "no")]
	/**
	 * This event is dispatched when the current time change (with 'set currentTime' ).
	 * The current time of the timeline never change internaly, it must be changed by the setter of currentTime.
	 */
	[Event(name = "currentTimeChange", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when one the two time ruler is clicled. Mostly to indicate that the user want to change the currentTime.
	 * The 'value' property of the TimelineEvent is this the time in milliseconds.
	 */
	[Event(name = "timeRulerClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when the 'play' button is clicked.
	 */
	[Event(name = "playButtonClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when the 'pause' button is clicked.
	 */
	[Event(name = "pauseButtonClick", 	type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when the currentTime  exceed the endAlertBeforeTime property milliseconds before the end of the time range of the timeline.
	 */
	[Event(name = "endAlert", 			type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when the currentTime reached (or exceed) the end of the time range of the timeline.
	 */
	[Event(name = "endReached", 		type = "com.ithaca.timeline.events.TimelineEvent")]
	/**
	 * This event is dispatched when a traceline is created by a layoutModifier
	 * The 'value' property of the TimelineEvent is an object with 3 properties { generator, obsel, traceline } where  :
	 * 'generator' is the LayoutModier,
	 * 'traceline' the created traceline,
	 * and 'obsel' is the obsel for wich we create a new traceline.
	 */
	[Event(name = "generateNewTraceline", 	type = "com.ithaca.timeline.events.TimelineEvent")]	
	/**
	 * This event is dispatched when a layout node is added as child of another.
	 * The 'value' property of the TimelineEvent is this LayoutNode.
	 */
	[Event(name = "layoutNodeAdded", 	type = "com.ithaca.timeline.events.TimelineEvent")]	

	/**
	 * The main component of the package and the entry point of the API.
	 */
	public class Timeline  extends LayoutNode
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;	
		
		public  var range			: TimeRange;
		
		[SkinPart(required="true")]
		/**
		 * The container that contains the title part of the TracelineGroups
		 */
		public  var titleGroup		: Group;
		
		[SkinPart(required = "true")]
		public  var zoomContext		: ZoomContext;
				
		[SkinPart(required="true")]
		/**
		 * The cursor that indiquates the current time value 		
		 */
		public  var globalCursor	: Cursor;
		
		[SkinPart(required="true")]
		/**
		 * The cursor that indiquates the current time value 	
		 */
		public  var contextCursor	: Cursor;
		
		private var _currentTime				: Number = 0;

		public  var endAlertBeforeTime			: Number = 30000;
		private var endAlertEventDispatched 	: Boolean = false;
		private var endReachedEventDispatched 	: Boolean = false;
		
		[Bindable]
		public var	isPlaying : Boolean = false;
		[Bindable]
		public var	showPlayButton : Boolean = false;

		[Bindable]
		public var contextFollowCursor : Boolean = false;

		/**
		 * Timeline constructor
		 * @param xmlLayout an xml definition of the timeline layout
		 */
		public function Timeline( xmlLayout : XML = null )
		{
			super();
			if (xmlLayout)			
				layoutXML = xmlLayout;	
			else
				layoutXML = <root> <tlg /> </root>;
		
			_timeline = this;
			
			timelineLayout = new Layout( this ) ;
			_styleSheet = new Stylesheet();
			range = new TimeRange( );
			addEventListener(TimelineEvent.CURRENT_TIME_CHANGE, changeCursorValue );
			range.addEventListener(TimelineEvent.TIMERANGES_CHANGE, function():void { endAlertEventDispatched = false; } );
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			if ( zoomContext)
				if (!styleProp || styleProp == 'cursorMode')
				{
					switch( getStyle('cursorMode') )
					{
						case 'auto' :		
							zoomContext.cursorEditable = true;
							contextFollowCursor = true;
							break;
						case 'follow' :
							contextFollowCursor = true;
							zoomContext.cursorEditable = false;
							break;
						case 'manual' :
							zoomContext.cursorEditable = true;
							contextFollowCursor = false;
							break;					
						default :
							break;						
					}
				}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);			
			if ( partName == "zoomContext" )
			{
				zoomContext.timeline = this;
				styleChanged('cursorMode');
				zoomContext.addEventListener(ResizeEvent.RESIZE, changeCursorValue);
				zoomContext.cursorRange.addEventListener(TimelineEvent.TIMERANGES_CHANGE, changeCursorValue);
				zoomContext.cursorRange.addEventListener(TimelineEvent.TIMERANGES_SHIFT, changeCursorValue);	
				zoomContext._timelineRange.addEventListener(TimelineEvent.TIMERANGES_CHANGE, changeCursorValue);
				zoomContext._timelineRange.addEventListener(TimelineEvent.TIMERANGES_SHIFT, changeCursorValue);	
			}
			if ( partName == "titleGroup" )
			{
				addEventListener( ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange );				
				addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);		
			}
		}	
		
		/**
		 * Update the titleGroup when the contentGroup which contains the traceLineGroups change.
		 * <p> As we work on the contentGroup in the case of TraceLineGroup removal or  TraceLineGroup Drag'n Drop we must update the titleGroup ( they must always stay in the same order ).</p>
		 */
		private function onTracelineGroupsChange( event: ElementExistenceEvent ) : void
		{
			if ( event.type == ElementExistenceEvent.ELEMENT_ADD )		
				titleGroup.addElementAt( (event.element as TraceLineGroup).titleComponent, event.index );
			else if ( event.type == ElementExistenceEvent.ELEMENT_REMOVE )
				titleGroup.removeElementAt( event.index );
		}	
		
		/**
		 * Create a new Tracelinegroup from a trace and add it to the Timeline
		 * @param pTrace the trace to add
		 * @param index the position of new Tracelinegroup in the Timeline ( -1 to add it at the end )
		 * @param style the style name of the tracelinegroup to create.
		 * @return the TraceLineGroup if the creation successed otherwise return null.
		 */
		public function addTrace (  pTrace : Trace, index : int = -1, style : String = null  )  : TraceLineGroup
		{
			var tlg : TraceLineGroup  =  timelineLayout.createTracelineGroupTree( pTrace, style );
			
			if (tlg)
			{
				if ( !isNaN(tlg.traceBegin ) && !isNaN(tlg.traceEnd ) )
				range.addTime( tlg.traceBegin, tlg.traceEnd);
			
				addChildAndTitle(  tlg , index );					
			}
			
			return tlg;
		}
		
		/**
		 * Remove the first Tracelinegroup with a given trace
		 * @param tr the trace of the TraceLineGroup
		 * @return true if sucess else return false.
		 */
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
		
		/**
		 * Find and return the first TraceLineGroup which the trace has a given URI ; return null if not found.
		 * @param uri the uri of the trace
		 * @return the tracelinegroup if exists. null if not found.
		 */
		public function getTraceLineGroupByTraceUri ( uri : String ) : TraceLineGroup
		{
			for (var i : int = 0; i < numElements; i++)
			{
				var tlg : TraceLineGroup = getElementAt(i) as TraceLineGroup;
				if ( tlg.trace.uri == uri )					
						return tlg ;
			}
			
			return null;
		}
				
		/**
		 * Remove a TraceLineGroup
		 * @param tlg the TraceLineGroup to remove.
		 */
		public function removeTraceLineGroup ( tlg : TraceLineGroup ) : void
		{
			if ( tlg )
				removeElement( tlg );				
		}
		
		/**
		 * Change the position of a TraceLineGroup
		 * @param fromIndex
		 * @param toIndex
		 */
		public function moveTraceLineGroup( fromIndex : uint, toIndex : uint) : void
		{	
			addElementAt( getElementAt(fromIndex) as TraceLineGroup, toIndex );	
		}

		/**		
		 * @return the Layout object bind to this Timeline
		 * @see Layout
		 */
		public function get timelineLayout() : Layout 			{ return _layout; }
		/**
		 * Set the Layout object of the timeline
		 * @param value
		 */
		public function set timelineLayout( value:Layout ):void
		{ 						
			if (_layout)
			{
				//the selectors must be load before the _layout because the traceline could be define by using one of them
				_layout.loadObselsSelectors( layoutXML[Layout.OBSELS_SELECTORS] );
				
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
		
		/**	
		 * @return the beginning value of the timeline in milliseconds
		 */
		public function get begin() 				: Number 	{ return range.begin; }
		
		/**
		 * @return  the ending value of the timeline in milliseconds
		 */
		public function get end() 					: Number 	{ return range.end; }
		
		/**
		 * @return  the duration of the timeline in milliseconds
		 */
		public function get duration() 				: Number 	{ return range.duration; }
		
		/**
		 * @return
		 */
		public function get styleSheet() 			: Stylesheet { return _styleSheet; }
		/**
		 * @param value
		 */
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }

		/**
		 * Change the time range limits. It's used to make a zoom for example.
		 * By default, the range limits are the limits of the loaded traces.
		 * @param startValue
		 * @param endValue
		 */
		public function setTimeRangeLimits( startValue : Number, endValue : Number ) : void
		{
			range.changeLimits( startValue, endValue );	
		}
		
		/**
		 * Reset the time range limits to the the limits of the loaded traces.
		 */
		public function resetTimeRangeLimits( ) : void
		{
			range.reset();
		}
		
		/**
		 * Make a time hole between the startValue and endValue.
		 * @param startValue lower limit of the time hole interval
		 * @param endValue higher limit of the time hole interval
		 */
		public function makeTimeHole( startValue : Number, endValue : Number ) : void
		{
			range.makeTimeHole( startValue, endValue);
			zoomContext.setRange( range.begin, range.end );
		}		
		
		/**
		 * @return the current time value in milliseconds
		 */
		public function get currentTime( ) : Number
		{
			return _currentTime;		
		}
		
		/**
		 * @return the current time value in milliseconds from the beginning of the timeline range
		 */
		public function get currrentRelativeTime() : Number
		{
			return currentTime - range._ranges[0];
		}
		
		/**
		 * Modify the current time value. It's the only way to change the current value of the timeline and it's never called in the timeline code (then it must be change from outside)
		 * @param timeValue the new time value in milliseconds
		 */
		public function set currentTime(  timeValue : Number ) : void
		{
			var timerangeEnd 	: Number = range._ranges[ range._ranges.length -1 ];
			var timerangeBegin 	: Number = range._ranges[ 0 ];
							
			if ( timeValue > timerangeEnd )
			{
				dispatchEvent( new TimelineEvent( TimelineEvent.END_REACHED ) );
				timeValue = timerangeEnd;
			}
			
			if ( timeValue >= timerangeEnd - endAlertBeforeTime )
			{
				if ( !endAlertEventDispatched )
				{
					endAlertEventDispatched = true;
					dispatchEvent( new TimelineEvent( TimelineEvent.END_ALERT ) );
				}
			}
			else
				endAlertEventDispatched = false;
			
			_currentTime = timeValue;		
			dispatchEvent( new TimelineEvent( TimelineEvent.CURRENT_TIME_CHANGE, true) )
		}
				
		private function changeCursorValue( event : Event ) : void
		{			
			var timeValue : Number = currentTime;
			
			if ( timeValue >= begin && timeValue <= end )
			{
				globalCursor.visible = true;
				globalCursor.x = Stylesheet.renderersSidePadding + zoomContext._timelineRange.timeToPosition(timeValue, zoomContext.timelinePreview.width );
			}
			else
				globalCursor.visible = false;			
			
			
			var minPosition : Number = zoomContext.cursorRange.begin;
			var maxPosition : Number = zoomContext.cursorRange.end 	 - zoomContext.cursorRange.duration*0.15;
				
			if ( contextFollowCursor && !contextCursor.isDragging && ( timeValue > maxPosition || timeValue < minPosition  )) 	
				zoomContext.shiftContext( timeValue - zoomContext.cursorRange.begin );											
			
			
			if ( timeValue >= zoomContext.cursorRange.begin && timeValue <= zoomContext.cursorRange.end +1000 )
			{
				contextCursor.visible = true;								
				contextCursor. x = Stylesheet.renderersSidePadding + zoomContext.cursorRange.timeToPosition(timeValue, zoomContext.timelinePreview.width );
			}
			else
				contextCursor.visible = contextCursor.isDragging;
		}			
		
		/**
		 * @return true if the timeMode style is set to 'relative'. 'true' means that each timeLabels must be shown in relative mode (from 0 to timeline duration)
		 */
		public function get isRelativeTimeMode( ) : Boolean
		{
			return getStyle('timeMode') == 'relative';
		}
	}
}