package com.ithaca.timeline
{
    import com.ithaca.timeline.events.TimelineEvent;
    import flash.display.JointStyle;
    import flash.events.EventDispatcher;
    import flash.sampler.NewObjectSample;
    import mx.collections.ArrayCollection;
    /**
     * The TimeRange class manages time intervals, zoom and time holes.
     */
    public class TimeRange extends EventDispatcher
    {
        /**
         * The current time intervals ; the limits are stored as a list :( begin1, end1, begin2, end2, ...., beginn, endn)
         */
        public  var _ranges     : ArrayCollection;
        /**
         * The originals time intervals are saved here in order to restore them after making some holes and zoom.
         */
        private var _originalRanges     : ArrayCollection;
        /**
         * The begining of the range
         */
        private var _start        : Number;
        /**
         * The end of the range
         */
        private var _end        : Number;
        /**
         * The duration of the range
         */
        private var _duration     : Number;
        /**
         * true if a zoom is actived
         */
        private var _zoom        : Boolean  = false;
        /**
         * gap between two intervals (width of the time hole) ; must be used in each component that render time hole.
         */
        public  var    timeHoleWidth : Number = 10;

        public function TimeRange( ) : void
        {
            _ranges = new ArrayCollection();
            _originalRanges = new ArrayCollection();
        }

        /**
         * @return there'
         */
        public function isEmpty () : Boolean
        {
            return _ranges.length == 0;
        }

        /**
         * return the number of intervals (this the number of time holes + 1 )
         */
        public function get numIntervals()             : Number { return _ranges.length / 2; }
        /**
         * The begining of the range
         */
        public function get begin()                 : Number { return _start; }
        /**
         * The end of the range
         */
        public function get end()                     : Number { return _end; }
        /**
         * The  duration of the range without taking into account the time holes
         */
        public function get totalDuration()         : Number { return end - begin; }
        /**
         * The sum of duration of each intervals ( the time holes are taken into account )
         */
        public function get duration()                 : Number { return _duration; }

        private function addItem( value : Number, pos : Number = Infinity ) : void
        {
            if ( pos > _ranges.length - 1)
                _ranges.addItem( value );
            else
                _ranges.addItemAt( value, pos );
        }

        /**
         * Converts a time to a position for a given witdh of component
         * @param    timeValue  time in milliseconds
         * @param    width The width of the renderer component
         * @return the position in the renderer component
         */
        public function timeToPosition( timeValue : Number, width : Number ) : Number
        {
            var position : Number = 0;

        /*    if ( timeValue <= begin )
                position = 0;
            else if ( timeValue >= end )
                position = width;
            else */for ( var i : int = 1; i < _ranges.length; i ++ )
                if ( begin <= _ranges[i]  )
                {
                    var rangeStart : Number = Math.max( begin, _ranges[i - 1] );

                    if ( timeValue <= _ranges[i]  )
                    {
                        if ( i % 2 == 0)
                            position += timeHoleWidth;
                        else
                            position += ( timeValue - rangeStart ) * width / duration;
                        break;
                    }
                    else
                    {
                        var intervalWidth : Number = (i % 2 == 0) ? timeHoleWidth : ( _ranges[i] - rangeStart) * width / duration;
                        position +=  intervalWidth ;
                    }
                }
            return position;
        }

        /**
         * Converts the positon to a time for a given witdh of component
         * @param    positionValue the position in the renderer component
         * @param    width The width of the renderer component
         * @return  time in milliseconds
         */
        public function positionToTime( positionValue : Number, width : Number ) : Number
        {
            var time : Number = 0;
            var currentPostion: Number = 0;
            if ( positionValue <= 0 )
                time = begin;
            else if ( positionValue >= width )
                time = end;
            else for ( var i : int = 1; i < _ranges.length; i ++ )
                if ( begin <= _ranges[i]  )
                {
                    var rangeStart : Number = Math.max( begin, _ranges[i - 1] );
                    var intervalWidth : Number = (i % 2 == 0) ? timeHoleWidth : ( _ranges[i] - rangeStart) * width / duration;
                    if ( positionValue < currentPostion + intervalWidth )
                    {
                        time = rangeStart + ( positionValue - currentPostion )  * duration / width;
                        break;
                    }
                    else
                        currentPostion += intervalWidth;
                }

            return time;
        }

        private function updateDuration ( ) : void
        {
            _duration = 0;
            for ( var i : int = 0; i < _ranges.length; i += 2 )
                if ( _start <= _ranges[i + 1] && _end >= _ranges[i] )
                    _duration += Math.min(_ranges[i + 1], _end) - Math.max( _ranges[i], _start);
            if ( _duration == 0)
                trace("duration 0");
        }


        /**
         * Builds a new  list of time intervals with the current list and a new time interval
         * @param    beginValue begin of the new inteval
         * @param    endValue end of the new inteval
         * @param    fillHole if true the interval between the current list and the new interval is considered as valid and usable; otherwise this time hole is preseved
         */
        public function addTime ( beginValue : Number , endValue : Number,  fillHole : Boolean = true ) : void
        {
            var beginIndex     : Number      = _ranges.length;
            var endIndex     : Number     = _ranges.length;

            _originalRanges.addItem( { begin : beginValue, end : endValue } );

            for ( var i : int = 0; i < _ranges.length; i++ )
                if ( beginValue <= _ranges[i] )
                {
                    beginIndex = i;
                    break;
                }

            for ( var j : int  = i; j < _ranges.length; j++ )
                if ( endValue <= _ranges[j] )
                {
                    endIndex = j;
                    break;
                }

            if ( beginIndex == endIndex )
            {
                if ( beginIndex % 2 == 0 )
                {
                    if ( !fillHole || _ranges.length == 0)
                    {
                        addItem(endValue, endIndex);
                        addItem(beginValue, beginIndex);
                    }
                    else
                    {
                        if ( beginIndex == _ranges.length )
                            _ranges[ _ranges.length - 1 ] = endValue;
                        else
                            _ranges[ beginIndex ] = beginValue;
                    }
                }
                else
                    return; // the new interval is in another interval
            }
            else
            {
                if ( beginIndex % 2 == 0)
                    _ranges[ beginIndex++ ] = beginValue;

                if ( endIndex % 2 == 0)
                    _ranges[ --endIndex ] = endValue;

                for ( var toRemove : int = beginIndex; toRemove < endIndex; toRemove++ )
                    _ranges.removeItemAt(  beginIndex );
            }

            if ( !_zoom)
                resetLimits();

            updateDuration();

            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE, true ));
        }

        /**
         * Clones another TimeRange
         * @param    tr the TimeRange to clone
         */
        public function clone( tr : TimeRange ) : void
        {
            _ranges.removeAll();
            for each( var value : Number in tr._ranges )
                _ranges.addItem( value);
            _start     = tr._start;
            _end     = tr.end;
            _duration = tr.duration;
            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , true ));
        }

        /**
         * Makes a time hole between the startValue and endValue.
         * @param startValue lower limit of the time hole interval
         * @param endValue higher limit of the time hole interval
         */
        public function makeTimeHole (beginValue : Number , endValue : Number ) : void
        {
            var beginIndex     : Number      = _ranges.length;
            var endIndex     : Number     = _ranges.length;

            for ( var i : int = 0; i < _ranges.length; i++ )
                if ( beginValue <= _ranges[i] )
                {
                    beginIndex = i;
                    break;
                }

            for ( var j : int  = i; j < _ranges.length; j++ )
                if ( endValue <= _ranges[j] )
                {
                    endIndex = j;
                    break;
                }

            if ( beginIndex == endIndex )
            {
                if ( beginIndex % 2 != 0 && beginIndex <  _ranges.length)
                {
                    addItem(endValue, endIndex);
                    addItem(beginValue, beginIndex);
                }
                else
                    return; // the new interval is in another interval
            }
            else
            {
                if ( beginIndex % 2 != 0)
                    _ranges[ beginIndex++ ] = beginValue;

                if ( endIndex % 2 != 0)
                    _ranges[ --endIndex ] = endValue;

                for ( var toRemove : int = beginIndex; toRemove < endIndex; toRemove++ )
                    _ranges.removeItemAt(  beginIndex );
            }

            if ( !_zoom)
                resetLimits();

            updateDuration();

            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , true ));
        }

        /**
         * Changes the begin an the end of the time to consider, but the intervals stay the same.
         *
         * It is used to make a zoom.
         *
         * @param    begin
         * @param    end
         */
        public function changeLimits ( begin : Number , end : Number ) : void
        {
            _start = begin;
            _end = end;
            _zoom = true ;
            updateDuration();

            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , true ));
        }

        /**
         * Adds the same time value both to the begin and to the end of the TimeRange
         * @param delta time in milliseconds to add.
         */
        public function shiftLimits ( delta : Number ) : void
        {
            _start     += delta;
            _end     += delta;

            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_SHIFT , true ));
        }

        /**
         * Restores the begin and the end of time to consider from the intervals list ; in order to cancel a zoom for example.
         */
        public function resetLimits ( ) : void
        {
            _start     = _ranges[ 0 ];
            _end     = _ranges[ _ranges.length -1 ];
            _zoom    = false;
            updateDuration();

            dispatchEvent( new TimelineEvent( TimelineEvent.TIMERANGES_CHANGE , true ));
        }

        /**
         * Restores the intervals and  the begin / end of time to consider from the saved intervals list.
         *
         * It is used to cancel all zooms and time holes for example.
         *
         */
        public function reset ( ) : void
        {
            _ranges.removeAll();

            var ranges : ArrayCollection = _originalRanges;
            _originalRanges = new ArrayCollection();
            for (var i : uint = 0; i < ranges.length; i++ )
            {
                var interval : Object = ranges.getItemAt(i);
                addTime( interval.begin, interval.end );
            }

            resetLimits( );
        }
    }
}
