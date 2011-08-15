package com.ithaca.timeline
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Trace;
	import mx.collections.ArrayCollection;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.ElementExistenceEvent;	

	public class Timeline  extends LayoutNode
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		public  var range			: TimeRange;
		
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
			range = new TimeRange( );					
		}
		
		override protected function partAdded(partName:String, instance:Object):void 
		{ 
			super.partAdded(partName, instance);			
			if ( partName == "zoomContext" )
			{
				zoomContext.timeline = this;
			}
			if ( partName == "titleGroup" )
			{
				addEventListener( ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange );				 
				addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);		
			}
		}	
		
		public function onTracelineGroupsChange( event: ElementExistenceEvent ) : void
		{
			if ( event.type == ElementExistenceEvent.ELEMENT_ADD )		
				titleGroup.addElementAt( (event.element as TraceLineGroup).titleComponent, event.index );
			else if ( event.type == ElementExistenceEvent.ELEMENT_REMOVE )
				titleGroup.removeElementAt( event.index );
		}	

		public function addTrace (  pTrace : Trace, index : int = -1 )  :void 
		{
			var tlg : TraceLineGroup  =  timelineLayout.createTracelineGroupTree( pTrace );
						
			range.addTime( tlg.traceBegin, tlg.traceEnd);
			
			timelineLayout.addTracelineGroupTree( tlg );		
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
				removeElement( tlg );				
		}
		
		public function moveTraceLineGroup( fromIndex : uint, toIndex : uint) : void
		{	
			addElementAt( getElementAt(fromIndex) as TraceLineGroup, toIndex );	
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
			
			dispatchEvent( new TimelineEvent( TimelineEvent.LAYOUT_CHANGE  ));
		}
		public function get begin() 				: Number 	{ return range.begin; }
		public function get end() 					: Number 	{ return range.end; }
		public function get duration() 				: Number 	{ return range.duration; }
		public function get styleSheet() 			: Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }

		public function setTimeRangeLimits( startValue : Number, endValue : Number ) : void
		{
			range.changeLimits( startValue, endValue );	
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
		}
		
		public function makeTimeHole( startValue : Number, endValue : Number ) : void
		{
			range.makeTimeHole( startValue, endValue);
			zoomContext.setRange( range.begin, range.end );
		}		
	}
}