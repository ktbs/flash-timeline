package com.ithaca.Timeline
{
	import com.ithaca.traces.Trace;
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;

	public class TraceLineGroup implements ILayoutNode
	{
		public var title : String;
		
		public var _trace : Trace;
		private var _traceLines : ArrayCollection;
		
		private var _layout : XML;
		
		public function TraceLineGroup()
		{
			_traceLines = new ArrayCollection();
		}
		
		public function acceptObsel ( obsel : Obsel ) : Boolean
		{
			return ( obsel.traceUri == _trace.uri ); 
		}
		
		public function splitBy():String
		{			
			return "traceUri";
		}
		
		public function get children ( ) : ArrayCollection
		{
			return _traceLines;
		}
		
		public function set layout(layoutXML:XML):void
		{
			_layout = layoutXML;
		}
		
		public function get layout():XML
		{
			return _layout;
		}
		
		public function onTraceChange () : void  {};
	}
}