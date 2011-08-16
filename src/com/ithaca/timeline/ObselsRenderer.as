package com.ithaca.timeline 
{
	import com.ithaca.traces.Obsel;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class ObselsRenderer extends BaseObselsRenderer 
	{
		protected var  obselsSkinsCollection : ArrayCollection;
		
		public function ObselsRenderer( tr : TimeRange, tl : TraceLine ) 
		{			
			super( tr, tl, tl._timeline);						
			obselsSkinsCollection = new ArrayCollection();	
		}
		
		override public function  redraw( event : Event = null) : void
		{						
			if ( !_timeRange) 
				return;	
			
			while(numChildren > 0 )
				removeChildAt(0);		

			var lastIntervalGroup : Canvas = null;
	 
			var  timeToPositionRatio : Number = (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
			
			for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
			{				
				if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
					continue;
					
				var intervalStart 		: Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
				var intervalEnd 		: Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
				var intervalDuration 	: Number = intervalEnd - intervalStart;		
				
				var intervalGroup : Canvas 	= new Canvas();
				intervalGroup.width 		= intervalDuration * timeToPositionRatio;
				intervalGroup.height 		= height;				
				intervalGroup.clipContent 	= true;
				intervalGroup.horizontalScrollPolicy = "off";					
				
				intervalGroup.graphics.lineStyle( 1 );
				intervalGroup.graphics.drawRect( 0, 0, intervalGroup.width, height);
				
				//drawing obsels
				for each (var obselSkin : ObselSkin in obselsSkinsCollection)
				{	
					var obsel : Obsel =  obselSkin.obsel;
					if ( obsel.end >= intervalStart  && obsel.begin <= intervalEnd )
					{
						obselSkin.x = Math.max( obsel.begin - intervalStart, 0 ) * timeToPositionRatio;
						intervalGroup.addElement( obselSkin ) ;
					}
				}	
				
				if ( lastIntervalGroup )
					intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
				addChild( intervalGroup );
				lastIntervalGroup = intervalGroup;
			}
		}		
		
		public function getObselSkinIndex( obsel : Obsel ) : int
		{			
			for ( var i: uint = 0; i < obselsSkinsCollection.length; i++ )
				if ((obselsSkinsCollection[i] as ObselSkin).obsel == obsel )
					return i;
			
			return -1;
		}
		
		override public function  onObselsCollectionChange( event : CollectionEvent ) : void
		{
			var obsel 		: Obsel;
			var obselSkin 	: ObselSkin;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each ( obsel in event.items )
					{
						obselSkin = _timeline.styleSheet.getParameteredSkin( obsel, _traceline) ;
						if (obselSkin)
							obselsSkinsCollection.addItem( obselSkin);
					}
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
					for each ( obsel in event.items )
					{					
						var obselIndex : int = getObselSkinIndex( obsel );
						if ( obselIndex >= 0)
							obselsSkinsCollection.removeItemAt( obselIndex );
					}				
					break;
				}
				case CollectionEventKind.REPLACE :
				break;
				
				case CollectionEventKind.RESET :
				{
					obselsSkinsCollection.removeAll();
					for each ( obsel in _obsels )
					{
						obselSkin = _timeline.styleSheet.getParameteredSkin( obsel, _traceline) ;
						if (obselSkin)
							obselsSkinsCollection.addItem( obselSkin);
					}
					break;
				}				
				default:
			}
		}	
	}
}