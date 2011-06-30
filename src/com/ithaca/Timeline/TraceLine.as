package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	
	import flash.text.StaticText;
	
	import mx.collections.ArrayCollection;

	public class TraceLine implements ILayoutNode
	{
		// tmp Debug
		static public var 	traceLineTmp : ArrayCollection = new ArrayCollection(); //temporaire pour debug
		public static var index : Number = 0;
		public var uid : Number;
		//
		
		public var title : String;
		public var _selector : ISelector;
		public var _splitter : String = "";
		
		private var _children : ArrayCollection = new ArrayCollection();
		public var _obsels 	: ArrayCollection = new ArrayCollection();	
		
		private var _layout : XML;
		
		public function TraceLine()
		{		
			uid = index;
			traceLineTmp.addItemAt( this , index++ );
		}
		
		public function acceptObsel ( obsel : Obsel ) : Boolean
		{
			return ( !_selector || _selector.isObselValid( obsel ) ); 
		}
		
		public function splitBy():String
		{
			if (_splitter != "")
				return _splitter;
			
			return null;
		}
		
		public function get children ( ) : ArrayCollection
		{
			return _children;
		}
		
		public function set layout(layoutXML:XML):void
		{
			_layout = layoutXML;
		}
		
		public function get layout():XML
		{
			return _layout;
		}
		
		public function addObsel ( obsel : Obsel ) : void 
		{
			_obsels.addItem( obsel );
		}
		
		public function removeObsel ( obsel : Obsel ) : void {};
	}
}