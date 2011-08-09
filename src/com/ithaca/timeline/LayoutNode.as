package com.ithaca.timeline
{
	import mx.collections.ArrayCollection;
	import spark.components.SkinnableContainer;
	import mx.events.CollectionEvent;
	
	public class LayoutNode extends SkinnableContainer
	{
		private var _layout 		: XML ;	
		public  var titleComponent 	: SkinnableContainer;	
		public  var _timeline		: Timeline;
		public  var parentNode		: LayoutNode;
		
		public function set layoutXML ( value : XML ) : void { _layout = value; }
		public function get layoutXML ( ) : XML	{ return _layout;	} 

		public function addChildAndTitle ( child : LayoutNode, index : int = -1 ) : void 
		{ 	
			child.parentNode = this;
			if ( !(child is LayoutModifier))
			{
				
				child.percentWidth = 100;				
				addElement( child );	
				
				child.titleComponent.percentWidth = 100;
				if ( this is Timeline)
					(this as Timeline).titleGroup.addElement( child.titleComponent );
				else
				titleComponent.addElement( child.titleComponent );
			}
		}
		
		public function getTraceLineGroup() : TraceLineGroup
		{
			var nodeCursor : LayoutNode = this;
			
			while ( nodeCursor && !(nodeCursor is TraceLineGroup) )
				nodeCursor = nodeCursor.parentNode;
			
			if (nodeCursor)			
				return (nodeCursor as TraceLineGroup);
			else
				return null;
		}
		
		public function removeChildAndTitle( child : LayoutNode ) : void
		{
			removeElement( child  );
			titleComponent.removeElement( child.titleComponent );			
		}	
		
		public function onSourceChange( event : CollectionEvent ) : void { };
		public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void { };
	}
}