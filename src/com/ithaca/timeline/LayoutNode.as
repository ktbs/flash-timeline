package com.ithaca.timeline
{
	import mx.collections.ArrayCollection;
	import spark.components.SkinnableContainer;
	
	public class LayoutNode
	{
		private var _value		: Object ; 
		
		private var _parent		: LayoutNode ;
		private var _children 	: ArrayCollection = new ArrayCollection() ;
		private var _layout 	: XML ;		
		
		public function LayoutNode( p : LayoutNode = null)
		{
			parent = p ;
		}
		
		public function get value() : Object { return _value; }
		public function set value(val:Object): void 
		{ 
			_value = val; 
			if (_value.hasOwnProperty("node") )
				_value.node = this;			
		}
		
		public function get parent() : LayoutNode { return _parent; }
		public function set parent(value:LayoutNode): void { _parent = value; }
		public function get children ( ) : ArrayCollection { return _children; }		
		public function set layout ( layoutXML : XML ) : void { _layout = layoutXML; }
		public function get layout ( ) : XML	{ return _layout;	} 

		public function addChild ( child : LayoutNode, index : int = -1 ) : void 
		{ 
			child.parent = this; 
			if (index < 0 )			
				_children.addItem( child ); 			
			else 			
				_children.addItemAt( child , index );			
				
			if ( child.value && ( child.value is TraceLine || child.value is TraceLineGroup) )
				(value as SkinnableContainer).addElement( child.value as SkinnableContainer);
		}
		
		
		public function getTraceLineGroup() : TraceLineGroup
		{
			var nodeCursor : LayoutNode = this;
			
			while ( nodeCursor && !(nodeCursor.value is TraceLineGroup) )
				nodeCursor = nodeCursor.parent;
			
			if (nodeCursor)			
				return (nodeCursor.value as TraceLineGroup);
			else
				return null;
		}
	}
}