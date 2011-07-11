package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	import mx.collections.ArrayCollection;
	import mx.containers.errors.ConstraintError;
	import spark.components.SkinnableContainer;
	import spark.components.Group;
	import com.ithaca.timeline.Divider;
	
	public class Timeline  extends SkinnableContainer
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		
		public  var startTime		: Number = 0;
		public  var duration		: Number = 1000;
		
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
				_layout = new Layout( this, xmlLayout ) ;	
		}
		
		override protected function partAdded(partName:String, instance:Object):void 
		{ 
			super.partAdded(partName, instance);			
			if ( partName == "zoomContext" )
			{
				zoomContext._timeline = this;
			}
		}		

		public function addTrace (  pTrace : Trace, index : int = -1 )  :void 
		{
			startTime = 0;
			duration = 1;
			startTime = ((pTrace.obsels[0] as Obsel).begin > startTime)?(pTrace.obsels[0] as Obsel).begin : startTime;
			duration = ((pTrace.obsels[pTrace.obsels.length -1] as Obsel).begin > startTime + duration)?(pTrace.obsels[pTrace.obsels.length -1] as Obsel).begin -  startTime : duration;
			timelineLayout.addTracelineGroupTree( timelineLayout.createTracelineGroupTree( pTrace ) );
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
		
		public function get timelineLayout() : Layout { return _layout; }
		public function set timelineLayout( value:Layout ):void { _layout = value; }
		
		public function get tracelineGroups() : ArrayCollection { return timelineLayout.tracelineGroups; }
		
		public function get styleSheet() : Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
		
		[Bindable]
		public function get titleGroupWidth() : Number 
		{ 			
				return _titleGroupWidth ;
		}
		public function set titleGroupWidth( value:Number ):void { _titleGroupWidth = value; }
	}
}