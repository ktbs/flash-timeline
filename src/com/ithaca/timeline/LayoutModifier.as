package  com.ithaca.timeline
{
	public class LayoutModifier  
	{
		import com.ithaca.traces.Obsel;
		import com.ithaca.traces.Trace;
		import mx.collections.ArrayCollection;
		import mx.collections.errors.CollectionViewError;
		import mx.events.CollectionEvent;
		import mx.events.CollectionEventKind;
		
		public var _splitter 	: String = null ;		
		public var node 		: LayoutNode = null;
		public var source		: String;
		
		public function LayoutModifier( ) 
		{
			
		}
		
		public function splitBy ( ) : String 	{ return _splitter; }
		
		
		
		private function createSelector (obsel : Obsel) : ISelector
		{
			var selector : ISelector;
			
			selector = new SelectorRegexp( "^" + obsel[_splitter] +"$" , _splitter );
			
			return selector;
		}
		
		public function isSelectorAlreadyExist ( obsel : Obsel ) : ISelector
		{
			var selector : ISelector = createSelector ( obsel );
			
			if (selector && node.parent )
				for each ( var brother : LayoutNode in node.parent.children )				
					if ( brother.value is TraceLine  && (brother.value as TraceLine)._selector && (brother.value as TraceLine)._selector.isEqual( selector) )
						return null;
			
			return selector;
		}
		
		public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void
		{			
			for each ( var item : Obsel in obselsCollection)
				newObsel( item );
		}		
		
		private function newObsel( obsel : Obsel ) : void
		{
			var selector : ISelector = isSelectorAlreadyExist ( obsel )
			if ( selector )
			{											
				var trac : Trace = obsel.trace ;
				var newTree : LayoutNode = Layout.createTree( node.layout, trac );
				newTree.value = new TraceLine( obsel[_splitter], selector , source );
				if (  source == "parent" )
					node.parent.value;
				else
				{
					trac.obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree.value as TraceLine).onSourceChange );
					(newTree.value as TraceLine ).resetObselCollection( trac.obsels );
				}
				
				node.parent.addChild(newTree);
			}
		}
		
		public function onSourceChange( event : CollectionEvent ) : void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{
					for each ( var item : Obsel in event.items)
						newObsel( item );
					
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
					break;
				}
				case CollectionEventKind.REPLACE :
				break;
				case CollectionEventKind.RESET :					
				break;				
			}
		}
	}

}