package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import mx.collections.ArrayCollection;
	import flash.events.Event;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	public class TraceLine
	{
		// tmp Debug
		static public var 	traceLineTmp : ArrayCollection = new ArrayCollection(); //temporaire pour debug
		public static var index : Number = 0;
		public var uid : Number;
		
		public var title 		: String;
		public var sourceStr 	: String;
		public var _selector 	: ISelector;
		public var _obsels 		: ArrayCollection = new ArrayCollection();
		public var node 		: LayoutNode = null;
		public var source		: String;
		
		public function TraceLine( tlTitle : String = null, tlSelector : ISelector = null, tlSource : String = null )
		{
			uid = index;
			traceLineTmp.addItemAt( this , index++ );
			
			title = tlTitle;
			_selector = tlSelector;
			sourceStr = tlSource;			
		}
		
		public function getCollectionSource() : ArrayCollection
		{
			switch ( sourceStr )
			{
				case "parent" :
				{
					if ( node.parent )
					{
						if (node.parent.value is TraceLine)
							return ( node.parent.value as TraceLine )._obsels;					
						if ( node.parent.value is TraceLineGroup )
							return ( node.parent.value as TraceLineGroup )._trace.obsels;				
					}
					return null;			
				}
				default:
				{
					var tlg : TraceLineGroup = node.getTraceLineGroup();
					if (tlg && tlg._trace)
						return tlg._trace.obsels;
					else 
						return null;
				}
			}
		}
		
		public function acceptObsel ( obsel : Obsel ) : Boolean
		{
			return ( !_selector || _selector.isObselMatching( obsel ) ); 
		}
		
		public function addObsel ( obsel : Obsel ) : void 
		{
			_obsels.addItem( obsel );
		}
		
		public function removeObsel ( obsel : Obsel ) : void 
		{
			
		};
		
		public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void
		{
			_obsels.removeAll();
			if (obselsCollection == null)
				obselsCollection = getCollectionSource();
				
			if (obselsCollection)
				for each (var item  : Obsel in obselsCollection)
					if (acceptObsel( item ) )
						addObsel (item );					
		}		
		
		public function onSourceChange( event : CollectionEvent ) : void
		{
			var item : Obsel;
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{
					for each (  item  in event.items)				
						if (acceptObsel( item ) )
							addObsel (item );
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
					for each ( item  in event.items)
						removeObsel (item );
					break;
				}
				case CollectionEventKind.REPLACE :
				break;
				case CollectionEventKind.RESET :
					resetObselCollection();
				break;				
			}
		}
	}
}