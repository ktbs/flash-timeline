package com.ithaca.timeline
{
    import com.ithaca.traces.Trace;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import flash.ui.MouseCursor
    import com.ithaca.traces.TraceManager;

    /**
     * The Layout class manages the creation of tracelines and tracelinegroups in a tree layout as defined in a XML descriptor.
     * Each node of the tree extends the LayoutNode abstract class (currently TraceLineGroup, TraceLine, LayoutModifier or Timeline).
     *
     * <p>
     * The XML descriptor is referenced by the _timeline property (_timeline.layoutXML[LAYOUT]) which is also the root of the tree (as a LayoutNode).
     * </p>
     * <p>
     * In addition to this definition, the _timeline.layoutXML xml contains a second section to define obsels selectors (_timeline.layoutXML[OBSELS_SELECTORS]).
     * These selectors are used both to create CSS selector for ObselSkins (in order to use different skins) and to define traceline selectors.
     * </p>
     *
     * <p>
     * The following XML element names are defined in this class:
     * <ul>
     *     <li><strong>layout:</strong>         the layout section</li>
     *  <li><strong>tlg:</strong>             a tracelinegroup node. Attributes:</li>
     *                 <ul>
     *                     <li><em>title: </em> the title and the <code>name</code> of the tracelinegroup  </li>
     *                     <li><em>stylename: </em> the stylename of the tracelinegroup. It is used to select a specific layout (see examples) </li>
     *                    <li><em>source: </em> layout selector with the URI of the trace</li>
     *                 </ul>
     *  <li><strong>tl:</strong>             a traceline node. Attributes:
     *                 <ul>
     *                     <li><em>title: </em> the title and the <code>name</code> of the traceline  </li>
     *                     <li><em>stylename: </em> the stylename of the traceline. There are two specials stylenames: 'background' to define the traceline in the background of the tracelinegroup and 'contextPreview' to define a preview traceline not in the layout</li>
     *                     <li><em>selectorID: </em> a selector defined in the obselsSelectors section</li>
     *                     <li><em>selector: </em>a selector class name (should be followed by a selectorParams attribute)</li>
     *                     <li><em>selectorParams: </em>the selector parameters </li>
     *                     <li><em>autohide: </em>if "true", the traceline is automaticaly hidden or shown if the the traceline is empty or not</li>
     *                    <li><em>preview: </em>if "true", the traceline is used as preview in the zoomContext zone</li>
     *                    <li><em>source: </em>if "parent", the obsels source of the traceline is the parent layoutNode otherwise it is the whole trace</li>
     *                 </ul>
     *  </li>
     *  <li><strong>modifier:</strong>      a layout modifier node </li>
    *             <ul>
    *                     <li><em>splitter: </em> the obsel property along which we want to split the obsels </li>
     *                     <li><em>name: </em> the name of the layout modifier, in order to know by whom the tracelines are created (when listening to the TimelineEvent: GENERATE_NEW_TRACELINE) </li>
     *                     <li><em>stylename: </em> the stylename of the created traceline.
     *                     <li><em>autohide: </em> the value of the <code>autohide</code> property for the created tracelines </li>
     *                    <li><em>source: </em>if "parent", the obsels source of the modifier is the parent layoutNode otherwise it is the whole trace</li>
     *                 </ul>
     *  <li><strong>obselsSelectors:</strong> the obsel selectors section</li>
     *  <li><strong>obselsSelector:</strong> an obsel selector. Attributes:
     *             <ul>
     *                     <li><em>id: </em>the ID of the selector (will be the stylename of matching obselSkins)</li>
     *                     <li><em>selector: </em>a selector class name (should be followed by a selectorParams attribute)</li>
     *                  <li><em>selectorParams: </em>the selector parameters </li>
     *             </ul>
     * </li>
     * </ul>
     * </p>
     *
     * <p><strong>Important</strong> When a new trace is dynamically
     * added to a timeline (with a given stylename), the Layout is
     * searched for a matching stylename. If no matching stylename is
     * found, the last TimelineGroup definition is used. It is thus a
     * good practice to always put a generic TimelineGroup definition
     * at the end of the Layout.</p>
     *
     * <p>
     * Besides the XML driven creation, the Layout class can also be used to modify the tree with low level methods. For example: <br/>
     * <code>
     *         timeline.timelineLayout.addTraceline(traceline, parentLayoutNode);
     * </code>
     * </p>
     *
     * @example The minimal Layout definition that allows to see something
     * <listing version="3.0"> <p>
     *  &lt;root&gt;<br />
     *  &lt;!-- this is the minimal layout definition that allows to see something--&gt;<br />
     *  <br />
     *   <em>&lt;!--there is no ObselsSelectors definition. That means that all obsels will be rendered with the default obselSkin skin --&gt;</em><br />
     *  <br />
     *  &lt;!-- the layout definition --&gt;<br />
     *  &lt;layout&gt;<br />
     *      &lt;!-- Default and only traceLineGroup definition. Each Trace will use this definition --&gt;<br />
     *      &lt;tlg &gt;   <br />
     *      &lt;!-- One traceLine with no selector (every obsel will match) --&gt;<br />
     *           &lt;tl /&gt;<br />
     *       <br />
     *          &lt;!-- there is no traceLine tagged with the &#39;preview&#39; attribute. Then, this Tracelinegroup preview (in the zoomContext part) is a traceline that renders the whole trace --&gt;<br />
     *      &lt;/tlg &gt;    <br />
     *  &lt;/layout&gt;<br />
     * &lt;/root&gt;  </p></listing>
     *
     * @example  A second version of mini layout. This one contains an ObselsSelectors section
     * <listing version="3.0"> <p>
     * &lt;root&gt;<br />
     *    &lt;!-- A second version of mini layout. This one contains an ObselsSelectors section --&gt;<br />
     *    <br />
     *    &lt;!-- The ObselsSelectors section defines selectors that are used to set a &#39;stylename&#39; to obselSkins which match.<br />
     *        This stylename can be used as obselSkins selectors in the CSS file<br />
     *        For example:<br />
     *            timeline|ObselSkin.Message<br />
     *            {<br />
     *            ...<br />
     *            }<br />
     *       <br />
     *        The &#39;selector&#39; attribute is the class name of a ISelector implementaion.<br />
     *        The &#39;selectorParams&#39; is the serialisation of parameters needed to initialize the selector class in the order defined by the getParameters/setParameters functions    <br />
     *       <br />
     *        The obsels that don&#39;t match any selectors will be rendered with the default ObselSkin.<br />
     *    --&gt;        <br />
     *    &lt;obselsSelectors&gt;<br />
     *        &lt;obselSelector id=&#39;Message&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Document&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Document&quot; /&gt;    <br />
     *        &lt;obselSelector id=&#39;Instructions&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Marker&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Marker&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Keyword&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Keyword&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Comment&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,omment&quot; /&gt;<br />
     *    &lt;/obselsSelectors&gt;<br />
     *    <br />
     *    &lt;!-- the layout definition --&gt;<br />
     *    &lt;layout&gt;<br />
     *        &lt;!-- Default and only traceLineGroup definition. Each Trace will use this definition --&gt;<br />
     *        &lt;tlg &gt;            <br />
     *            &lt;!-- One traceLine with no selector (every obsel will match) --&gt;<br />
     *            &lt;tl /&gt;<br />
     *           <br />
     *            &lt;!-- there is no traceLine tagged with the &#39;preview&#39; attribute. Then, this Tracelinegroup preview (in the zoomContext part) is a traceline that renders the whole trace --&gt;<br />
     *        &lt;/tlg &gt;                <br />
     *    &lt;/layout&gt;<br />
     * &lt;/root&gt;           </p></listing>
     *
     * @example  A last version of mini layout. This one contains an ObselsSelectors section and uses a LayoutModifier to create Traceline
     * <listing version="3.0"> <p>
     * &lt;root&gt;<br />
     *    &lt;!-- A last version of mini layout. This one contains an ObselsSelectors section and uses a LayoutModifier to create Traceline --&gt;<br />
     *    <br />
     *    &lt;!-- The ObselsSelectors section defines selectors that are used to set a &#39;stylename&#39; to obselSkins which match.<br />
     *        This stylename can be used as obselSkins selectors in the CSS file<br />
     *        For example:<br />
     *            timeline|ObselSkin.Message<br />
     *            {<br />
     *            ...<br />
     *            }<br />
     *       <br />
     *        The &#39;selector&#39; attribute is the class name of a ISelector implementaion.<br />
     *        The &#39;selectorParams&#39; is the serialisation of parameters needed to initialize the selector class in the order defined by the getPrameters/setParameters functions    <br />
     *       <br />
     *        Obsels that don&#39;t match any selectors will be rendered with the default ObselSkin.<br />
     *    --&gt;        <br />
     *    &lt;obselsSelectors&gt;<br />
     *        &lt;obselSelector id=&#39;Message&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Document&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Document&quot; /&gt;    <br />
     *        &lt;obselSelector id=&#39;Instructions&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Marker&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Marker&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Keyword&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Keyword&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Comment&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,omment&quot; /&gt;<br />
     *    &lt;/obselsSelectors&gt;<br />
     *    <br />
     *    &lt;!-- the layout definition --&gt;<br />
     *    &lt;layout&gt;<br />
     *        &lt;!-- Default and only traceLineGroup definition. Each Trace will use this definition --&gt;<br />
     *        &lt;tlg &gt;            <br />
     *            &lt;!-- Instead of a static traceline, a LayoutModifier node could be used.<br />
     *                 Then, tracelines will be dynamicaly generated when needed.<br />
     *                 At the moment, the only implemented LayoutModifier is the splitter one that creates a new traceline for each value of the obsels property defined by the splitter attribute.<br />
     *                 <br />
     *                 In this example, a new traceline will be created for each different type of Obsel. (see obsel.type)<br />
     *            --&gt;<br />
     *            &lt;modifier splitter=&quot;type&quot; /&gt;                            <br />
     *           <br />
     *            &lt;!-- there is no traceLine tagged with the &#39;preview&#39; attribute. Then, this Tracelinegroup preview (in the zoomContext part) is a traceline that renders the whole trace --&gt;<br />
     *        &lt;/tlg &gt;                <br />
     *    &lt;/layout&gt;<br />
     * &lt;/root&gt;          </p></listing>
     *
     *
     *     @example   A basic layout definition of the old version of Visu2 with a static definition of the tree structure.
     * <listing version="3.0"> <p>
     * &lt;root&gt;<br />
     *    &lt;!-- A basic layout definition of the old version of Visu2 with a static definition of the tree structure.<br />
     *    We want something like that:<br />
     *        Summary view (according to user settings)<br />
     *            |____ Message<br />
     *            |____ Document<br />
     *            |____ Marker<br />
     *            |____ Instructions<br />
     *            |____ Keyword<br />
     *    --&gt;<br />
     *    <br />
     *    &lt;!-- The ObselsSelectors section --&gt;        <br />
     *    &lt;obselsSelectors&gt;<br />
     *        &lt;obselSelector id=&#39;Message&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Document&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Document&quot; /&gt;    <br />
     *        &lt;obselSelector id=&#39;Instructions&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Marker&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Marker&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Keyword&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Keyword&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Comment&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,omment&quot; /&gt;<br />
     *    &lt;/obselsSelectors&gt;<br />
     *    <br />
     *    &lt;!-- the layout definition --&gt;<br />
     *    &lt;layout&gt;        <br />
     *        &lt;tlg&gt;                                    <br />
     *            &lt;!-- Tracelines can create their own selector in the same way as in the obselsSelectors section<br />
     *                Note: this selector should be changed at runtime to let the user select what he wants<br />
     *                    =&gt;    traceline.selector = new SelectorRegexp(&quot;type,&quot; + listOfTypes);<br />
     *           <br />
     *            The &#39;title&#39; attribute defines the default traceline.title property and the traceline.name too. --&gt;            <br />
     *            &lt;tl title=&quot;Synthesis&quot;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message|Document|Marker|Instructions|Keyword&quot; &gt;                <br />
     *                &lt;!-- Tracelines can also use selector ID of already created obselSelector<br />
     *               <br />
     *                    Note: We cannot use a layoutModifier to split obsels by type because the Message selector, for example, select  obsels with the &#39;Message&#39; in the obsel.type string<br />
     *                    but SendMessage and ReceiveMessage types exist, then the splitter would create two differents Tracelines --&gt;            <br />
     *                &lt;tl title=&quot;Message&quot; selectorID=&quot;Message&quot; /&gt;<br />
     *                &lt;tl title=&quot;Document&quot; selectorID=&quot;Document&quot; /&gt;<br />
     *                &lt;tl title=&quot;Marker&quot; selectorID=&quot;Marker&quot;    /&gt;<br />
     *                &lt;tl title=&quot;Instructions&quot; selectorID=&quot;Instructions&quot;    /&gt;<br />
     *                &lt;tl title=&quot;Keyword&quot; selectorID=&quot;Keyword&quot; /&gt;                <br />
     *            &lt;/tl&gt;<br />
     *        &lt;/tlg&gt;        <br />
     *    &lt;/layout&gt;<br />
     * &lt;/root&gt;       </p></listing>
     *
     *     @example   An enhanced layout definition of the old version of Visu2.
     * <listing version="3.0"> <p>
     * &lt;root&gt;<br />
     *    &lt;!-- An enhanced layout definition of the old version of Visu2. (see classicVisu2Layout.xml)<br />
     *    <br />
     *    In this enhanced version, we create a special tracelinegroup for Comments<br />
     *    We add a traceline in the background of the users traceLineGroup<br />
     *    We change the default preview traceLine in the zoomContext (remember that if not defined the preview traceline is the whole trace)<br />
     *    And we use the autohide attribute to automaticlay hide or show a traceline when it is empty or not.<br />
     *    <br />
     *    We want something like that:<br />
     *    <br />
     *        Comments<br />
     *    <br />
     *        Summary view (according to user settings)<br />
     *            |____ Message<br />
     *            |____ Document<br />
     *            |____ Marker<br />
     *            |____ Instructions<br />
     *            |____ Keyword<br />
     *       <br />
     *        Summary view (according to user settings)<br />
     *            |____ Message<br />
     *            |____ Document<br />
     *            |____ Marker<br />
     *            |____ Instructions<br />
     *            |____ Keyword<br />
     *        (... for each user ...)<br />
     *    --&gt;<br />
     *    <br />
     *    &lt;!-- The ObselsSelectors section --&gt;        <br />
     *    &lt;obselsSelectors&gt;<br />
     *        &lt;obselSelector id=&#39;Message&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Document&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Document&quot; /&gt;    <br />
     *        &lt;obselSelector id=&#39;Instructions&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Marker&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Marker&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Keyword&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Keyword&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Comment&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,omment&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Activity&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,ActivityStart&quot; /&gt;<br />
     *    &lt;/obselsSelectors&gt;<br />
     *    <br />
     *    &lt;!-- the layout definition --&gt;<br />
     *    &lt;layout&gt;        <br />
     *        &lt;!-- This is the  TraceLineGroup definition used when the stylename of the TraceLineGroup is &quot;comments&quot;.<br />
     *            The stylename can be set when using the timeline.addTrace (trace, index, stylename) function.        <br />
     *           <br />
     *            Of course the stylename could be used to create a CSS selector:<br />
     *                timeline|TraceLineGroup.comments<br />
     *                {<br />
     *                    ....<br />
     *                }<br />
     *       <br />
     *            The other way to select a TraceLineGroup definition is to use the URI of the trace as the &#39;source&#39; attribute.<br />
     *            Example: To use a special definition when trace.uri is &#39;trace-20110112105114-0.ttl&#39;<br />
     *                &lt;tlg source=&quot;trace-20110112105114-0.ttl&quot; &gt;<br />
     *                    ... special tree structure...<br />
     *                &lt;/tlg&gt;            <br />
     *        --&gt;    <br />
     *        &lt;tlg stylename=&quot;comments&quot; &gt;    <br />
     *            &lt;!-- A &quot;stylename&quot; attribute in a TraceLine definition is also used to set the stylename and then to create a CSS selector. --&gt;<br />
     *            &lt;tl title=&quot;&quot; stylename=&quot;comments&quot;&gt;                        <br />
     *            &lt;/tl&gt;                        <br />
     *        &lt;/tlg&gt;    <br />
     *       <br />
     *        &lt;!-- This is the default TraceLineGroup definition because this is the last TraceLineGroup definition --&gt;<br />
     *        &lt;tlg&gt;<br />
     *            &lt;!--<br />
     *            The &#39;stylename=&quot;background&quot;&#39; attribute is used to define the traceline to be shown in the background of the traceLineGroup.<br />
     *            --&gt;<br />
     *            &lt;tl stylename=&quot;background&quot;    selectorID=&quot;Activity&quot; /&gt;<br />
     *           <br />
     *            &lt;!--<br />
     *            The &#39;preview=true&#39; attribute is used to define the previewed traceline in the zoomContext.<br />
     *            Note: if more than one traceline has a &#39;preview=true&#39; attribute, only the last one will be taken into account.<br />
     *            Note 2: if the wanted traceline does not exist in the tree structure, it can be created with a &#39;stylename=&quot;contextPreview&quot;&#39; attribute (in the same way of the background traceline)<br />
     *                example: &lt;tl stylename=&quot;contextPreview&quot; selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message|Document|Marker|Instructions|Keyword|Activity&quot; /&gt;<br />
     *            --&gt;            <br />
     *            &lt;tl title=&quot;Synthesis&quot;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message|Document|Marker|Instructions|Keyword&quot; &gt;                <br />
     *                &lt;!--<br />
     *                    the autohide=&#39;true&#39; attribute is used to automaticaly show/hide tracelines if the traceline is empty or not.<br />
     *                --&gt;            <br />
     *                &lt;tl title=&quot;Message&quot; selectorID=&quot;Message&quot;  autohide=&#39;true&#39;/&gt;<br />
     *                &lt;tl title=&quot;Document&quot; selectorID=&quot;Document&quot; autohide=&#39;true&#39;/&gt;<br />
     *                &lt;tl title=&quot;Marker&quot; selectorID=&quot;Marker&quot; autohide=&#39;true&#39;    /&gt;<br />
     *                &lt;tl title=&quot;Instructions&quot; selectorID=&quot;Instructions&quot;    autohide=&#39;true&#39; /&gt;<br />
     *                &lt;tl title=&quot;Keyword&quot; selectorID=&quot;Keyword&quot; autohide=&#39;true&#39; /&gt;                <br />
     *            &lt;/tl&gt;<br />
     *        &lt;/tlg&gt;        <br />
     *    &lt;/layout&gt;<br />
     * &lt;/root&gt;   </p></listing>
     *
     *     @example   New version of the Visu2 layout.
     * <listing version="3.0"> <p>
     * &lt;root&gt;<br />
     *    &lt;!-- The obselsSelectors section defines the selectors used to create ObselSkin CSS selectors to use different skins.--&gt;        <br />
     *    &lt;!-- The selectors defined in this section can also be used in the layout section as selector for Tracelines --&gt;        <br />
     *    &lt;obselsSelectors&gt;<br />
     *        &lt;obselSelector id=&#39;Message&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Message&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;PlayDocumentVideo&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,PlayDocumentVideo&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Document&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Document&quot; /&gt;    <br />
     *        &lt;obselSelector id=&#39;Instructions&#39;  selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Marker&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Marker&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Keyword&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Keyword&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Activity&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,ActivityStart&quot; /&gt;<br />
     *        &lt;obselSelector id=&#39;Comment&#39;       selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,omment&quot; /&gt;<br />
     *    &lt;/obselsSelectors&gt;<br />
     *    <br />
     *    &lt;!-- The layout section defines the tree structure of the timeline. --&gt;<br />
     *    &lt;layout&gt;<br />
     *        &lt;!-- This TracelineGroup definition is used when the stylename of the TracelineGroup is &#39;comments&#39;<br />
     *            (the stylename of TracelineGroup can be set when calling the timeline.addTrace(..) function.) --&gt;<br />
     *        &lt;!-- the stylename is used to create CSS selectors --&gt;<br />
     *        &lt;tlg stylename=&quot;comments&quot; &gt;                <br />
     *            &lt;tl title=&quot;&quot; stylename=&quot;comments&quot; preview=&quot;true&quot; &gt;        <br />
     *                &lt;!-- a layoutModifier is used to create one traceline by document (split when an obsel with new value obsel.props[&#39;commentforuserid&#39;] is added --&gt;<br />
     *                &lt;!-- the autohide attribute will set for each traceline created --&gt;<br />
     *                &lt;modifier name=&quot;commentsGenerator&quot; stylename=&quot;comments&quot; splitter=&quot;commentforuserid&quot; source=&quot;parent&quot; autohide=&quot;true&quot; /&gt;<br />
     *            &lt;/tl&gt;                        <br />
     *        &lt;/tlg&gt;    <br />
     *       <br />
     *        &lt;!--<br />
     *            The default tracelinegroup definition of this layout (because this is the last tracelinegroup definition.<br />
     *            Used for the traces of users.<br />
     *        --&gt;<br />
     *        &lt;tlg&gt;                <br />
     *            &lt;!-- definition of the traceline in the background of the tracelinegroup --&gt;<br />
     *            &lt;!-- the selector is already defined in the obselsSelectors setion --&gt;<br />
     *            &lt;tl stylename=&quot;background&quot;    selectorID=&quot;Activity&quot; /&gt;<br />
     * <br />
     *            &lt;!-- autohide=&#39;true&#39; is used to automaticaly hide or show the traceline when it is empty or not --&gt;<br />
     *            &lt;tl title=&quot;Marqueurs&quot; selectorID=&quot;Marker&quot; autohide=&quot;true&quot; /&gt;        <br />
     *           <br />
     *            &lt;!-- A new selector must be created --&gt;<br />
     *            &lt;tl title=&quot;Messages&quot; selector=&quot;SelectorRegexp&quot; selectorParams=&quot;type,Instructions|Keyword|Message&quot; autohide=&quot;true&quot;/&gt;<br />
     *           <br />
     *            &lt;tl title=&quot;Documents&quot; selectorID=&quot;Document&quot; autohide=&quot;true&quot;&gt;<br />
     *                &lt;!-- the selector is not for the classic &#39;type&#39; property but for &#39;typedocument&#39; --&gt;<br />
     *                &lt;tl title=&quot;Images&quot; selector=&quot;SelectorRegexp&quot; selectorParams=&quot;typedocument,image&quot; autohide=&quot;true&quot;&gt;<br />
     *                    &lt;!-- a layoutModifier is used to create one traceline by document (split when an obsel with new value obsel.props[&#39;iddocument&#39;] is added --&gt;<br />
     *                    &lt;!-- the autohide attribute will set for each traceline created --&gt;<br />
     *                    &lt;!-- the source attribute is set to &#39;parent&#39; to use the parent traceline (&#39;Images&#39;) as obsels source instead of the trace --&gt;<br />
     *                    &lt;modifier name=&quot;imagesGenerator&quot; splitter=&quot;iddocument&quot; source=&quot;parent&quot; autohide=&quot;true&quot; /&gt;<br />
     *                &lt;/tl&gt;<br />
     *                &lt;tl title=&quot;Videos&quot; selector=&quot;SelectorRegexp&quot; selectorParams=&quot;typedocument,video&quot; autohide=&quot;true&quot;&gt;<br />
     *                    &lt;modifier name=&quot;videosGenerator&quot; splitter=&quot;iddocument&quot; source=&quot;parent&quot; autohide=&quot;true&quot; /&gt;<br />
     *                &lt;/tl&gt;<br />
     *            &lt;/tl&gt;<br />
     *           <br />
     *            &lt;!-- Note: There is no preview attribute in this tracelinegroup, then the preview traceline is the not filtered whole trace --&gt;            <br />
     *           <br />
     *        &lt;/tlg&gt;<br />
     *    &lt;/layout&gt;<br />
     * &lt;/root&gt;       </p></listing>
     */
    public class Layout
    {
        /**
         * the keyword to define a TraceLineGroup in the xml descriptor
         */
        public static const TRACELINEGROUP: String = "tlg";
        /**
         * the keyword to define  a TraceLine in the xml descriptor
         */
        public static const TRACELINE: String = "tl";
        /**
         * the keyword to define  a ModifierNode in the xml descriptor
         */
        public static const MODIFIER: String = "modifier";
        /**
         * the keyword to define the root of  the xml document
         */
        public static const ROOT: String = "root";
        /**
         * the keyword to define the layout section in the xml descriptor
         */
        public static const LAYOUT: String = "layout";
        /**
         * the keyword to define the obsels skins selectors section in the xml descriptor
         */
        public static const OBSELS_SELECTORS: String = "obselsSelectors";
        /**
         * the keyword to define an obsel skin selector in the xml descriptor
         */
        public static const OBSELS_SELECTOR: String = "obselsSelector";
        /**
         * the stylename ('stylename' property) to indicate that a Traceline must be used as a TracelineGroup background traceline
         */
        public static const BACKGROUND_TRACELINE: String = "background";
        /**
         * the stylename ('stylename' property) to indicate that a Traceline must be used as a preview (in the zoomContext preview zone)
         */
        public static const CONTEXT_PREVIEW_TRACELINE: String = "contextPreview";

        /**
         * The timeline is the root of the tree structure (this is the timeline where the nodes will be created). The timeline also contains the xml descriptor (_timeline.layoutXML[LAYOUT])
         */
        public var _timeline: Timeline;

        /**
         * Constructor
         * @param tl The Timeline managed by the Layout class.
         */
        public function Layout(tl: Timeline)
        {
            _timeline = tl;
        }

        /**
         * Create a new TracelineGroup matching the given trace (URI)  or style.
         *
         * Select an XML descriptor of TraceLineGroup tree in the list
         * of descriptors stored in the <code>_timeline</code> and
         * create the tree structure.
         *
         * Select the first TraceLineGroup descriptor whose
         * property 'source' is equal to the URI of <code>trac</code>
         * or whose 'stylename' property is equal to the (optional)
         * <code>stylename</code> parameter.
         *
         * If no such descriptor exists, the last descriptor of the
         * list is used by default. // FIXME: or should we create a generic one?
         *
         * @param trac the Trace for which the tree is created
         * @param stylename an optional stylename used to select the TraceLineGroup definition in the xml descriptor.
         * @return the created TraceLineGroup tree
         */
        public function createTracelineGroupTree (trac: Trace, stylename: String = null): TraceLineGroup
        {
            var treeLayout: XML = new XML(TRACELINEGROUP);

            for each (var child: XML in _timeline.layoutXML[LAYOUT].children())
            {
                if ((child.hasOwnProperty('@stylename') && child.@stylename == stylename)
                    || (child.hasOwnProperty('@source') && child.@source == trac.uri))
                {
                    treeLayout = child;
                    break;
                }
                else
                    treeLayout = child;
            }

            return  createTree(treeLayout, trac) as TraceLineGroup;
        }


        /**
         * Create a TracelineGroupNode from a xml descriptor and a trace
         *
         * @param xmlLayout The XML descriptor of the TraceLineGroup
         * @param trac The trace used to create the TraceLineGroup
         * @return the TraceLineGroup node
         */
        public function createTraceLineGroupNode(xmlLayout: XML, trac: Trace): TraceLineGroup
        {
            var newNode: TraceLineGroup = new TraceLineGroup (_timeline, trac, xmlLayout.@title,
                                                              xmlLayout.hasOwnProperty('@stylename') ? xmlLayout.@stylename : null);
            newNode.layoutXML = xmlLayout;

            return newNode;
        }

        /**
         * Add a traceline as a child to a LayoutNode
         *
         * @param traceline The traceline to add
         * @param parentNode the LayoutNode where you want to add the traceline
         * @param xmlLayout
         * @return the traceline
         */
        public function addTraceline(traceline: TraceLine, parentNode: LayoutNode, xmlLayout: XML = null):  LayoutNode
        {
            parentNode.addChildAndTitle(traceline);
            if (_timeline.activity !== null)
                _timeline.activity.trace("AddTraceline", { traceline: traceline.title,
                                                           new_layout: getCurrentXmlLayout().toXMLString() });
            return traceline;
        }

        private function createSelector(xmlSelector: XML): ISelector
        {
            var tlSelector: ISelector;

            if (xmlSelector.hasOwnProperty('@selector'))
            {
                var selectorClass:Class;

                try
                {
                    selectorClass = getDefinitionByName(xmlSelector.@selector) as Class;
                }
                catch(error:ReferenceError)
                {
                    selectorClass = getDefinitionByName("com.ithaca.timeline::" + xmlSelector.@selector) as Class;
                }

                tlSelector = new selectorClass();

                if (xmlSelector.hasOwnProperty('@selectorParams'))
                {
                    tlSelector.setParameters(xmlSelector.@selectorParams);
                }
            }

            return tlSelector;
        }

        /**
         * Create a Traceline from an xml descriptor
         *
         * @param xmlLayout an xml descriptor of the traceline
         * @return the created traceline
         */
        public function createTraceLineNode(xmlLayout: XML): TraceLine
        {
            var newNode: TraceLine;
            var tlTitle: String;
            var tlName: String;
            var tlClass: String;
            var tlSelector: ISelector;
            var tlSource: String;

            if (xmlLayout.hasOwnProperty('@selectorID'))
            {
                for (var i: int = 0; i < _timeline.styleSheet.obselsSkinsSelectors.length; i++)
                {
                    if (_timeline.styleSheet.obselsSkinsSelectors[i].id == xmlLayout.@selectorID)
                    {
                        tlSelector = _timeline.styleSheet.obselsSkinsSelectors[i].selector;
                        tlTitle = _timeline.styleSheet.obselsSkinsSelectors[i].id;
                    }
                }

            }
            else if (xmlLayout.hasOwnProperty('@selector'))
            {
                tlSelector = createSelector(xmlLayout);
                tlTitle = xmlLayout.@selector;
            }

            if (xmlLayout.hasOwnProperty('@title'))
                tlTitle = xmlLayout.@title;
            if (xmlLayout.hasOwnProperty('@name'))
                tlTitle = xmlLayout.@name;
            if (xmlLayout.hasOwnProperty('@stylename'))
                tlClass = xmlLayout.@stylename;
            if (xmlLayout.hasOwnProperty('@source'))
                tlSource = xmlLayout.@source;

            newNode = new TraceLine(_timeline, tlTitle, tlName, tlSelector, tlSource, tlClass );

            if (xmlLayout.hasOwnProperty('@autohide') &&  xmlLayout.@autohide =='true')
                newNode.autohide = true;

            newNode.layoutXML = xmlLayout;

            return newNode;
        }

        /**
         * Create a LayoutModifier from an xml descriptor
         *
         * @param xmlLayout an xml descriptor of the LayoutModifier
         * @return the created LayoutModifier
         */
        public function createModifierNode(xmlLayout: XML): LayoutModifier
        {
            var newNode: LayoutModifier = new LayoutModifier (_timeline);
            newNode.layoutXML = xmlLayout;

            if (xmlLayout.hasOwnProperty('@splitter'))
                newNode._splitter =  xmlLayout.@splitter ;
            if (xmlLayout.hasOwnProperty('@source'))
                newNode.source = xmlLayout.@source;
            if (xmlLayout.hasOwnProperty('@autohide') &&  xmlLayout.@autohide =='true')
                newNode.autohide = true;
            if (xmlLayout.hasOwnProperty('@stylename'))
            {
                var stylename: String = xmlLayout.@stylename;
                newNode.styleName = stylename;
            }

            if (xmlLayout.hasOwnProperty('@name'))
            {
                var modName: String = xmlLayout.@name;
                newNode.name = modName;
            }

            return newNode;
        }

        /**
         * Create a tree structure of LayoutNode (TraceLineGroup,
         * Traceline, ModifierNode) from an xml descriptor and a
         * trace.
         *
         * This is a recursive method. It uses the
         * createTraceLineGroupNode, createTraceLineNode and
         * createModifierNode methods.
         *
         * @param xmlLayout the xml descriptor of the tree
         * @param trac the trace for which the tree is created
         * @return the root of the tree structure as a LayoutNode
         */
        public function createTree (xmlLayout: XML, trac: Trace): LayoutNode
        {
            var newNode: LayoutNode = null;

            switch(xmlLayout.localName())
            {
                case TRACELINEGROUP:
                    newNode = createTraceLineGroupNode(xmlLayout, trac);
                    break;

                case MODIFIER:
                    return createModifierNode(xmlLayout);

                case TRACELINE:
                    newNode = createTraceLineNode(xmlLayout);
                    break;

                default:
                    return null;
            }

            for each (var child: XML in xmlLayout.children())
            {
                var childTree: LayoutNode = createTree(child, trac);

                if (child.hasOwnProperty('@stylename') && child.@stylename == BACKGROUND_TRACELINE)
                {
                    if (newNode is TraceLineGroup)
                        (newNode as TraceLineGroup).backgroundTraceLine = childTree as TraceLine;
                }
                else
                {
                    if ((child.hasOwnProperty('@stylename') && child.@stylename == CONTEXT_PREVIEW_TRACELINE)
                        || (child.hasOwnProperty('@preview') && child.@preview == 'true' && newNode is TraceLineGroup))
                        (newNode as TraceLineGroup).contextPreviewTraceLine = childTree as TraceLine;

                    newNode.addChildAndTitle(childTree);
                }

                var collec: ArrayCollection;
                if (child.hasOwnProperty('@source') && child.@source == "parent")
                {
                    (newNode as TraceLine).sourceStr = xmlLayout.@source;
                    if (newNode is TraceLine)
                        collec = (newNode as TraceLine)._obsels;
                    else if (newNode is TraceLineGroup)
                        collec = (newNode as TraceLineGroup).trace.obsels;
                }
                else
                    collec  = trac.obsels;

                collec.addEventListener(CollectionEvent.COLLECTION_CHANGE, childTree.onSourceChange);
                childTree.resetObselCollection(collec);
            }

            return newNode;
        }

        /**
         * Get the current XML Layout
         *
         * @return the xml descriptor of the current tree structure
         */
        public function getCurrentXmlLayout (): XML
        {
            var currentXmlLayout: XML = < {ROOT} />;

            currentXmlLayout.appendChild(layoutTreeToXml());
            currentXmlLayout.appendChild(obselsSelectorsToXml());

            return currentXmlLayout;
        }

        /**
         * Load a set of obsels skins selectors from a XML descriptor. It overwrites the current set if one exists.
         *
         * @param xmlSelectors xml descriptor of a set of obsels skins selectors
         */
        public function loadObselsSelectors(xmlSelectors: XMLList): void
        {
            _timeline.styleSheet.obselsSkinsSelectors = new Array();
            for each (var selector: XML in xmlSelectors.children())
            {
                if (selector.hasOwnProperty('@selector'))
                {
                    var obselSelector: ISelector     = createSelector(selector);
                    if (selector.hasOwnProperty('@id'))
                    {
                        var selectorId: String = selector.@id;
                        _timeline.styleSheet.obselsSkinsSelectors.push({ id:selectorId, selector:obselSelector });
                    }
                }
            }
        }

        /**
         * @return  the XML descriptor of the current timeline set of obsels skins selectors.
         */
        protected function obselsSelectorsToXml (): XML
        {
            var xmlTree: XML = <{OBSELS_SELECTORS} />;

            if (_timeline.styleSheet && _timeline.styleSheet.obselsSkinsSelectors)
                for each (var selector: Object in _timeline.styleSheet.obselsSkinsSelectors)
                {
                    var xmlSelector: XML = <{OBSELS_SELECTOR} />;

                    if (selector.id)
                        xmlSelector.@['id'] = selector.id;

                    if  (selector.selector)
                    {
                        xmlSelector.@['selector'] = getQualifiedClassName(selector.selector);
                        xmlSelector.@['selectorParams'] = selector.selector.getParameters();
                    }
                    xmlTree.appendChild(xmlSelector);
                }

            return xmlTree;
        }

        /**
         * @return  the XML descriptor of the current timeline tree structure.
         */
        protected function layoutTreeToXml (): XML
        {
            var xmlTree: XML = <{LAYOUT} />;
            var sourceList: ArrayCollection = new ArrayCollection();

            for (var tlgIndex: uint = 0; tlgIndex < _timeline.numElements; tlgIndex++)
            {
                var tlg: TraceLineGroup = _timeline.getElementAt(tlgIndex) as TraceLineGroup;
                if (tlg && sourceList.getItemIndex(tlg.trace.uri) < 0)
                {
                    sourceList.addItem(tlg.trace.uri)
                    var xmlTlg: XML = < {TRACELINEGROUP} />;
                    xmlTlg.@['source'] = tlg.trace.uri;
                    if (tlg.styleName)
                        xmlTlg.@['stylename'] = tlg.styleName;

                    if (tlg.title)
                        xmlTlg.@['title'] = tlg.title;

                    if (tlg.backgroundTraceLine)
                        xmlTlg.appendChild(tracelineTreeToXml(tlg.backgroundTraceLine));

                    for (var tlIndex: uint = 0; tlIndex < tlg.numElements; tlIndex++)
                    {
                        var layoutNode: LayoutNode = tlg.getElementAt(tlIndex) as LayoutNode;

                        if (layoutNode is TraceLine)
                            xmlTlg.appendChild(tracelineTreeToXml(layoutNode as TraceLine));
                        else if (layoutNode is LayoutModifier)
                            xmlTlg.appendChild(modifierTreeToXml(layoutNode as LayoutModifier));
                    }

                    xmlTree.appendChild(xmlTlg);
                }
            }

            for each (var child: XML in _timeline.layoutXML[LAYOUT].children())
            {
                if (!child.hasOwnProperty('source') || xmlTree[LAYOUT][TRACELINEGROUP][@['source']== child.@['source']] != null)
                    xmlTree.appendChild(child);
            }
            return xmlTree;
        }

        /**
         * @param tl a traceline tree
         * @return the xml descriptor of a given traceline tree structure.
         */
        protected function tracelineTreeToXml (tl: TraceLine): XML
        {
            var xmlTl: XML = <{TRACELINE} />;
            if (tl.sourceStr)
                xmlTl.@['source'] = tl.sourceStr;
            if (tl.styleName)
                xmlTl.@['stylename'] = tl.styleName;
            if (tl.title)
                xmlTl.@['title'] = tl.title;
            if (tl.autohide)
                xmlTl.@['autohide'] = tl.autohide;
            if (tl.isOpen())
                xmlTl.@['expanded'] = "";

            if  (tl.selector)
            {
                xmlTl.@['selector'] = getQualifiedClassName(tl.selector);
                xmlTl.@['selectorParams'] = tl.selector.getParameters();
            }

            for (var tlIndex: uint = 0; tlIndex < tl.numElements; tlIndex++)
            {
                var layoutNode: LayoutNode = tl.getElementAt(tlIndex) as LayoutNode;

                if (layoutNode is TraceLine)
                    xmlTl.appendChild(tracelineTreeToXml(layoutNode as TraceLine));
                else if (layoutNode is LayoutModifier)
                    xmlTl.appendChild(modifierTreeToXml(layoutNode as LayoutModifier));
            }

            return xmlTl;
        }

        /**
         * @param tl a modifier tree
         * @return the xml descriptor of a given modifier tree structure.
         */
        protected function modifierTreeToXml (modifier: LayoutModifier): XML
        {
            var xmlModifier: XML = <{MODIFIER} />;

            if (modifier.source)
                xmlModifier.@['source'] = modifier.source;
            if (modifier.styleName)
                xmlModifier.@['stylename'] = modifier.styleName;
            if (modifier.name)
                xmlModifier.@['name'] = modifier.name;
            if (modifier._splitter)
                xmlModifier.@['splitter'] = modifier._splitter;

            for (var tlIndex: uint = 0; tlIndex < modifier.numElements; tlIndex++)
            {
                var layoutNode: LayoutNode = modifier.getElementAt(tlIndex) as LayoutNode;

                if (layoutNode is TraceLine)
                    xmlModifier.appendChild(tracelineTreeToXml(layoutNode as TraceLine));
                else if (layoutNode is LayoutModifier)
                    xmlModifier.appendChild(modifierTreeToXml(layoutNode as LayoutModifier));
            }

            return xmlModifier;
        }
    }
}
