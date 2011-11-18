package com.ithaca.timeline
{
    import com.ithaca.timeline.events.TimelineEvent;
    import flash.events.Event;
    import mx.core.UIComponent;
    import mx.events.MoveEvent;
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.events.ElementExistenceEvent;

    [Style(name = "backgroundColor", type = "Number", format = "Color", inherit = "no")]
    /**
     * The ZoomContext class manages a movable and resizable cursor to control the time interval in which the obsels have to be displayed.
     */
    public class ZoomContext extends SkinnableContainer
    {
        [SkinPart(required = "true")]
        /**
         * This is the movable an resizable part of the zoomContext. Its position defines the begin of the cursorRange Property and its width defines the duration of this TimeRange.
         */
        public var cursor             : UIComponent;
        [Bindable]
        [SkinPart(required="true")]
        /**
         * This group contains a preview traceline for each TraceLineGroup of the Timeline ; the obsels in the _timelineRange are rendered.
         */
        public var timelinePreview    : Group;
        [Bindable]
        [SkinPart(required = "true")]
        /**
         * A ruler to display to the _timelineRange
         */
        public var inputTimeRuler    : TimeRuler;
        [Bindable]
        [SkinPart]
        /**
         * A ruler to display to the cursorRange
         */
        public var outputTimeRuler    : TimeRuler;
        /**
         * Reference to the TimeLine
         */
        public var _timeline        : Timeline;
        /**
         * The TimeRange of the Timeline ; it defines the minimum and maximum of the possible values of the cursorRange.
         */
        public var _timelineRange    : TimeRange;
        /**
         * The TimeRange defined by the position and the width of the 'cursor' component ; the obsels in this TimeRange are rendered in the main layout zone.
         */
        public var cursorRange        : TimeRange;

        public function ZoomContext() : void
        {
            super();
            enabled = false;
        }

        public function set timeline( value : Timeline ) : void
        {
            if ( _timeline == value)
                return;

            _timeline         = value;
            _timelineRange     = _timeline.range;
            cursorRange     = new TimeRange();

            timelinePreview.addEventListener( Event.RESIZE, updateSkinPositionFromValues );
            _timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, onTimelineTimesChange );
            _timelineRange.addEventListener( TimelineEvent.TIMERANGES_CHANGE, inputTimeRuler.onTimeRangeChange);
            _timeline.addEventListener( ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange);
            _timeline.addEventListener( ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);
            _timeline.addEventListener( TimelineEvent.LAYOUT_CHANGE, onTimelineLayoutChange );
            cursor.addEventListener( TimelineEvent.ZOOM_CONTEXT_MANUAL_CHANGE, onManualChange );
        }
        public function get timeline( ) : Timeline  { return  _timeline; }

        /**
         * update the position and the width of the cursor according to the cursorRange values
         * @param    e
         */
        public function updateSkinPositionFromValues( e: Event = null) : void
        {
            if ( cursor && _timeline && timelinePreview && !cursorRange.isEmpty())
            {
                cursor.x         = timelinePreview.x + _timelineRange.timeToPosition( cursorRange.begin, timelinePreview.width );
                cursor.width     = timelinePreview.x + _timelineRange.timeToPosition( cursorRange.end, timelinePreview.width ) - cursor.x ;
            }
        }
        /**
         * Set the cursor in the 'editable' or 'fixed' state according to the parameter value.
         * @param value if 'true' change the state of the cursor to 'editable', otherwise change it to 'fixed'
         */
        public function set cursorEditable( value : Boolean ) : void
        {
            if (value)
                cursor.setCurrentState('editable');
            else
                cursor.setCurrentState('fixed');
        }

        protected  function onManualChange(  e: Event = null ) : void
        {
            if ( timeline.contextFollowCursor && timeline.getStyle('cursorMode') == 'auto' )
                timeline.contextFollowCursor = false;
        }

        /**
         * update the cursorRange values according to the position and the width of the cursor
         * @param    e
         */
        public function updateValuesFromSkinPosition( e: Event = null ) : void
        {
            switch (e.type)
            {
                case MoveEvent.MOVE :
                    var oldPos     : Number     = _timelineRange.positionToTime( (e as MoveEvent).oldX - timelinePreview.x, timelinePreview.width );
                    var newPos     : Number     = _timelineRange.positionToTime( cursor.x - timelinePreview.x, timelinePreview.width );
                    cursorRange.shiftLimits( newPos - oldPos );
                break;
                default:
                    var begin     : Number     = _timelineRange.positionToTime( cursor.x  - timelinePreview.x, timelinePreview.width );
                    var end     : Number     = _timelineRange.positionToTime( cursor.x  + cursor.width  - timelinePreview.x, timelinePreview.width );
                    cursorRange.changeLimits(begin, end);
            }
        }

        /**
         * Add a traceline to the timelinePreview Group in order to make a preview of a given TraceLineGroup.
         * @param    tlg the TraceLineGroup to preview
         * @param    index the position of the preview (-1 to add it at the end)
         */
        public function addTraceLineGroupPreview( tlg : TraceLineGroup, index : Number  = -1  ) : void
        {
            var simpleObselsRenderer : SimpleObselsRenderer = new SimpleObselsRenderer( _timelineRange, _timeline );
            simpleObselsRenderer.borderVisible = false;
            // if there's no 'contextPreviewTraceLine', the whole trace would be the preview
            if ( tlg.contextPreviewTraceLine )
                simpleObselsRenderer.obselsCollection     = tlg.contextPreviewTraceLine._obsels;
            else
                simpleObselsRenderer.obselsCollection     = tlg.trace.obsels;

            _timeline.addEventListener( TimelineEvent.TIMERANGES_CHANGE, simpleObselsRenderer.onTimerangeChange );
            simpleObselsRenderer.percentWidth     = 100;

            simpleObselsRenderer.percentHeight     = 100;
            simpleObselsRenderer.maxHeight         = 6;
            simpleObselsRenderer.minHeight         = 2;
            simpleObselsRenderer._backgroundColor = ( tlg.getStyle("previewBgColor") == "auto" ||  tlg.getStyle("previewBgColor") == null) ? tlg.getStyle("bgColor") :  Number( tlg.getStyle("previewBgColor") );

            if (index < 0 )
                timelinePreview.addElement( simpleObselsRenderer );
            else
                timelinePreview.addElementAt(simpleObselsRenderer, index );
        }

        /**
         * Remove a TraceLine from the timelinePreview Group
         * @param    i index of the traceline to remove
         */
        public function removeTraceLineGroupPreviewAt( i : uint ) : void
        {
            timelinePreview.removeElementAt( i ) ;
        }

        /**
         * Update the content of the timelinePreview Group according to the TraceLineGroup of the Timeline
         * @param    event
         */
        public function onTracelineGroupsChange( event: ElementExistenceEvent ) : void
        {
            if ( event.type == ElementExistenceEvent.ELEMENT_ADD )
                addTraceLineGroupPreview( event.element as TraceLineGroup, event.index );
            else if ( event.type == ElementExistenceEvent.ELEMENT_REMOVE )
                removeTraceLineGroupPreviewAt( event.index );
        }

        private function onTimelineLayoutChange( e : Event ) : void
        {

        }
        /**
         * Handle modification of the TimeRange of the Timeline.
         * @param    e: the event
         */
        private function onTimelineTimesChange( e : TimelineEvent ) : void
        {
            _timelineRange = e.currentTarget as TimeRange;
            if ( _timeline.isRelativeTimeMode )
            {
                outputTimeRuler.timeOffset = inputTimeRuler.timeOffset = _timelineRange._ranges[0];
                outputTimeRuler.useLocaleTime = inputTimeRuler.useLocaleTime = false;
            }
            else
            {
                outputTimeRuler.timeOffset = inputTimeRuler.timeOffset = 0;
                outputTimeRuler.useLocaleTime = inputTimeRuler.useLocaleTime = true;
            }

            var begin : Number;
            var duration : Number;

            if ( cursorRange.isEmpty() )
            {
                enabled  = true;
                begin         = _timelineRange.begin;
                duration     = ( _timelineRange.end - _timelineRange.begin )*Stylesheet.ZoomContextInitPercentWidth / 100;
            }
            else
            {
                begin         = Math.max( cursorRange.begin, _timelineRange.begin );
                duration      = Math.min( cursorRange.end, _timelineRange.end ) - begin;
            }

            cursorRange.clone( _timelineRange );
            cursorRange.changeLimits(begin, begin + duration);
            updateSkinPositionFromValues();
        }

        /**
         * Reset the position and width of the cursor component to default value  ( and obviously the cursorRange interval )
         */
        public function reset( ) : void
        {
            var begin         : Number    = _timelineRange.begin;
            var duration     : Number     = ( _timelineRange.end - _timelineRange.begin )*Stylesheet.ZoomContextInitPercentWidth / 100;

            cursorRange.clone( _timelineRange );
            cursorRange.changeLimits(begin, begin + duration);
            updateSkinPositionFromValues();
        }

        /**
         * Change the limits of the cursorRange ( and obviously the position and width of the cursor )
         * @param    beginValue start of the new range in milliseconds
         * @param    endValue end of the new range in milliseconds
         */
        public function setRange( beginValue : Number, endValue : Number ) : void
        {
            cursorRange.changeLimits(beginValue, endValue);
            updateSkinPositionFromValues();
        }

        /**
         * Add a given number of milliseconds both to the begin and to the end of the cursorRange
         * @param    deltaTime ( can be a negative value )
         * @return
         */
        public function shiftContext( deltaTime : Number ) : Number
        {
            var delta: Number = 0;

            if (deltaTime > 0 )
                delta    =    Math.min(deltaTime, _timelineRange.end - cursorRange.end);
            else
                delta    =    Math.max(deltaTime, _timelineRange.begin - cursorRange.begin);

            if ( cursor && _timeline && timelinePreview && !cursorRange.isEmpty())
                cursor.x     = timelinePreview.x + _timelineRange.timeToPosition( cursorRange.begin + delta, timelinePreview.width );

            return delta;
        }
    }
}