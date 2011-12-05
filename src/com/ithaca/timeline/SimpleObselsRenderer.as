package com.ithaca.timeline
{
    import com.ithaca.traces.Obsel;
    import flash.display.Shape;
    import flash.events.Event;
	import spark.components.Group;

    /**
     * The SimpleObselRenderer class extends BaseOselsRenderer to render obsels with lines and rect (durative obsel) in a Shape component.
     * <p>It is used to render the preview tracelines in the zoomContext zone.</p>
     * <p>Using different colors for obsels is not supported yet.</p>
     */
    public class SimpleObselsRenderer extends BaseObselsRenderer
    {
        public    var _markerColor         : uint = 0x000000;
        public    var _durativeColor         : uint = 0xC9C9C9;
        public    var _backgroundColor    : uint = 0xF5F5F5;

        public function SimpleObselsRenderer( tr : TimeRange, tl : Timeline )
        {
            super( tr, null, tl);
        }

        /**
         * The only way to refresh the render in this class.
         * @param    event
         */
        override public function  redraw( event : Event = null) : void
        {
            if ( !_timeRange)
                return;

			while(numElements > 0 )
				removeElementAt(0);

			var lastShapeInterval : Group = null;

            for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
            {
                if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
                    continue;

                var intervalStart         : Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
                var intervalEnd         : Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
                var intervalDuration     : Number = intervalEnd - intervalStart;
				var shapeStart			: Number = _timeRange.timeToPosition( intervalStart, width );
				var shapeEnd			: Number = _timeRange.timeToPosition( intervalEnd, width );

				var shape : Group = new Group();
                // drawing interval background
                shape.graphics.beginFill(_backgroundColor);
                if (borderVisible)
                    shape.graphics.lineStyle(1);
				shape.width = shapeEnd - shapeStart;
				shape.graphics.drawRect( 0, 0, shape.width, height);
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
							shape.graphics.drawRect( (beginDurative - intervalStart ) * shape.width / intervalDuration , 0, widthDurative * shape.width / intervalDuration, height);
                            shape.graphics.endFill();
                        }
                        // non durative
                        else if (obsel.begin == obsel.end )
                        {
                            shape.graphics.lineStyle(0, _markerColor);
							var x : Number = _timeRange.timeToPosition( obsel.begin, width) - shapeStart;
                            shape.graphics.moveTo( x, 0 );
                            shape.graphics.lineTo( x, height );
                        }
                    }
                }

                if (lastShapeInterval)
                    shape.x = lastShapeInterval.x + lastShapeInterval.width + _timeRange.timeHoleWidth;

				addElement( shape );
                lastShapeInterval = shape;
            }
        }
    }
}