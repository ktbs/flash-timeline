package com.ithaca.timeline 
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Obsel;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.Stroke;
	import spark.components.BorderContainer;
	
	public class ObselsRenderer extends UIComponent 
	{
		private	var _timeRange			: TimeRange = null;
		private var _obsels 			: ArrayCollection = null;
		private var _timeline			: Timeline;
		
		public function ObselsRenderer( tr : TimeRange, tl : Timeline ) 
		{
			super();						
			_timeRange = tr;
			_timeline  = tl;
			addEventListener( ResizeEvent.RESIZE, redraw );
		}
		
		public function set obselsCollection( obsels : ArrayCollection ) : void
		{			
			if ( _obsels)
				_obsels.removeEventListener(CollectionEvent.COLLECTION_CHANGE, redraw);
			_obsels = obsels;
			
			redraw();
			_obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE, redraw);
		}
				
		public function  onTimerangeChange( event : TimelineEvent ) : void
		{
			_timeRange = event.value as TimeRange;
			redraw();
		}
		
		public function  redraw( event : Event = null) : void
		{						
			while(numChildren > 0 )
				removeChildAt(0);		

			var lastIntervalGroup : BorderContainer = null;
	 
			for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
			{				
				if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
					continue;
				
				var intervalStart 		: Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
				var intervalEnd 		: Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
				var intervalDuration 	: Number = intervalEnd - intervalStart;
				var shapeWidth			: Number = intervalDuration * (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
				
				var intervalGroup : BorderContainer = new BorderContainer();
				intervalGroup.width 		= shapeWidth;
				intervalGroup.height 		= height;
				intervalGroup.borderStroke 	= new Stroke( 0xE296EB, 1);
				
				//drawing obsels
				for each (var obsel :Obsel in _obsels)
				{	
					if ( obsel.end >= intervalStart  && obsel.begin <= intervalEnd )
					{
						var obselSkin : ObselSkin = _timeline.styleSheet.getParameteredSkin( obsel, null);
						if ( obselSkin )
						{
							var x : Number = (obsel.begin - intervalStart) * shapeWidth / intervalDuration;
							obselSkin.x = x;
							obselSkin.y = 10;
							intervalGroup.addElement( obselSkin ) ;
						}
					}
				}	
				
				if ( lastIntervalGroup )
					intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
				addChild( intervalGroup );
				lastIntervalGroup = intervalGroup;
			}
				
		}
	}

}