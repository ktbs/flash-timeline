package  com.ithaca.timeline
{
	public class LayoutModifier extends LayoutNode
	{
		import com.ithaca.traces.Obsel;
		import com.ithaca.traces.Trace;
		import mx.collections.ArrayCollection;
		import mx.collections.errors.CollectionViewError;
		import mx.events.CollectionEvent;
		import mx.events.CollectionEventKind;
		
		public var _splitter 	: String = null ;		
		public var source		: String;
		
		public function LayoutModifier( tl : Timeline ) 
		{
			_timeline = tl;
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
			
			if (selector && parentNode )
				for ( var brotherIndex : uint = 0; brotherIndex < parentNode.numElements; brotherIndex++ )		
				{
					var brother : LayoutNode = parentNode.getElementAt( brotherIndex ) as LayoutNode;
					if ( brother is TraceLine  && (brother as TraceLine)._selector && (brother as TraceLine)._selector.isEqual( selector) )
						return null;
				}
			
			return selector;
		}
		
		override public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void
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
				var newTree : LayoutNode = _timeline.timelineLayout.createTree( layoutXML, trac );
				newTree = new TraceLine( _timeline, obsel[_splitter], selector , source );
				if (  source == "parent" )
					parentNode;
				else
				{
					trac.obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree as TraceLine).onSourceChange );
					(newTree as TraceLine ).resetObselCollection( trac.obsels );
				}
				
				parentNode.addChildAndTitle(newTree);
			}
		}
		
		override public function onSourceChange( event : CollectionEvent ) : void
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
				
				default:
			}
		}
	}

}