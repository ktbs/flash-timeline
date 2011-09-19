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
			
			if ( obsel.hasOwnProperty(_splitter) )			
				selector = new SelectorRegexp( "^" + obsel[_splitter] +"$" , _splitter );
			else if ( obsel.props.hasOwnProperty(_splitter) )			
				selector = new SelectorRegexp( "^" + obsel.props[_splitter] +"$" , _splitter );
			else 
				return null
			
			return selector;
		}
		
		public function isSelectorAlreadyExist ( obsel : Obsel ) : ISelector
		{
			var selector : ISelector = createSelector ( obsel );
			
			if (selector && parentNode )
				for ( var brotherIndex : uint = 0; brotherIndex < parentNode.numElements; brotherIndex++ )		
				{
					var brother : LayoutNode = parentNode.getElementAt( brotherIndex ) as LayoutNode;
					if ( brother is TraceLine  && (brother as TraceLine).selector && (brother as TraceLine).selector.isEqual( selector) )
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
				var title : String;
				
				if ( obsel.hasOwnProperty(_splitter) )			
					title =  obsel[_splitter] ;
				else if ( obsel.props.hasOwnProperty(_splitter) )			
					title =  obsel.props[_splitter] ;
				
				newTree = new TraceLine( _timeline, title, selector , source );
				if (  source == "parent"  && parentNode is TraceLine)
				{
					(parentNode as TraceLine)._obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree as TraceLine).onSourceChange );
					(newTree as TraceLine ).resetObselCollection( (parentNode as TraceLine)._obsels );
				}
				else
				{
					trac.obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree as TraceLine).onSourceChange );
					(newTree as TraceLine ).resetObselCollection( trac.obsels );
				}
				
				newTree.styleName = styleName;
				
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