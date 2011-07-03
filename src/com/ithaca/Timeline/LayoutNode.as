package com.ithaca.Timeline
{
	
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;
	
	public class LayoutNode
	{
		public var _splitter 	: String = null ;
		private var _parent		: LayoutNode ;
		private var _children 	: ArrayCollection = new ArrayCollection() ;
		private var _layout 	: XML ;
		public var value		: Object ; 
		public var filter		: Boolean = false;
		
		public function LayoutNode( p : LayoutNode = null)
		{
			parent = p ;
		}
		
		public function get parent() : LayoutNode { return _parent; }
		public function set parent(value:LayoutNode): void { _parent = value; }
		public function get children ( ) : ArrayCollection { return _children; }		
		public function set layout ( layoutXML : XML ) : void { _layout = layoutXML; }
		public function get layout ( ) : XML	{ return _layout;	} 

		public function addChild ( child : LayoutNode ) : void { child.parent = this; _children.addItem( child ); }
		public function splitBy ( ) : String 	{ return _splitter; }
	}
}