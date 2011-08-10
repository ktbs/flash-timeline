package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Trace;
	import mx.collections.ArrayCollection;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;

	public class Timeline  extends LayoutNode
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		private var range			: TimeRange;
		
		[SkinPart(required="true")]
		public  var titleGroup		: Group;
		
		[SkinPart(required="true")]
		public  var zoomContext		: ZoomContext;
		
		public function Timeline( xmlLayout : XML = null )
		{
			super(); 			
			layoutXML = xmlLayout;
			if (xmlLayout)
				timelineLayout = new Layout( this ) ;				
			_styleSheet = new Stylesheet();
		}
		
		override protected function partAdded(partName:String, instance:Object):void 
		{ 
			super.partAdded(partName, instance);			
			if ( partName == "zoomContext" )
			{
				zoomContext.timeline = this;
			}
		}		

		public function addTrace (  pTrace : Trace, index : int = -1 )  :void 
		{
			var tlg : TraceLineGroup  =  timelineLayout.createTracelineGroupTree( pTrace );
						
			if (range)
				range.addTime( tlg.traceBegin, tlg.traceEnd);
			else
				range = new TimeRange( tlg.traceBegin, tlg.traceEnd - tlg.traceBegin );					
			
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , range )); 	
			
			timelineLayout.addTracelineGroupTree( tlg );		
			zoomContext.addTraceLineGroupPreview(tlg);			
		}
		
		public function removeTrace ( tr : Trace ) : Boolean 
		{
			for (var i : int = 0; i < numElements; i++)
			{
				var tlg : TraceLineGroup = getElementAt(i) as TraceLineGroup;
				if ( tlg._trace == tr )
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
			{
				zoomContext.removeTraceLineGroupPreviewAt ( getElementIndex(tlg) );
				titleGroup.removeElement( tlg.titleComponent );
				removeElement( tlg  );				
			}
		}
		
		public function moveTraceLineGroup( fromIndex : uint, toIndex : uint) : void
		{
			var tlg : TraceLineGroup = getElementAt(fromIndex) as TraceLineGroup;
			
			addElementAt( tlg, toIndex );
			titleGroup.addElementAt( tlg.titleComponent, toIndex );
			zoomContext.addTraceLineGroupPreview( tlg, toIndex );
			zoomContext.removeTraceLineGroupPreviewAt(fromIndex);
		}
		
		public function moveTraceLine( from : TraceLine, to : TraceLine) : void
		{
			timelineLayout.addTraceline( from, to );
		}
		
		
		public function get timelineLayout() : Layout 			{ return _layout; }
		public function set timelineLayout( value:Layout ):void 
		{ 						
			if (_layout)
			{
				var traceArray : Array = new Array();
			 
				for (var i : uint = 0; i < numElements; i++ )
					traceArray.push ( (getElementAt(i) as  TraceLineGroup)._trace );
				removeAllElements();
				
				_layout = value;
				
				while (traceArray.length > 0 )
					addTrace( traceArray.shift() as Trace );
			}
			else
				_layout = value;
			
			dispatchEvent( new TimelineEvent( TimelineEvent.LAYOUT_CHANGE , null ));
		}
		public function get begin() 				: Number 	{ return range.begin; }
		public function get end() 					: Number 	{ return range.end; }
		public function get duration() 				: Number 	{ return range.duration; }
//		public function get tracelineGroups() : ArrayCollection { return timelineLayout.tracelineGroups; }
		public function get styleSheet() : Stylesheet 			{ return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }

		public function setTimeRangeLimits( startValue : Number, endValue : Number ) : void
		{
			range.changeLimits( startValue, endValue );
			
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE ,range )); 		
		}
		
		public function resetTimeRangeLimits( ) : void
		{
			range._ranges.removeAll();
			for (var i : uint = 0; i < numElements; i++ )
			{
				var tlg : TraceLineGroup = getElementAt(i) as TraceLineGroup;
				range.addTime( tlg.traceBegin, tlg.traceEnd );
			}
				
			range.resetLimits( );
			
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE ,range)); 	
		}
		
		public function makeTimeHole( startValue : Number, endValue : Number ) : void
		{
			range.makeTimeHole( startValue, endValue);
			zoomContext.setRange( range.begin, range.end );
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE ,range)); 		
		}		
	}
}