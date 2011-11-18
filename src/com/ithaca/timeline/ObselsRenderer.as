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
    
    
    /**
     * The ObselsRenderer class extends BaseOselsRenderer to render obsels with skinned ObselsSkins.
     */
    public class ObselsRenderer extends BaseObselsRenderer
    {
        protected var  obselsSkinsCollection : ArrayCollection;

        public function ObselsRenderer( tr : TimeRange, tl : TraceLine )
        {            
            super( tr, tl, tl._timeline);                        
            obselsSkinsCollection = new ArrayCollection();    
        }
        /**
         * Full redraw of the obsels renderer.
         * @param    event
         */
        override public function  redraw( event : Event = null) : void
        {                        
            if ( !_timeRange)
                return;    

            while(numChildren > 0 )
                removeChildAt(0);        

            var lastIntervalGroup : Group = null;
    
            var  timeToPositionRatio : Number = (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
            
            for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
            {                
                if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
                    continue;
                    
                var intervalStart         : Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
                var intervalEnd         : Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
                var intervalDuration     : Number = intervalEnd - intervalStart;        
                
                var intervalGroup : Group     = new Group();
                intervalGroup.width         = intervalDuration * timeToPositionRatio;
                intervalGroup.height         = height;            
                intervalGroup.clipAndEnableScrolling     = true;
                intervalGroup.horizontalScrollPosition = timeToPositionRatio * (intervalStart - _timeRange._ranges[i]);            
                
                if (borderVisible)
                {
                    intervalGroup.graphics.lineStyle( 1 );
                    intervalGroup.graphics.drawRect( 0, 0,(_timeRange._ranges[i+1] - _timeRange._ranges[i])*timeToPositionRatio-1, height -1);
                }
                else
                    intervalGroup.graphics.clear();
                
                //drawing obsels
                for each (var obselSkin : ObselSkin in obselsSkinsCollection)
                {    
                    var obsel : Obsel =  obselSkin.obsel;
                    obselSkin.x = (obsel.begin - _timeRange._ranges[i]) * timeToPositionRatio;
                    intervalGroup.addElement( obselSkin ) ;
                }    
                
                if ( lastIntervalGroup )
                    intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
                addChild( intervalGroup );
                lastIntervalGroup = intervalGroup;
            }
        }    
        
        /**
         * This redraw function is used when the same set of obsels is visible but their positions have changed. 
         *
         * It happens when the window is resized for example.
         *
         * @param    event
         */
        public function  updateObselPosition( event : Event = null) : void
        {                        
            var lastIntervalGroup : Group = null;
            var timeToPositionRatio : Number = (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;
            var indexIG : Number = 0;                
            for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
            {                
                if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
                    continue;
                    
                var intervalStart         : Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);
                var intervalEnd         : Number =  Math.min(_timeRange._ranges[i + 1], _timeRange.end);
                var intervalDuration     : Number = intervalEnd - intervalStart;        
                
                var intervalGroup : Group     = getChildAt( indexIG++) as Group;
                intervalGroup.width         = intervalDuration * timeToPositionRatio;
                intervalGroup.height         = height;    
                intervalGroup.horizontalScrollPosition = timeToPositionRatio * (intervalStart - _timeRange._ranges[i]);            
                
                if (borderVisible)
                {
                    intervalGroup.graphics.clear();
                    intervalGroup.graphics.lineStyle( 1 );
                    intervalGroup.graphics.drawRect( 0, 0,(_timeRange._ranges[i+1] - _timeRange._ranges[i])*timeToPositionRatio-1, height -1);
                }        
                else
                    intervalGroup.graphics.clear();

                for (var obselSkinIndex : int = 0; obselSkinIndex < intervalGroup.numElements;obselSkinIndex++ )
                {    
                    var obselSkin : ObselSkin = intervalGroup.getElementAt( obselSkinIndex) as ObselSkin;
                    var obsel : Obsel =  obselSkin.obsel;
                    obselSkin.x = (obsel.begin - _timeRange._ranges[i]) * timeToPositionRatio;
                }    
                
                if ( lastIntervalGroup )
                    intervalGroup.x = lastIntervalGroup.x + lastIntervalGroup.width + _timeRange.timeHoleWidth;
                lastIntervalGroup = intervalGroup;
            }
        }    
        
        /**
         * Function called when the ObselRenderer is resized.
         */
        override public function  onResize( event : ResizeEvent ) : void
        {
            updateObselPosition();
        }
        
        /**
         * Switch between different redraw functions.
         * @param    event
         */
        override public function onTimerangeChange( event : TimelineEvent ) : void
        {
            _timeRange = event.currentTarget as TimeRange;
            
            if ( numChildren > 0 )
            {
                if ( event.type == TimelineEvent.TIMERANGES_SHIFT)
                    updateViewportPosition();
                else if ( _timeRange._ranges.length/2 <= numChildren )
                    updateObselPosition() ;
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
        public function  updateViewportPosition( event : Event = null) : void
        {                        
            if ( !_timeRange)
                return;    
    
            var timeToPositionRatio : Number = (width - _timeRange.timeHoleWidth*(_timeRange.numIntervals-1)) / _timeRange.duration ;    
            var index : Number = 0;
            for (var i :int = 0; i < _timeRange._ranges.length; i+=2)
            {                
                if ( _timeRange.begin >= _timeRange._ranges[i + 1] ||  _timeRange.end <= _timeRange._ranges[i])
                    continue;
                    
                var intervalStart         : Number =  Math.max(_timeRange._ranges[i], _timeRange.begin);                
                var intervalGroup         : Group  = getChildAt(index++) as Group;                
                intervalGroup.horizontalScrollPosition = timeToPositionRatio * (intervalStart - _timeRange._ranges[i]);            
            }
        }        
        
        /**
         * @param    obsel An Obsel
         * @return the index in <code>obselsSkinsCollection</code> of the ObselSkin that represents <code>obsel</code>. Return -1 if the obsel is not found.
         */
        public function getObselSkinIndex( obsel : Obsel ) : int
        {            
            for ( var i: uint = 0; i < obselsSkinsCollection.length; i++ )
                if ((obselsSkinsCollection[i] as ObselSkin).obsel == obsel )
                    return i;
            
            return -1;
        }
        
        /**
         * Manage the <code>obselsSkinsCollection</code> when the <code>_obsels</code> ArrayCollection change.
         * This function is called when a CollectionEvent.COLLECTION_CHANGE is dispatched by <code>_obsels</code>.
         */
        override public function  onObselsCollectionChange( event : CollectionEvent ) : void
        {
            var obsel         : Obsel;
            var obselSkin     : ObselSkin;
            var obselIndex  : int ;
            
            switch (event.kind)
            {
                case CollectionEventKind.ADD :
                {    
                    obselsSkinsCollection.disableAutoUpdate();
                    for each ( obsel in event.items )
                    {
                        obselSkin = _timeline.styleSheet.getParameteredSkin( obsel, _traceline) ;
                        if (obselSkin)
                            obselsSkinsCollection.addItem( obselSkin);
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }                
                case CollectionEventKind.REMOVE :
                {
                    obselsSkinsCollection.disableAutoUpdate();
                    for each ( obsel in event.items )
                    {                    
                        obselIndex  = getObselSkinIndex( obsel );
                        if ( obselIndex >= 0)
                            obselsSkinsCollection.removeItemAt( obselIndex );
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }
                case CollectionEventKind.REPLACE :
                break;
                
                case CollectionEventKind.RESET :
                {
                    obselsSkinsCollection.removeAll();
                    obselsSkinsCollection.disableAutoUpdate();
                    for each ( obsel in _obsels )
                    {
                        obselSkin = _timeline.styleSheet.getParameteredSkin( obsel, _traceline) ;
                        if (obselSkin)
                            obselsSkinsCollection.addItem( obselSkin);
                    }
                    obselsSkinsCollection.enableAutoUpdate();
                    redraw();
                    break;
                }            
                                
                case CollectionEventKind.UPDATE :
                {                                    
                    for each ( var propChange : PropertyChangeEvent in event.items )
                    {                
                        obsel = propChange.source as Obsel;
                        obselIndex  = getObselSkinIndex( obsel );
                        if ( obselIndex >= 0)
                            (obselsSkinsCollection.getItemAt( obselIndex ) as ObselSkin).invalidateDisplayList();
                    }
                    break;
                }            
                default:
            }
            
        }    
    }
}