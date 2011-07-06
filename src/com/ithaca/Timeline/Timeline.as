package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	import mx.collections.ArrayCollection;
	
	public class Timeline
	{
		private var _styleSheet 	: Stylesheet;
		private var _layout			: Layout;
		
		public function Timeline( xmlLayout : XML = null )
		{
			super(); 
			
			_layout = new Layout( xmlLayout ) ;	
		}
		
		public function addTrace (  pTrace : Trace, index : int = -1 )  :void 
		{
			layout.addTracelineGroupTree( layout.createTracelineGroupTree( pTrace ) );
			
			pTrace.addObsel( pTrace.obsels[12] )
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
		
		public function get layout() : Layout { return _layout; }
		public function set layout( value:Layout ):void { _layout = value; }
		
		public function get tracelineGroups() : ArrayCollection { return layout.tracelineGroups; }
		
		public function get styleSheet() : Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
	}
}