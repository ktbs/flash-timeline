package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	
	import flash.sampler.NewObjectSample;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.Tree;
	import mx.states.AddChild;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	public class Timeline implements ILayoutNode
	{
		private var _styleSheet 		: Stylesheet;
		public var _Timelinelayout		: Layout;
		public var 	_traceLineGroupArray : ArrayCollection = new ArrayCollection();
		
		public function Timeline()
		{
			super();
			_Timelinelayout = new Layout( this) ;
		}
		
		public function get styleSheet() : Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
		
		public function addTrace( pTrace : Trace ) : void {};
		public function removeTrace( pTrace : Trace ) : void {};
		
		
		public function acceptObsel(obsel:Obsel):Boolean
		{
			return true;
		}
		
		public function splitBy():String
		{
			return "traceUri";
		}
		
		public function get children ( ) : ArrayCollection
		{
			return _traceLineGroupArray;
		}
		
		public function set layout(layoutXML:XML):void
		{
			_Timelinelayout.layoutTree = layoutXML;
		}
		
		public function get layout():XML
		{
			return _Timelinelayout.layoutTree;
		}
		
		
	}
}