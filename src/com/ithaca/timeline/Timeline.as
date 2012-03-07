package com.ithaca.timeline
{
    import com.ithaca.timeline.events.TimelineEvent;
    import com.ithaca.timeline.PlayPauseButton;
    import com.ithaca.timeline.skins.TraceLineSkin;
    import com.ithaca.timeline.skins.TimelineSkin;
    import com.ithaca.traces.Trace;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.net.FileReference;
    import gnu.as3.gettext._FxGettext;
    import gnu.as3.gettext.FxGettext;
    import mx.collections.ArrayCollection;
    import mx.controls.Label;
    import mx.core.UIComponent;
    import spark.components.Group;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.components.supportClasses.Skin;
    import spark.events.ElementExistenceEvent;
    import mx.events.ResizeEvent;
    import mx.events.PropertyChangeEvent;
    import mx.formatters.DateFormatter;

    import com.flashartofwar.fcss.stylesheets.IStyleSheet;
    import com.flashartofwar.fcss.stylesheets.IStyleSheetCollection;
    import com.flashartofwar.fcss.stylesheets.FStyleSheet;
    import com.flashartofwar.fcss.stylesheets.StyleSheetCollection;
    import com.flashartofwar.fcss.styles.IStyle;
    import com.flashartofwar.fcss.applicators.IApplicator;

    /**
     * This style changes the zoomContext cursor behavior.
     * <p>
     * If set to 'follow', the cursor follows the current time and cannot be edited until the 'lock/unlock' button is clicked.<br>
     * If set to 'auto' the cursor follows the current time until it is manually edited. After editing, the 'lock/unlock' button can be toggled to restart following.<br>
     * If set to 'manual' the cursor does not follow the current time and can be freely edited.
     * </p>
     * @default manual
     */
    [Style(name = "cursorMode", type = "String", inherit = "no")]
    /**
     * This style is used in skins to allow layout editing for example.
     */
    [Style(name = "adminMode", type = "Boolean", inherit = "no")]
    /**
     * if 'relative', the time labels starts from 0 otherwise the time labels display absolute times.
     */
    [Style(name = "timeMode", type = "String", inherit = "no")]
    /**
     * This event is dispatched when the current time change (with 'set currentTime').
     * The current time of the timeline never changes internaly, it must be changed by the setter of currentTime.
     */

    [Style(name = "showPlayButton", type = "Boolean", inherit = "no")]
    [Style(name = "showExportButton", type = "Boolean", inherit = "no")]
    [Style(name = "showSearchBox", type = "Boolean", inherit = "no")]

    [Event(name = "currentTimeChange", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when one of the two time rulers is clicked.
     *
     * It is mostly used to indicate that the user wants to change the
     * currentTime.  The 'value' property of the TimelineEvent is the
     * time in milliseconds.
     */
    [Event(name = "timeRulerClick", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when the 'play' button is clicked.
     */
    [Event(name = "playButtonClick", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when the 'pause' button is clicked.
     */
    [Event(name = "pauseButtonClick", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when the currentTime exceeds the endAlertBeforeTime property milliseconds before the end of the time range of the timeline.
     */
    [Event(name = "endAlert", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when the currentTime reached (or exceed) the end of the time range of the timeline.
     */
    [Event(name = "endReached", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when a traceline is created by a layoutModifier.<br>
     * The 'value' property of the TimelineEvent is an object with 3 properties { generator, obsel, traceline } where:<br>
     * 'generator' is the LayoutModifier,<br>
     * 'traceline' is the created traceline,<br>
     * 'obsel' is the obsel for wich we create a new traceline.<br>
     */
    [Event(name = "generateNewTraceline", type = "com.ithaca.timeline.events.TimelineEvent")]
    /**
     * This event is dispatched when a layout node is added as child of another.
     * The 'value' property of the TimelineEvent is this LayoutNode.
     */
    [Event(name = "layoutNodeAdded", type = "com.ithaca.timeline.events.TimelineEvent")]

    /**
     * The main component of the package and the entry point of the API.
     */
    public class Timeline  extends LayoutNode
    {
        private var _styleSheet: Stylesheet;

        private var _layout: Layout;

        public var cssStyleSheetCollection: IStyleSheetCollection;

        public var debug: Object

        [Bindable]
        private var fxgt: _FxGettext = FxGettext;

        public  var range: TimeRange;
        /**
         * Activity trace
         */
        public var activity: Trace = null;

        [SkinPart(required="true")]
        /**
         * The container that contains the title part of the TracelineGroups
         */
        public  var titleGroup: Group;

        [SkinPart(required = "true")]
        public  var zoomContext: ZoomContext;

        [SkinPart(required="true")]
        /**
         * The cursor that indicates the current time value in the zoom part.
         */
        public  var globalCursor: Cursor;

        [SkinPart(required="true")]
        /**
         * The cursor that indicates the current time value in the context part.
         */
        public  var contextCursor: Cursor;

        private var _currentTime: Number = 0;

        public  var endAlertBeforeTime: Number = 30000;
        private var endAlertEventDispatched: Boolean = false;
        private var endReachedEventDispatched: Boolean = false;

        [Bindable]
        public var    isPlaying: Boolean = false;

        [Bindable]
        public var contextFollowCursor: Boolean = false;

        public var dateFormatter: DateFormatter = new DateFormatter();

        /**
         * Timeline constructor
         * @param xmlLayout an xml definition of the timeline layout
         */
        public function Timeline(xmlLayout: XML = null)
        {
            super();

            dateFormatter.formatString = "JJ:NN:SS";

            if (xmlLayout)
                layoutXML = xmlLayout;
            else
                layoutXML = <root>
                              <layout>
                                <tlg>
                                  <tl preview="true" title="All obsels" selector="SelectorRegexp" selectorParams="type,.*">
                                    <modifier splitter="type" />
                                  </tl>
                                </tlg>
                              </layout>
                            </root>;

            _timeline = this;

            timelineLayout = new Layout(this) ;
            _styleSheet = new Stylesheet();
            cssStyleSheetCollection = new StyleSheetCollection();

            range = new TimeRange();
            addEventListener(TimelineEvent.CURRENT_TIME_CHANGE, changeCursorValue);
            addEventListener(TimelineEvent.TIMERULER_CLICK, function(event: Event): void {
                if (activity !== null)
                    activity.trace("RulerClick", { position: (event as TimelineEvent).value });
            });
            range.addEventListener(TimelineEvent.TIMERANGES_CHANGE, function(): void { endAlertEventDispatched = false; });
            debug = new Object();
        }

        /**
         * Start tracing activity.
         *
         * If a Trace is passed as parameter, it will be used to store
         * the activity trace, even if another trace was already
         * defined.
         * Else, a new, empty trace will be created.
         *
         * @return The activity trace
         */
        public function startActivityTracing(tr: Trace = null): Trace
        {
            if (tr !== null)
            {
                activity = tr;
            }
            else if (activity === null)
            {
                activity = new Trace();
            }
            /* Configure trace */
            activity.addFusionedType("EndSlideScaleChange");
            activity.addFusionedType("EndSlidePositionChange");
            activity.trace("TracingStart", { layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
            return activity;
        }

        override public function styleChanged(styleProp: String): void
        {
            super.styleChanged(styleProp);
            //trace("styleChanged", styleProp, getStyle(styleProp));
            if (this.skin === null)
                return;

            var showableWidgets: Object = {
                'showSearchBox': (this.skin as TimelineSkin).searchBox,
                'showExportButton': (this.skin as TimelineSkin).exportButton,
                'showPlayButton': (this.skin as TimelineSkin).playButton
            };

            /* Display widget from tunableWidgets is CSS value is true */
            if (showableWidgets.hasOwnProperty(styleProp))
            {
                showableWidgets[styleProp].setVisible(getStyle(styleProp) == 'true' || getStyle(styleProp) === true);
            }

            /* FIXME: should propagate other style changes: adminMode */
            if (zoomContext)
                if (!styleProp || styleProp == 'cursorMode')
                {
                    switch(getStyle('cursorMode'))
                    {
                        case 'auto':
                            zoomContext.cursorEditable = true;
                            contextFollowCursor = true;
                            break;
                        case 'follow':
                            zoomContext.cursorEditable = false;
                            contextFollowCursor = true;
                            break;
                        case 'manual':
                            zoomContext.cursorEditable = true;
                            contextFollowCursor = false;
                            break;
                        default:
                            break;
                    }
                }
        }

        override protected function partAdded(partName: String, instance: Object): void
        {
            super.partAdded(partName, instance);
            if (partName == "zoomContext")
            {
                zoomContext.timeline = this;
                styleChanged('cursorMode');
                // zoomContext.addEventListener(ResizeEvent.RESIZE, changeCursorValue);
                zoomContext.cursorRange.addEventListener(TimelineEvent.TIMERANGES_CHANGE, function(event: Event): void {
                    if (activity !== null)
                        activity.trace("EndSlideScaleChange", { begin: zoomContext.cursorRange.begin,
                                                                end: zoomContext.cursorRange.end,
                                                                ratio: zoomContext.cursorRange.duration / zoomContext._timelineRange.duration
                                                              });
                    changeCursorValue(event);
                });
                zoomContext.cursorRange.addEventListener(TimelineEvent.TIMERANGES_SHIFT, function(event: Event): void {
                    if (activity !== null)
                        activity.trace("EndSlidePositionChange", { begin: zoomContext.cursorRange.begin,
                                                                   end: zoomContext.cursorRange.end
                                                                 });
                    changeCursorValue(event);
                });
                zoomContext._timelineRange.addEventListener(TimelineEvent.TIMERANGES_CHANGE, changeCursorValue);
                zoomContext._timelineRange.addEventListener(TimelineEvent.TIMERANGES_SHIFT, changeCursorValue);
            }
            if (partName == "titleGroup")
            {
                addEventListener(ElementExistenceEvent.ELEMENT_ADD, onTracelineGroupsChange);
                addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, onTracelineGroupsChange);
            }
        }

        /**
         * Update the titleGroup when the contentGroup which contains the traceLineGroups change.
         * <p> As we work on the contentGroup in the case of TraceLineGroup removal or  TraceLineGroup Drag'n Drop we must update the titleGroup (they must always stay in the same order).</p>
         */
        private function onTracelineGroupsChange(event: ElementExistenceEvent): void
        {
            if (event.type == ElementExistenceEvent.ELEMENT_ADD)
                titleGroup.addElementAt((event.element as TraceLineGroup).titleComponent, event.index);
            else if (event.type == ElementExistenceEvent.ELEMENT_REMOVE)
                titleGroup.removeElementAt(event.index);
        }

        /**
         * Create a new Tracelinegroup from a trace and add it to the Timeline
         * @param pTrace the trace to add
         * @param index the position of new Tracelinegroup in the Timeline (-1 to add it at the end)
         * @param style the style name of the tracelinegroup to create.
         * @return the TraceLineGroup if the creation succeeded otherwise return null.
         */
        public function addTrace (pTrace: Trace, index: int = -1, style: String = null): TraceLineGroup
        {
            var tlg: TraceLineGroup  =  timelineLayout.createTracelineGroupTree(pTrace, style);

            if (tlg)
            {
                addChildAndTitle(tlg, index);
                if (activity !== null)
                    activity.trace("AddTracelineGroup", { group: tlg.title,
                                                          new_layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
            }

            if (activity !== null)
                activity.trace("AddTrace", { uri: pTrace.uri, new_layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
            return tlg;
        }

        /**
         * Ensure that the TraceLineGroup is visible.
         */
        public function makeTracelineGroupVisible(tlg: TraceLineGroup, fillHole: Boolean = true): void
        {
            if (!isNaN(tlg.traceBegin) && !isNaN(tlg.traceEnd))
                range.addTime(tlg.traceBegin, tlg.traceEnd, fillHole);
        }

        /**
         * Remove the first Tracelinegroup with a given trace
         * @param tr the trace of the TraceLineGroup
         * @return true if sucess else return false.
         */
        public function removeTrace(tr: Trace): Boolean
        {
            for (var i: int = 0; i < numElements; i++)
            {
                var tlg: TraceLineGroup = getElementAt(i) as TraceLineGroup;
                if (tlg.trace == tr)
                    {
                        removeTraceLineGroup (tlg);
                        if (activity !== null)
                        activity.trace("DeleteTrace", { uri: tr.uri, new_layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
                        return true;
                    }
            }
            return false;
        }

        /**
         * Find and return the first TraceLineGroup whose trace has a given URI ; return null if not found.
         * @param uri the uri of the trace
         * @return the tracelinegroup if exists. null if not found.
         */
        public function getTraceLineGroupByTraceUri(uri: String): TraceLineGroup
        {
            for (var i: int = 0; i < numElements; i++)
            {
                var tlg: TraceLineGroup = getElementAt(i) as TraceLineGroup;
                if (tlg.trace.uri == uri)
                        return tlg ;
            }

            return null;
        }

        /**
         * Remove a TraceLineGroup
         * @param tlg the TraceLineGroup to remove.
         */
        public function removeTraceLineGroup (tlg: TraceLineGroup): void
        {
            if (tlg)
            {
                removeElement(tlg);
                if (activity !== null)
                activity.trace("DeleteTracelineGroup", { group: tlg.title,
                                                         new_layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
            }
        }

        /**
         * Change the position of a TraceLineGroup
         * @param fromIndex
         * @param toIndex
         */
        public function moveTraceLineGroup(fromIndex: uint, toIndex: uint): void
        {
            addElementAt(getElementAt(fromIndex) as TraceLineGroup, toIndex);
            if (activity !== null)
                activity.trace("MoveTracelineGroup", { group: (getElementAt(toIndex) as TraceLineGroup).title,
                                                       new_layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
        }

        /**
         * @return the Layout object bound to this Timeline
         * @see Layout
         */
        public function get timelineLayout(): Layout { return _layout; }
        /**
         * Set the Layout object of the timeline
         * @param value
         */
        public function set timelineLayout(value: Layout): void
        {
            if (_layout)
            {
                //the selectors must be loaded before the _layout because the traceline could be defined by using one of them
                _layout.loadObselsSelectors(layoutXML[Layout.OBSELS_SELECTORS]);

                var traceArray: Array = this.getCurrentTraces();
                removeAllElements();

                _layout = value;

                while (traceArray.length > 0)
                    // FIXME: we should somehow pass additional parameters (esp. style) to addTrace if necessary
                    addTrace(traceArray.shift() as Trace);
            }
            else
                _layout = value;

            if (activity !== null)
            activity.trace("LayoutUpdate", { layout: timelineLayout.getCurrentXmlLayout().toXMLString() });
            dispatchEvent(new TimelineEvent(TimelineEvent.LAYOUT_CHANGE));
        }

        /**
         * @return the beginning value of the timeline in milliseconds
         */
        public function get begin(): Number { return range.begin; }

        /**
         * @return  the ending value of the timeline in milliseconds
         */
        public function get end(): Number { return range.end; }

        /**
         * @return  the duration of the timeline in milliseconds
         */
        public function get duration(): Number { return range.duration; }

        /**
         * @return
         */
        public function get styleSheet(): Stylesheet { return _styleSheet; }
        /**
         * @param value
         */
        public function set styleSheet(value: Stylesheet): void { _styleSheet = value; }

        /**
         * Change the time range limits. It's used to make a zoom for example.
         * By default, the range limits are the limits of the loaded traces.
         * @param startValue
         * @param endValue
         */
        public function setTimeRangeLimits(startValue: Number, endValue: Number): void
        {
            range.changeLimits(startValue, endValue);
        }

        /**
         * Reset the time range limits to the the limits of the loaded traces.
         */
        public function resetTimeRangeLimits(): void
        {
            range.reset();
        }

        /**
         * Make a time hole between the startValue and endValue.
         * @param startValue lower limit of the time hole interval
         * @param endValue higher limit of the time hole interval
         */
        public function makeTimeHole(startValue: Number, endValue: Number): void
        {
            range.makeTimeHole(startValue, endValue);
            zoomContext.setRange(range.begin, range.end);
        }

        /**
         * @return the current time value in milliseconds
         */
        public function get currentTime(): Number
        {
            return _currentTime;
        }

        /**
         * @return the current time value in milliseconds from the beginning of the timeline range
         */
        public function get currrentRelativeTime(): Number
        {
            if (range.isEmpty())
                return currentTime;
            else
                return currentTime - range._ranges[0];
        }

        /**
         * Modify the current time value.
         *
         * It is the only way to change the current value of the
         * timeline and it is never called in the timeline code (it
         * must be changed from outside)
         *
         * @param timeValue the new time value in milliseconds
         */
        public function set currentTime(timeValue: Number): void
        {
            if (! range.isEmpty()) {
                var timerangeEnd: Number = range._ranges[ range._ranges.length -1 ];
                var timerangeBegin: Number = range._ranges[0];

                if (timeValue > timerangeEnd)
                {
                    dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED));
                    timeValue = timerangeEnd;
                }

                if (timeValue >= timerangeEnd - endAlertBeforeTime)
                {
                    if (!endAlertEventDispatched)
                    {
                        endAlertEventDispatched = true;
                        dispatchEvent(new TimelineEvent(TimelineEvent.END_ALERT));
                    }
                }
                else
                    endAlertEventDispatched = false;
            }
            _currentTime = timeValue;
            dispatchEvent(new TimelineEvent(TimelineEvent.CURRENT_TIME_CHANGE, true))
        }

        private function changeCursorValue(event: Event): void
        {
            var timeValue: Number = currentTime;

            if (timeValue >= begin && timeValue <= end)
            {
                globalCursor.visible = true;
                globalCursor.x = Stylesheet.renderersSidePadding + zoomContext._timelineRange.timeToPosition(timeValue, zoomContext.timelinePreview.width);
            }
            else
                globalCursor.visible = false;


            var minPosition: Number = zoomContext.cursorRange.begin;
            var maxPosition: Number = zoomContext.cursorRange.end - zoomContext.cursorRange.duration * 0.15;

            if (contextFollowCursor && !contextCursor.isDragging && (timeValue > maxPosition || timeValue < minPosition))
                zoomContext.shiftContext(timeValue - zoomContext.cursorRange.begin);


            if (timeValue >= zoomContext.cursorRange.begin && timeValue <= zoomContext.cursorRange.end +1000)
            {
                contextCursor.visible = true;
                contextCursor. x = Stylesheet.renderersSidePadding + zoomContext.cursorRange.timeToPosition(timeValue, zoomContext.timelinePreview.width);
            }
            else
                contextCursor.visible = contextCursor.isDragging;
        }

        /**
         * @return true if the timeMode style is set to 'relative'. 'true' means that timeLabels must be shown in relative mode (from 0 to timeline duration)
         */
        public function get isRelativeTimeMode(): Boolean
        {
            return getStyle('timeMode') == 'relative';
        }

        /**
         * Get the currently displayed traces
         */
        public function getCurrentTraces(): Array
        {
            var current: Array = new Array();

            for (var tlgIndex: uint = 0; tlgIndex < this.numElements; tlgIndex++)
            {
                var tlg: TraceLineGroup = this.getElementAt(tlgIndex) as TraceLineGroup;
                current.push(tlg.trace);
            }
            return current;
        }

        /*
         * Try to apply the given stylesheet to the TraceLine and its descendants.
         */
        public function applyStylesheetToTraceline(applicator: IApplicator, stylesheet: IStyleSheet, traceline: TraceLine, selector: ISelector = null): void
        {
            if (traceline === null)
            {
                /*
                 * FIXME: this catches a case that should be properly
                 * solved: there is no good reason that a NULL tl is
                 * present in the TLG children.
                 */
                trace("Skipping null tl");
                return;
            }
            applicator.applyStyle(traceline.skin, stylesheet.getStyle("TraceLine", traceline.name, "TraceLine." + traceline.styleName));

            this.debug['traceline'] = traceline;
            if (traceline.skin !== null)
            {
                /* Apply stylesheet to traceline obsels */
                for each (var os: ObselSkin in (traceline.skin as TraceLineSkin).obselsRenderer.obselsSkinsCollection)
                {
                    /* FIXME: how to handle skin change if skin-class is defined ? */
                    if (os.skin !== null)
                    {
                        this.debug['os'] = os;

                        applicator.applyStyle(os,
                                              stylesheet.getStyle("Obsel",
                                                                  os.obsel.type,
                                                                  traceline.name + ".Obsels",
                                                                  "Traceline." + traceline.styleName + ".Obsels"));
                        if (selector !== null) {
                            if (selector.isObselMatching(os.obsel))
                                applicator.applyStyle(os, stylesheet.getStyle("Obsel:match", os.obsel.type + ":match"))
                            else
                                applicator.applyStyle(os, stylesheet.getStyle("Obsel:nonmatch", os.obsel.type + ":nonmatch"));
                        }
                    }
                }
            }

            /* Recursively apply to children tracelines */
            for (var tlIndex: uint = 0; tlIndex < traceline.numElements; tlIndex++)
            {
                var tl: TraceLine = traceline.getElementAt(tlIndex) as TraceLine;
                applyStylesheetToTraceline(applicator, stylesheet, tl, selector);
            }
        }

        /*
         * Apply the given CSS specification to the Timeline elements.
         *
         * FIXME: properly register the new styles in the Flex
         * stylemanager, so that new created elements get the
         * appropriate styles too.
         *
         * If selector is not null, it must define a selector that will be applied to obsels.
         * If the obsel matches, then the Obsel:match rule from stylesheet is applied.
         * It the obsel does not match, the Obsel:nonmatch rule from stylesheet is applied.
         *
         * A typical use is to provide the following CSS:
         * Obsel:nonmatch { visible: false; }
         * to hide obsels that do not match the selector.
         */
        public function applyCSS(cssData: String, selector: ISelector = null): void
        {
            var stylesheet: IStyleSheet = new FStyleSheet();
            var applicator: IApplicator = new TimelineStyleApplicator();
            var st: IStyle;

            stylesheet.parseCSS(cssData);

            this.debug['stylesheet'] = stylesheet;

            /* Add the loaded stylesheet to the timeline cssStylesheetCollection.
             * FIXME: should we generate a different name with
             * "css" + cssStylesheetCollection.totalStyleSheets());
             * ?
             */
            cssStyleSheetCollection.addStyleSheet(stylesheet);

            /* Apply properties to Timeline: adminMode, cursorMode, timeMode */
            applicator.applyStyle(this, cssStyleSheetCollection.getStyle("Timeline"));

            /* Walk through the timelinegroup/traceline/obsels
             * elements and try to apply the new stylesheet */
            for (var tlgIndex: uint = 0; tlgIndex < this.numElements; tlgIndex++)
            {
                var tlg: TraceLineGroup = this.getElementAt(tlgIndex) as TraceLineGroup;

                applicator.applyStyle(tlg.skin,
                                      cssStyleSheetCollection.getStyle("TraceLineGroup", "TraceLineGroup." + tlg.styleName, tlg.name));

                for (var tlIndex: uint = 0; tlIndex < tlg.numElements; tlIndex++)
                {
                    var tl: TraceLine = tlg.getElementAt(tlIndex) as TraceLine;
                    applyStylesheetToTraceline(applicator, cssStyleSheetCollection, tl, selector);
                }
            }

            /* Apply selector to contextPreviewTraceLine */
            /* FIXME: this is an interim implementation. Ideally,
               SimpleObselsRenderer should handle some form of CSS.
            */
            for (var i: int = 0; i < this.zoomContext.timelinePreview.numElements; i++)
            {
                var renderer: BaseObselsRenderer = this.zoomContext.timelinePreview.getElementAt(i) as BaseObselsRenderer;
                if (renderer != null)
                    renderer.filterDisplay(selector);
            }
        }

        /*
         * Filter the display of obsels.
         *
         * Display only obsels matching a given string. If the string is in the form
         * key,regexp (cf SelectorRegexp parameter syntax)
         * then the "key" property will be matched against regexp.
         * If the string contains no comma, then the whole TTL representation is matched (fulltext search).
         *
         * Calling with no parameter resets the filter (all obsels are shown).
         */
        public function filterDisplay(expr: String = null): void
        {
            var selector: ISelector = null;

            if (expr == null)
            {
                this.applyCSS('Obsel { visible: true; }');
            }
            else
            {
                if (expr.indexOf(',') > -1)
                    selector = new SelectorRegexp(expr)
                else
                    selector = new SelectorRegexp("rdf," + expr);
                this.applyCSS('Obsel:nonmatch { visible: false; }', selector);
            }
        }

        /**
         * Return a formatted representation of t (in ms)
         *
         * It takes into account the isRelativeTimeMode of the
         * timeline.
         */
        public function formatTime(time: Number): String
        {
            var date: Date;

            if (isRelativeTimeMode)
            {
                date = new Date(time - range._ranges[0]);
                return dateFormatter.format(date.toUTCString());
            }
            else
            {
                date = new Date(time);
                return dateFormatter.format(date);
            }
        }

        /**
         * Save the displayed traces.
         */
        public function saveTraceTo(format: String = "tsv"): void
        {
            var traces: Array = getCurrentTraces();
            if (traces.length == 0)
                return;

            var fr: FileReference = new FileReference();
            /* We build a temporary trace */
            var temp: Trace = new Trace();

            if (traces.length == 1)
            {
                /* Only 1 trace, reuse the obsels attribute */
                temp.obsels = traces[0].obsels;
            }
            else
            {
                /* We have to concatenate obsels from all traces */
                for each (var tr: Trace in traces)
                {
                    temp.obsels.addAll(tr.obsels);
                }
            }
            if (format == "ttl")
                fr.save(temp.toTTL(), 'trace.ttl');
            else
                fr.save(temp.toTSV(), 'trace.tsv');
        }
    }
}
