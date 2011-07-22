package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.SkinnableContainer;
	
	public class Timeline  extends SkinnableContainer
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		private var range			: TimeRange;
		
		[Bindable]
		public  var _titleGroupWidth : Number = 200;
		[SkinPart(required="true")]
		public  var divider 		: Divider;
		[SkinPart(required="true")]
		public  var zoomContext		: ZoomContext;
		
		public function Timeline( xmlLayout : XML = null )
		{
			super(); 					
			if (xmlLayout)
				timelineLayout = new Layout( this, xmlLayout ) ;				
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
			var tlgNode : LayoutNode  =  timelineLayout.createTracelineGroupTree( pTrace );
			var tlg : TraceLineGroup  =  tlgNode.value as TraceLineGroup;
						
			if (range)
				range.addTime( tlg.traceBegin, tlg.traceEnd);
			else
				range = new TimeRange( tlg.traceBegin, tlg.traceEnd - tlg.traceBegin );					
			
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE ,range )); 	

			timelineLayout.addTracelineGroupTree( tlgNode );						 
		}
		
		public function removeTrace ( tr : Trace ) : Boolean 
		{
			for (var i : int = 0; i < tracelineGroups.length; i++)
				if ( ((( tracelineGroups[i] as LayoutNode ).value) as TraceLineGroup)._trace == tr )
					{
						tracelineGroups.removeItemAt(i);
						return true;
					}
			return false;
		}
		
		public function get timelineLayout() : Layout 			{ return _layout; }
		public function set timelineLayout( value:Layout ):void 
		{ 						
			if (_layout)
			{
				var traceArray : Array = new Array();
			 
				for each (var node : LayoutNode in tracelineGroups )
					traceArray.push ( (node.value as TraceLineGroup)._trace );
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
		public function get tracelineGroups() : ArrayCollection { return timelineLayout.tracelineGroups; }
		public function get styleSheet() : Stylesheet 			{ return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
		[Bindable]
		public function get titleGroupWidth() : Number 			{ return _titleGroupWidth ; }
		public function set titleGroupWidth( value:Number):void { _titleGroupWidth = value; }
		
		public function setTimeRangeLimits( startValue : Number, endValue : Number ) : void
		{
			range.changeLimits( startValue, endValue );
			
			dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE ,range )); 		
		}
		
		public function resetTimeRangeLimits( ) : void
		{
			range._ranges.removeAll();
			for each (var tlg : LayoutNode in tracelineGroups)
				range.addTime( (tlg.value as TraceLineGroup).traceBegin, (tlg.value as TraceLineGroup).traceEnd );
				
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