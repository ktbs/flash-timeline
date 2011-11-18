package com.ithaca.timeline
{
    import mx.collections.ArrayCollection;
    import spark.components.SkinnableContainer;
    import mx.events.CollectionEvent;
    
    import com.ithaca.timeline.events.TimelineEvent;
    
    /**
     * The LayoutNode class is a base class for each node in the
     * layout tree; it should be an abstract class.
     *
     * It is inherited by the following classes:
     * @see Timeline
     * @see TraceLineGroup
     * @see TraceLine
     * @see LayouModifier
     */
    public class LayoutNode extends SkinnableContainer
    {
        /**
         * The XML descriptor of the sub-layout from this node.
         */
        private var _layout         : XML ;    
        /**
         * The visual component used to show the title part of the node. It is a container because titleComponent contains the titleComponent of the node children.
         */
        public  var titleComponent     : SkinnableContainer;    
        /**
         * A reference to the timeline
         */
        public  var _timeline        : Timeline;
        /**
         * A reference to the parent node of this node. The children are browsed using the container method (getElementAt...) but we need this reference to walk up the tree.
         */
        public  var parentNode        : LayoutNode;
        
        /**
         * The XML descriptor of the sub-layout from this node.
         */
        public function set layoutXML ( value : XML ) : void { _layout = value; }
        /**
         * @return The XML descriptor of the sub-layout from this node.
         */
        public function get layoutXML ( ) : XML    { return _layout;    }

        /**
         *
         * @param child
         * @param index
         */
        public function addChildAndTitle ( child : LayoutNode, index : int = -1 ) : void
        {     
            child.parentNode = this;
        
            if ( index < 0 || index >= numElements)
                addElement( child );
            else
                addElementAt( child, index );
            
            if ( titleComponent && child.titleComponent)
            {
                if ( index < 0 || index >= numElements)
                    titleComponent.addElement( child.titleComponent );
                else                    
                    titleComponent.addElementAt( child.titleComponent, index );                
            }
            
            if (_timeline)
            {
                var event : TimelineEvent = new TimelineEvent( TimelineEvent.LAYOUT_NODE_ADDED );
                event.value = child;
                _timeline.dispatchEvent( event );
            }
        }
        
        /**
         *
         * @return the tracelinegroup containing this node
         */
        public function getTraceLineGroup() : TraceLineGroup
        {
            var nodeCursor : LayoutNode = this;
            
            while ( nodeCursor && !(nodeCursor is TraceLineGroup) )
                nodeCursor = nodeCursor.parentNode;
            
            if (nodeCursor)            
                return (nodeCursor as TraceLineGroup);
            else
                return null;
        }
        
        /**        
         * Return the layoutNode of a given name in the subtree of this node
         * @param name
         * @return the first element with a given 'name' in the children of this node
         */
        public function getElementByName( name : String) : LayoutNode
        {
            for ( var childIndex : uint = 0; childIndex < this.numElements; childIndex++ )
            {
                var child : LayoutNode = this.getElementAt( childIndex ) as LayoutNode;
                if ( child is TraceLine  && (child as TraceLine).title == name )
                    return child;

                var recursiveChild : LayoutNode= child.getElementByName( name );
                if ( recursiveChild != null )
                    return recursiveChild;
            }
            return null;
        }
        
        /**
         *
         * @param child
         */
        public function removeChildAndTitle( child : LayoutNode ) : void
        {
            removeElement( child  );
            titleComponent.removeElement( child.titleComponent );            
        }    
        
        /**
         * @param event
         */
        public function onSourceChange( event : CollectionEvent ) : void { };
        /**
         *
         * @param obselsCollection
         */
        public function resetObselCollection ( obselsCollection : ArrayCollection = null) : void { };
    }
}