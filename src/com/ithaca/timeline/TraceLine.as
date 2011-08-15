package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import spark.components.SkinnableContainer;

	[Style(name="rendererHeight",type="Number",inherit="no")]	
	public class TraceLine  extends LayoutNode
	{	
		public var title 			: String;
		public var sourceStr 		: String;
		public var _selector 		: ISelector;
		public var _obsels 			: ArrayCollection = new ArrayCollection();
		public var rendererHeight	: Number;
		
		public function TraceLine( tl : Timeline, tlTitle : String = null, tlSelector : ISelector = null, tlSource : String = null, tlSkinClass : String = null )
		{
			_timeline = tl;
			titleComponent = new TraceLineTitle( this );
			title 	= tlTitle;
			this.id = title;
			_selector = tlSelector;
			sourceStr = tlSource;		
			styleName = tlSkinClass;
		}
		
		public function getCollectionSource() : ArrayCollection
		{
			switch ( sourceStr )
			{
				case "parent" :
				{
					if ( parentNode )
					{
						if ( parentNode is TraceLine)
							return ( parentNode as TraceLine )._obsels;					
						if ( parentNode is TraceLineGroup )
							return ( parentNode as TraceLineGroup )._trace.obsels;				
					}
					return null;			
				}
				default:
				{
					var tlg : TraceLineGroup = getTraceLineGroup();
					if (tlg && tlg._trace)
						return tlg._trace.obsels;
					else 
						return null;
				}
			}
		}
		
		public function acceptObsel ( obsel : Obsel ) : Boolean
		{
			return ( !_selector || _selector.isObselMatching( obsel as Obsel ) ); 
		}
		
		public function addObsel ( obsel : Obsel ) : void 
		{
			if ( acceptObsel( obsel ) )
				_obsels.addItem( obsel );
		}
		
		public function removeObsel ( obsel : Obsel ) : void 
		{
			var obselIndex : uint = _obsels.getItemIndex( obsel );
			if ( obselIndex >= 0)
				_obsels.removeItemAt( obselIndex );
		};
		
		override public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void
		{			
			_obsels.removeAll();
		
			if ( obselsCollection == null )
				obselsCollection = getCollectionSource();				
			if (obselsCollection != null && obselsCollection.length >0)
			{				
				for each( var obsel :  Obsel in obselsCollection)
					addObsel( obsel );			
			}
		}		
		
		override public function onSourceChange( event : CollectionEvent ) : void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each ( var obsel : Obsel in event.items )
						addObsel( obsel );
					break;
				}				
				case CollectionEventKind.REMOVE :
				{					
					for each ( var obsel : Obsel in event.items )
						removeObsel( obsel );
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