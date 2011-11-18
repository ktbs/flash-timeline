package com.ithaca.timeline
{
    import com.ithaca.traces.Obsel;
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    /**
     * The height of the obsel renderer component
     */
    [Style(name = "rendererHeight", type = "Number", inherit = "no")]    
    /**
     * The gap under the obsel renderer component
     */
    [Style(name = "rendererGap", type = "Number", inherit = "no")]    
    [Style(name = "title", type = "String", inherit = "no")]

    /**
     * The TraceLine class extends the LayoutNode ; it manages an obsels collection selected from an obsels source and renders them.
     *
     * @see Layout
     * @see LayoutNode
     */
    public class TraceLine  extends LayoutNode
    {    
        //private var _title             : String;
        public var sourceStr             : String;
        private var _selector             : ISelector;
        public var _obsels                 : ArrayCollection = new ArrayCollection();
        public var lastRendererHeight    : Number;
        public var lastRendererGap        : Number;
        public var autohide                : Boolean=false;
        
        /**
         * Create a new Traceline
         * 
         * @param tl: the timeline containing the traceline
         * @param tlTitle: the title (and name/id) of the traceline. It is used by CSS selectors.
         * @param tlSelector: the traceline selector
         * @param tlSource: the traceline obsel source
         * @param tlSkinClass: FIXME
         */
        public function TraceLine( tl : Timeline, tlTitle : String = null, tlSelector : ISelector = null, tlSource : String = null, tlSkinClass : String = null )
        {
            _timeline        = tl;
            titleComponent    = new TraceLineTitle( this );
            title            = tlTitle;
            if (title)
                this.name        = title;
            _selector        = tlSelector;
            sourceStr        = tlSource;        
            styleName        = tlSkinClass;            
        }
        
        /**
         * Sets the title (but not the name) of the Traceline
         */
        public function set title ( value : String ) : void
        {            
            setStyle('title', value);            
        }
        
        public function get title (  ) : String
        {
            return getStyle('title');            
        }
        
        public function set selector ( value : ISelector ) : void
        {            
            _selector = value;
            resetObselCollection();
        }
        
        public function get selector (  ) : ISelector
        {
            return _selector;
        }

        /**
         * @return the obsels collection used as source (before selection) by the traceline ; it can be the timeline trace or the obsels collection of the parent node
         */
        public function getCollectionSource() : ArrayCollection
        {
            switch ( sourceStr )
            {
                case "parent" :
                {
                    if ( parentNode )
                    {
                        if ( parentNode is TraceLine)
                            return ( parentNode as TraceLine )._obsels;                    
                        if ( parentNode is TraceLineGroup )
                            return ( parentNode as TraceLineGroup ).trace.obsels;                
                    }
                    return null;            
                }
                default:
                {
                    var tlg : TraceLineGroup = getTraceLineGroup();
                    if (tlg && tlg.trace)
                        return tlg.trace.obsels;
                    else
                        return null;
                }
            }
        }
        /**
         * Check if an obsel matches the selector
         * @param obsel
         * @return true if the obsel matches the selector or if there's no selector ; otherwise return false.
         */
        public function acceptObsel ( obsel : Obsel ) : Boolean
        {
            return ( !_selector || _selector.isObselMatching( obsel as Obsel ) );
        }
        
        /**
         * Add an obsel in the obsel collection
         * @param    event
         */
        public function addObsel ( obsel : Obsel ) : void
        {
            if ( acceptObsel( obsel ) )
                _obsels.addItem( obsel );
        }
        
        /**
         * Remove an  obsel from the obsel collection
         * @param    event
         */
        public function removeObsel ( obsel : Obsel ) : void
        {
            var obselIndex : int = _obsels.getItemIndex( obsel );
            if ( obselIndex >= 0)
                _obsels.removeItemAt( obselIndex );
        };
        
        /**
         * Rebuild the obsel collection from source
         * @param    event
         */
        override public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void
        {        
            _obsels.disableAutoUpdate();
            _obsels.removeAll();
        
            if ( obselsCollection == null )
                obselsCollection = getCollectionSource();                
            if (obselsCollection != null && obselsCollection.length >0)
            {                    
                for each( var obsel :  Obsel in obselsCollection)
                    addObsel( obsel );                            
            }            
            _obsels.enableAutoUpdate();
            
            if (autohide)
                SetToVisible( _obsels.length > 0 );
        }        
        
        /**
         * Handle an obsel collection event that occurs in the source collection
         * @param    event
         */
        override public function onSourceChange( event : CollectionEvent ) : void
        {
            _obsels.disableAutoUpdate();
            
            var obsel : Obsel;
            switch (event.kind)
            {
                case CollectionEventKind.ADD :
                {                
                    for each ( obsel in event.items )
                        addObsel( obsel );
                    break;
                }                
                case CollectionEventKind.REMOVE :
                {                    
                    for each ( obsel in event.items )
                        removeObsel( obsel );
                    break;
                }
                case CollectionEventKind.REPLACE :
                break;
                
                case CollectionEventKind.RESET :    
                    resetObselCollection();
                break;                
                
                default:
            }                        
                                    
            _obsels.enableAutoUpdate();
            
            if ( autohide )
                SetToVisible( _obsels.length > 0 );
        }

        /**
         * Compute the number of traceline children which are not hidden ; used to know if the open/close button must be visible.
         * <p> This is because a node could have children in autohide mode and then the open button must be hidden </p>
         *
         * @return the number of visible children
         */
        public function getVisibleChildrenNumber() : Number
        {
            var numTl : Number = 0;
            for ( var lnIndex : int = 0; lnIndex < numElements; lnIndex++ )
                if ( getElementAt(lnIndex) is TraceLine && (getElementAt(lnIndex) as TraceLine).visible )
                    numTl++;
            
            return numTl;
        }
        
        /**
         * Show or hide the traceline and its children according to the parameter.
         * @param    visible if true the TraceLine is visible; otherwise it's hidden.
         */
        public function SetToVisible( visible: Boolean ) : void
        {
            if (this.visible == visible)
                return;
            
            if ( _timeline.getStyle( "adminMode" ) != true)
            {
                this.visible                         = visible;
                titleComponent.visible                = visible;
                if ((titleComponent as TraceLineTitle).OpenButton)
                    (titleComponent as TraceLineTitle).OpenButton.visible = visible && (getVisibleChildrenNumber() > 0);
                    
                if (parentNode is TraceLine && parentNode.visible && parentNode.titleComponent && ((parentNode as TraceLine).titleComponent as TraceLineTitle).OpenButton)
                    ((parentNode as TraceLine).titleComponent as TraceLineTitle).OpenButton.visible = ((parentNode as TraceLine).getVisibleChildrenNumber() > 0 );
                            
                setStyle( 'hide', !visible )                    
            }
        }
    }
}