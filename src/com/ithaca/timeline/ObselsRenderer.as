package com.ithaca.timeline 
{
	import com.ithaca.traces.Obsel;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.graphics.Stroke;
	import spark.components.BorderContainer;
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
	 
			for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
			{				
				if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
					continue;
				
				var intervalStart 		: Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
				var intervalEnd 		: Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
				var intervalDuration 	: Number = intervalEnd - intervalStart;
				var shapeWidth			: Number = intervalDuration * (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
				
				var intervalGroup : Canvas 	= new Canvas();
				intervalGroup.width 		= shapeWidth;
				intervalGroup.height 		= height;				
				intervalGroup.clipContent 	= true;
				intervalGroup.horizontalScrollPolicy = "off";
				intervalGroup.opaqueBackground = 0xFFFFFF;
				
				//drawing obsels
				for each (var obselSkin :ObselSkin in obselsSkinsCollection)
				{	
					var obsel :Obsel =  obselSkin.obsel;
					if ( obsel.end >= intervalStart  && obsel.begin <= intervalEnd )
					{
						var x : Number = Math.max(obsel.begin - intervalStart,0) * shapeWidth / intervalDuration;
						obselSkin.x = x;		
						intervalGroup.addElement( obselSkin ) ;
					}
				}	
				
				if ( lastIntervalGroup )
					intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
				addChild( intervalGroup );
				lastIntervalGroup = intervalGroup;
			}
				trace ( toto++ );
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
		}
		
		override public function  onObselsCollectionChange( event : CollectionEvent ) : void
		{
			var obsel : Obsel;
			var obselSkin : ObselSkin;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD :
				{				
					for each (  obsel  in event.items )
					{
						obselSkin = _timeline.styleSheet.getParameteredSkin( obsel, _traceline) ;
						if (obselSkin)
							obselsSkinsCollection.addItem( obselSkin);
					}
					break;
				}				
				case CollectionEventKind.REMOVE :
				{
				
					break;
				}
				case CollectionEventKind.REPLACE :
				break;
				
				case CollectionEventKind.RESET :
				{
					obselsSkinsCollection.removeAll();
					for each (  obsel  in _obsels )
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