package com.ithaca.timeline 
{
	import com.ithaca.traces.Obsel;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * The SimpleObselRenderer class extends BaseOselsRender to render obsels with lines and rect (durrative obsel) in a Shape component. 
	 * <p>It's used to render the preview tracelines in the zoomContext zone.</p>
	 * <p>Using different colors is not supported yet.</p>	 
	 */
	public class SimpleObselsRenderer extends BaseObselsRenderer 
	{
		public	var _markerColor 		: uint = 0x000000;
		public	var _durativeColor 		: uint = 0xC9C9C9;
		public	var _backgroundColor	: uint = 0xF5F5F5;
		
		public function SimpleObselsRenderer( tr : TimeRange, tl : Timeline ) 
		{
			super( tr, null, tl);						
		}
		
		/**
		 * The only way to refresh the render in this class.
		 * @param	event
		 */
		override public function  redraw( event : Event = null) : void
		{	
			if ( !_timeRange) 
				return;	
			
			while(numChildren > 0 )
				removeChildAt(0);			
			
			var lastShapeInterval : Shape = null;
			
			for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
			{				
				if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
					continue;
				
				var intervalStart 		: Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
				var intervalEnd 		: Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
				var intervalDuration 	: Number = intervalEnd - intervalStart;
				var shapeWidth			: Number = intervalDuration * (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
				
				var shape : Shape = new Shape();
				// drawing interval background
				shape.graphics.beginFill(_backgroundColor);
				if (borderVisible)
					shape.graphics.lineStyle(1);
				shape.graphics.drawRect( 0, 0, shapeWidth, height);
				shape.graphics.endFill();
				
				//drawing obsels
				for each (var obsel : Obsel in _obsels)
				{	
					if ( obsel.end >= intervalStart  && obsel.begin <= intervalEnd )
					{
						// durative
						if (obsel.begin < obsel.end ) 
						{
							shape.graphics.beginFill(_durativeColor, 0.5);
							shape.graphics.lineStyle();
							var beginDurative : Number = Math.max( obsel.begin, intervalStart );
							var widthDurative : Number = Math.min( obsel.end,   intervalEnd ) - beginDurative;
							shape.graphics.drawRect( (beginDurative - intervalStart ) * shapeWidth / intervalDuration , 0, widthDurative * shapeWidth / intervalDuration, height);
							shape.graphics.endFill();
						} 
						// non durative
						else if (obsel.begin == obsel.end )
						{
							shape.graphics.lineStyle(0, _markerColor);	
							var x : Number = (obsel.begin - intervalStart) * shapeWidth / intervalDuration;
							shape.graphics.moveTo( x, 0 );
							shape.graphics.lineTo( x, height );
						}
					}
				}	
				
				if (lastShapeInterval)
					shape.x = lastShapeInterval.x + lastShapeInterval.width + _timeRange.timeHoleWidth;
				addChild( shape );
				lastShapeInterval = shape;
			}
		}
	}
}