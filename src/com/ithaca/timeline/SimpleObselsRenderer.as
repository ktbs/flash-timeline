package com.ithaca.timeline 
{
	import com.ithaca.timeline.events.TimelineEvent;
	import com.ithaca.traces.Obsel;
	import flash.display.ShaderParameter;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	import mx.formatters.NumberBaseRoundType;
	
	public class SimpleObselsRenderer extends UIComponent 
	{
		public	var _markerColor 		: uint = 0x000000;
		public	var _durativeColor 		: uint = 0xC9C9C9;
		public	var _backgroundColor	: uint = 0xFFFFFF;
		
		private var _sprite 			: Sprite = new Sprite();
		private	var _timeRange			: TimeRange = null;
		private var _obsels 			: ArrayCollection = null;	
		
		public function SimpleObselsRenderer( tr : TimeRange ) 
		{
			super();						
			addChild( _sprite );
			_timeRange = tr;
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
			var i : int;		
			for (i = 0; i < _sprite.numChildren; i++)
				_sprite.removeChildAt(0);		
			
			var lastShapeInterval : Shape = null;
	 
			for (i = 0; i < _timeRange._ranges.length; i+=2)
			{				
				if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
					continue;
				
				var intervalStart 		: Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
				var intervalEnd 		: Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
				var intervalDuration 	: Number = intervalEnd - intervalStart;
				var shapeWidth			: Number = intervalDuration * width / _timeRange.duration;
				
				var shape : Shape = new Shape();
				// drawing interval background
				shape.graphics.beginFill(_backgroundColor);
				shape.graphics.lineStyle(0, 0x00FF00);
				shape.graphics.drawRect( 0, 0, shapeWidth, height);
				shape.graphics.endFill();
				
				//drawing obsels
				for each (var durativeObsel :Obsel in _obsels)
				{	
					if ( durativeObsel.end >= intervalStart  && durativeObsel.begin <= intervalEnd )
					{
						// durative
						if (durativeObsel.begin < durativeObsel.end ) 
						{
							shape.graphics.beginFill(_durativeColor, 0.5);
							shape.graphics.lineStyle();
							var beginDurative : Number = Math.max( durativeObsel.begin, intervalStart );
							var widthDurative : Number = Math.min( durativeObsel.end,   intervalEnd ) - beginDurative;
							shape.graphics.drawRect( (beginDurative - intervalStart ) * shapeWidth / intervalDuration , 0, widthDurative * shapeWidth / intervalDuration, height);
							shape.graphics.endFill();
						} 
						// non durative
						else if (durativeObsel.begin == durativeObsel.end )
						{
							shape.graphics.lineStyle(0, _markerColor);	
							var x : Number = (durativeObsel.begin - intervalStart) * shapeWidth / intervalDuration;
							shape.graphics.moveTo( x, 0 );
							shape.graphics.lineTo( x, height );
						}
					}
				}	
				
				if (lastShapeInterval)
					shape.x = lastShapeInterval.x + lastShapeInterval.width + _timeRange.timeHoleWidth;
				_sprite.addChild( shape );
				lastShapeInterval = shape;
			}
				
		}
	}

}