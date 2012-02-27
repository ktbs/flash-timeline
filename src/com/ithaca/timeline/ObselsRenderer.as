package com.ithaca.timeline
{
    import com.ithaca.traces.Obsel;
    import flash.events.Event;
    import mx.collections.ArrayCollection;
    import mx.containers.Canvas;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    import mx.events.ResizeEvent;
    import spark.components.Group;
    import com.ithaca.timeline.events.TimelineEvent;
    import com.ithaca.timeline.TimelineStyleApplicator;
    import com.flashartofwar.fcss.applicators.IApplicator;

    /**
     * The ObselsRenderer class extends BaseOselsRenderer to render obsels with skinned ObselsSkins.
     */
    public class ObselsRenderer extends BaseObselsRenderer
    {
        public var  obselsSkinsCollection: ArrayCollection;

        public function ObselsRenderer(tr: TimeRange, tl: TraceLine)
        {
            super(tr, tl, tl._timeline);
            obselsSkinsCollection = new ArrayCollection();
            clipAndEnableScrolling  = true;
        }

        private function  updateHorizontalScrollPosition(): void
        {
            var begin: Number
            for (var i: int = 0; i < _timeline.range._ranges.length; i++)
                if (_timeRange.begin <= _timeline.range._ranges[i])
            {
                begin = (i%2)? _timeRange.begin:_timeline.range._ranges[i];
                break;
            }
            horizontalScrollPosition = _timeline.range.timeToPosition(begin, width* _timeline.duration / _timeRange.duration);
        }

        private function  updateIntervalGroup(intervalGroup: Group, i:int ): void
        {
            if (_timeRange.duration > 0)
            {
                var intervalStart: Number = Math.max(_timeline.range._ranges[i], _timeline.begin);
                var intervalEnd: Number = Math.min(_timeline.range._ranges[i + 1], _timeline.end);

                intervalGroup.width = _timeline.range.timeToPosition(intervalEnd, width * _timeline.range.duration / _timeRange.duration)
                                  - _timeline.range.timeToPosition(intervalStart, width * _timeline.range.duration / _timeRange.duration);

                if (i < _timeline.range._ranges.length - 2)
                    intervalGroup.width += 1;

                if (borderVisible)
                {
                    intervalGroup.graphics.clear();
                    intervalGroup.graphics.lineStyle(1);
                    intervalGroup.graphics.drawRect(0, 0, intervalGroup.width-1, height -1);
                }
                else
                    intervalGroup.graphics.clear();
            }
        }

        /**
         * Full redraw of the obsels renderer.
         * @param    event
         */
        override public function redraw(event: Event = null): void
        {
            if (!_timeRange || !_timeRange.duration)
                return;

            while(numElements > 0)
                removeElementAt(0);

            updateHorizontalScrollPosition();

            var lastIntervalGroup: Group  = null;
            for (var i:int = 0; i < _timeline.range._ranges.length; i+=2)
            {
                var intervalStart: Number = Math.max(_timeline.range._ranges[i], _timeline.begin);
                var intervalEnd: Number = Math.min(_timeline.range._ranges[i + 1], _timeline.end);
                var intervalDuration: Number = intervalEnd - intervalStart;

                var intervalGroup: Group = new Group();
                intervalGroup.height = height;
                intervalGroup.clipAndEnableScrolling    = true;

                updateIntervalGroup(intervalGroup, i);

                if (lastIntervalGroup)
                    intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth -1;
                lastIntervalGroup = intervalGroup;

                //drawing obsels
                for each (var obselSkin: ObselSkin in obselsSkinsCollection)
                {
                    var obsel: Obsel =  obselSkin.obsel;

                    if ((obsel.end > _timeRange._ranges[i]) && (obsel.begin < _timeRange._ranges[i+1]))
                    {
                        obselSkin.x =  _timeline.range.timeToPosition(obsel.begin, width * _timeline.duration / _timeRange.duration) - intervalGroup.x;
                        intervalGroup.addElement(obselSkin);
                    }
                }

                addElement(intervalGroup);

            }
        }

        /**
         * This redraw function is used when the same set of obsels is visible but their positions have changed.
         *
         * It happens when the window is resized for example.
         *
         * @param    event
         */
        public function  updateObselPosition(event: Event = null): void
        {
            if (_timeline.range.numIntervals != numChildren)
            {
                redraw();
                return;
            }

            updateHorizontalScrollPosition();

            var lastIntervalGroup: Group = null;
            var indexIG: Number = 0;
            for (var i:int = 0; i < _timeline.range._ranges.length; i+=2)
            {
                var intervalStart: Number = Math.max(_timeline.range._ranges[i], _timeline.begin);
                var intervalEnd: Number = Math.min(_timeline.range._ranges[i + 1], _timeline.end);
                var intervalDuration: Number = intervalEnd - intervalStart;

                var intervalGroup: Group     = getChildAt(indexIG++) as Group;
                updateIntervalGroup(intervalGroup, i);
                if (lastIntervalGroup)
                    intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
                lastIntervalGroup = intervalGroup;

                for (var obselSkinIndex: int = 0; obselSkinIndex < intervalGroup.numElements;obselSkinIndex++)
                {
                    var obselSkin: ObselSkin = intervalGroup.getElementAt(obselSkinIndex) as ObselSkin;
                    obselSkin.x =  _timeline.range.timeToPosition(obselSkin.obsel.begin, width* _timeline.duration / _timeRange.duration) - intervalGroup.x;
                }
            }
        }

        /**
         * Function called when the ObselRenderer is resized.
         */
        override public function  onResize(event: ResizeEvent): void
        {
            redraw();
        }

        /**
         * Switch between different redraw functions.
         * @param    event
         */
        override public function onTimerangeChange(event: TimelineEvent): void
        {
            _timeRange = event.currentTarget as TimeRange;

            if (numElements > 0)
            {
                if (event.type == TimelineEvent.TIMERANGES_SHIFT)
                    updateViewportPosition();
                else if (_timeline.range.numIntervals <= numElements)
                    updateObselPosition();
                else
                    redraw();
            }
            else
                redraw();
        }

        /**
         * This redraw function is used when the time range has shifted.
         *
         * These are the same obsels at the same position (no resizing
         * of the renderer) but the position of the viewport must
         * change.
         *
         * It happens when the current time change.
         * @param    event
         */
        public function updateViewportPosition(event: Event = null): void
        {
            if (!_timeRange)
                return;
            updateHorizontalScrollPosition();
        }

        /**
         * @param    obsel An Obsel
         * @return the index in <code>obselsSkinsCollection</code> of the ObselSkin that represents <code>obsel</code>. Return -1 if the obsel is not found.
         */
        public function getObselSkinIndex(obsel: Obsel): int
        {
            for (var i: uint = 0; i < obselsSkinsCollection.length; i++)
                if ((obselsSkinsCollection[i] as ObselSkin).obsel == obsel)
                    return i;

            return -1;
        }

        /**
         * Manage the <code>obselsSkinsCollection</code> when the <code>_obsels</code> ArrayCollection change.
         * This function is called when a CollectionEvent.COLLECTION_CHANGE is dispatched by <code>_obsels</code>.
         */
        override public function  onObselsCollectionChange(event: CollectionEvent): void
        {
            var obsel: Obsel;
            var obselSkin: ObselSkin;
            var obselIndex: int;
            var applicator: IApplicator = new TimelineStyleApplicator();

            switch (event.kind)
            {
                case CollectionEventKind.ADD:
                {
                    obselsSkinsCollection.disableAutoUpdate();
                    for each (obsel in event.items)
                    {
                        obselSkin = _timeline.styleSheet.getParameteredSkin(obsel, _traceline);
                        if (obselSkin)
                        {
                            obselsSkinsCollection.addItem(obselSkin);
                            // Apply dynamic CSS:
                            applicator.applyStyle(obselSkin,
                                                  _timeline.cssStyleSheetCollection.getStyle("Obsel",
                                                                                             obsel.type,
                                                                                             _traceline.name + ".Obsels"));
                        }
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }
                case CollectionEventKind.REMOVE:
                {
                    obselsSkinsCollection.disableAutoUpdate();
                    for each (obsel in event.items)
                    {
                        obselIndex  = getObselSkinIndex(obsel);
                        if (obselIndex >= 0)
                            obselsSkinsCollection.removeItemAt(obselIndex);
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }
                case CollectionEventKind.REPLACE:
                break;

                case CollectionEventKind.RESET:
                {
                    obselsSkinsCollection.removeAll();
                    obselsSkinsCollection.disableAutoUpdate();
                    for each (obsel in _obsels)
                    {
                        obselSkin = _timeline.styleSheet.getParameteredSkin(obsel, _traceline);
                        if (obselSkin)
                        {
                            obselsSkinsCollection.addItem(obselSkin);
                            // Apply dynamic CSS:
                            applicator.applyStyle(obselSkin,
                                                  _timeline.cssStyleSheetCollection.getStyle("Obsel",
                                                                                             obsel.type,
                                                                                             _traceline.name + ".Obsels"));
                        }
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }

                case CollectionEventKind.UPDATE:
                {
                    for each (var propChange: PropertyChangeEvent in event.items)
                    {
                        obsel = propChange.source as Obsel;
                        obselIndex  = getObselSkinIndex(obsel);
                        if (obselIndex >= 0)
                            (obselsSkinsCollection.getItemAt(obselIndex) as ObselSkin).invalidateDisplayList();
                    }
                    break;
                }
                default:
            }

        }
    }
}
