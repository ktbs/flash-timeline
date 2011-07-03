package com.ithaca.Timeline
{
	import com.ithaca.traces.Trace;
	
	public class Timeline
	{
		private var _styleSheet 		: Stylesheet;
		public var _Timelinelayout		: Layout;
		public var _Root				: LayoutNode ;
		
		public function Timeline()
		{
			super();
			
			_Timelinelayout = new Layout( this) ;
			_Root = new LayoutNode ();
			_Root._splitter = "traceUri"; 
			_Root.layout =  _Timelinelayout.layoutTree;
		}
		
		public function get styleSheet() : Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
		
		public function addTrace( pTrace : Trace ) : void {};
		public function removeTrace( pTrace : Trace ) : void {};
	}
}