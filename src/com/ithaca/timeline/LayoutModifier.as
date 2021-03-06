package  com.ithaca.timeline
{
    /**
     * The LayoutModifier is a layout node which dynamicaly creates
     * Tracelines when needed. Tracelines are created at the same
     * layout level as the layoutModifier.
     *
     * <p> The only implemented layout modifier creates Tracelines
     * according to a given obsel property. It is commonly used with
     * the <code>type</code> property for instance.  </p>
     *
     * @see Layout
     */
    public class LayoutModifier extends LayoutNode
    {
        import com.ithaca.timeline.events.TimelineEvent;
        import com.ithaca.traces.Obsel;
        import com.ithaca.traces.Trace;
        import flash.sampler.NewObjectSample;
        import mx.collections.ArrayCollection;
        import mx.collections.errors.CollectionViewError;
        import mx.events.CollectionEvent;
        import mx.events.CollectionEventKind;

        /**
         * Name of the obsel property used to split the obsels source
         */
        public var _splitter: String = null ;

        /**
         * @see LayoutNode
         */
        public var source: String = "parent";
        /**
         * @see LayoutNode
         */
        public var autohide: Boolean = false;

        public function LayoutModifier(tl: Timeline)
        {
            _timeline = tl;
        }

        /**
         * @return the property used to split the trace
         */
        public function splitBy(): String
        {
            return _splitter;
        }

        /**
         * Create a RegexpSelector from a given obsel and the  _splitter property
         * @param obsel
         * @return a RegexpSelector
         */
        private function createSelector(obsel: Obsel): ISelector
        {
            var selector: ISelector = new SelectorRegexp();

            if (obsel.hasOwnProperty(_splitter))
                selector.setParameters(_splitter + "," + "^" + obsel[_splitter] +"$");
            else if (obsel.props.hasOwnProperty(_splitter))
                selector.setParameters(_splitter + "," + "^" + obsel.props[_splitter] +"$");
            else
                return null;

            return selector;
        }

        /**
         * Return a Selector if it did not previously exist in the Timeline.
         * Else return null
         */
        private function getSelectorIfNew(obsel: Obsel): ISelector
        {
            var selector: ISelector = createSelector(obsel);

            if (selector && parentNode)
                for (var brotherIndex: uint = 0; brotherIndex < parentNode.numElements; brotherIndex++)
                {
                    var brother: LayoutNode = parentNode.getElementAt(brotherIndex) as LayoutNode;
                    if (brother is TraceLine  && (brother as TraceLine).selector && (brother as TraceLine).selector.isEqual(selector))
                        return null;
                }

            return selector;
        }

        /**
         * (Re)check every obsel of the source.
         */
        override public function resetObselCollection(obselsCollection: ArrayCollection = null): void
        {
            for each (var item: Obsel in obselsCollection)
                newObsel(item);
        }

        /**
         * Check if an obsel can be added to a traceline and if not, create the traceline.
         */
        private function newObsel(obsel: Obsel): void
        {
            var selector: ISelector = getSelectorIfNew(obsel);

            if (selector)
            {
                var trac: Trace = obsel.trace;
                var newTree: LayoutNode = _timeline.timelineLayout.createTree(layoutXML, trac);
                var title: String;

                if (obsel.hasOwnProperty(_splitter))
                    title = obsel[_splitter];
                else if (obsel.props.hasOwnProperty(_splitter))
                    title = obsel.props[_splitter];

                newTree = new TraceLine(_timeline, title, null, selector, source);
                if ( source == "parent"  && parentNode is TraceLine)
                {
                    (parentNode as TraceLine)._obsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, (newTree as TraceLine).onSourceChange);
                    (newTree as TraceLine).resetObselCollection((parentNode as TraceLine)._obsels);
                }
                else
                {
                    if (trac)
                    {
                        trac.obsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, (newTree as TraceLine).onSourceChange);
                        (newTree as TraceLine).resetObselCollection(trac.obsels);
                    }
                }

                var event: TimelineEvent = new TimelineEvent(TimelineEvent.GENERATE_NEW_TRACELINE);
                event.value = { generator: this, obsel: obsel, traceline: newTree };
                _timeline.dispatchEvent(event);

                (newTree as TraceLine).autohide = autohide;
                newTree.styleName = styleName;

                parentNode.addChildAndTitle(newTree);
            }
        }

        override public function onSourceChange(event: CollectionEvent): void
        {
            switch (event.kind)
            {
                case CollectionEventKind.ADD:
                {
                    for each (var item: Obsel in event.items)
                        newObsel(item);
                    break;
                }
                case CollectionEventKind.REMOVE:
                break;

                case CollectionEventKind.REPLACE:
                break;

                case CollectionEventKind.RESET:
                break;

                default:
            }
        }
    }
}
