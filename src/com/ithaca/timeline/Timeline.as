package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.containers.errors.ConstraintError;
	import spark.components.SkinnableContainer;
	import spark.components.Group;
	import com.ithaca.timeline.Divider;
	
	public class Timeline  extends SkinnableContainer
	{
		static public const  TIMES_CHANGE : String = "times_change";
		static public const  LAYOUT_CHANGE : String = "layout_change";
		
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
			 // startTime and duration update
			 if ( pTrace.obsels && pTrace.obsels.length )
			 {
				if ( timelineLayout.tracelineGroups.length == 0 )			
				{	
					startTime = (pTrace.obsels[0] as Obsel).begin;
					duration = 0;
				}
				
				for each ( var obsel :Obsel in pTrace.obsels)
				{	
					startTime 	= ( startTime > obsel.begin)? obsel.begin : startTime;
					duration 	= ( duration < obsel.end - startTime)? obsel.end - startTime : duration;
				}
				
				dispatchEvent(new Event( TIMES_CHANGE) );
			 }
						
			trace("TL :: starttime : " + startTime + ", duration " + duration );
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
		public function set timelineLayout( value:Layout ):void { _layout = value; dispatchEvent(new Event( LAYOUT_CHANGE)); }
		
		public function get endTime() : Number { return startTime + duration; }
		public function set endTime( value : Number ) : void { duration = startTime - value; dispatchEvent(new Event( TIMES_CHANGE) ); }
		
		public function get tracelineGroups() : ArrayCollection { return timelineLayout.tracelineGroups;  }
		
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