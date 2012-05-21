package com.ithaca.timeline
{
    import com.ithaca.timeline.ObselSkin;
    import com.ithaca.timeline.skins.IconSkin;
    import com.ithaca.timeline.TraceLineGroup;
    import flash.events.Event;
    import mx.events.FlexEvent;

    import com.ithaca.traces.Obsel;

    /**
     * Created to manage colors, obsels skins and other CSS like
     * properties but not really used ; this should be merged with the
     * Layout class, but will not affect the functionalities.
     *
     * There are 2 kinds of StyleSheets (in the CSS meaning) in the
     * Flash timeline code. There is a default.css stylesheet in
     * actionscript-specific CSS variant (it can use ClassReference()
     * or Embed() directivces). It is compiled with the component, and
     * may be overridden by applications.  However, since it needs to
     * be compiled, it is not advised to use it at user-level.
     * 
     * The other kind of CSS stylesheets, named "dynamic stylesheets"
     * in this project, are dynamically parsed at runtime: they can be
     * stored on any server or even specified at runtime through
     * strings. They are more flexible.
     *
     * <strong>CSS selectors in dynamic CSS</strong<
     * 
     * Selectors can be used to select various elements.  The element
     * name (<em>Timeline</em>, <em>TraceLineGroup</em>,
     * <em>TraceLine</em>, <em>Obsel</em>) is used as first
     * selector. When applicable (i.e. for everything except the
     * Timeline), the element name can be followed by an identifier
     * that allows to more precisely specify the targeted element,
     * using the names defined in the Layout (names are basically
     * mapped as HTML classes selectors).
     * 
     * @example To specify the TraceLine named User, one specifies
     * <listing version="3.0"> <p>
     * TraceLine.User {
     *   bgColor: red;
     * }
     * </p></listing>
     * 
     * Names are inherited: if one wants to select obsels from a
     * TraceLineGroup named <em>Foobar</em>, one can use
     * <listing version="3.0"> <p>
     * Obsel.Foobar {
     *   icon: user.png;
     * }
     * </p></listing>
     *
     * <strong>Specifying skin classes</strong>
     * 
     * Some root CSS classes are defined in the default.css file. They
     * are the following: Icon, Durative, Marker, Comment.
     * 
     * These root classes, defining the skin to be used, can be
     * referenced in dynamic stylesheets through the <em>skinName</em>
     * property.
     *
     * @example For instance, to specify that obsels of the class Foobar must
     * use a Durative skin, one writes in a dynamic CSS file:
     * <listing version="3.0"> <p>
     * Obsel.Foobar {
     *   skinName: Durative;
     * }
     * </p></listing>
     *
     * <strong>Using TALES syntax</strong>
     *
     * Most CSS properties (icon, tooltip, etc) may be defined using
     * an interpreted TALES string. If the property value contains a $
     * sign, then it will be evaluated as a TALES string.
     * 
     * Available root elements are <em>obsel</em> (referencing the
     * obsel against which the expression is evaluated) and
     * <em>trace</em> (referencing its trace).
     *
     * @example To specify a tooltip combining 2 obsel properties, and an icon using a property name as icon name, one specifies:
     * <listing version="3.0"> <p>
     * Obsel.Example {
     *   tooltip: $(obsel/props/foo) combined with $(obsel/props/bar);
     *   icon: images/$(obsel/props/name).png;
     * }
     * </p></listing>
     * 
     * @see Layout
     */
    public class Stylesheet
    {
        static private var tracelineGroupColorIndex: uint = 0;
        static public var ZoomContextInitPercentWidth: Number = 30;
        static public var renderersSidePadding: Number = 25;

        public var obselsSkinsSelectors: Array = new Array();

        public function Stylesheet()
        {
        }

        /**
         * Create a ObselSkin from an Obsel and set a stylename according to the obselsSkinsSelectors array defined in the XML timeline descriptor.
         * @param    obsel The obsel to render
         * @param    traceline The traceline that contains the Obsel
         * @return an ObselSkin
         */
        public function getParameteredSkin(obsel: Obsel, traceline: TraceLine): ObselSkin
        {
            var obselSkin: ObselSkin = new ObselSkin(obsel, traceline);
            for each (var item: Object in obselsSkinsSelectors)
                if ((item.selector as ISelector).isObselMatching(obsel))
                {
                    obselSkin.styleName = item.id;
                    break;
                }

            return obselSkin;
        }

        /**
         * Select a color in the "fillColors" array of the TraceLineGroups
         * @param    tlg A TraceLineGroup
         * @return the selected color
         */
        static public function getTracelineGroupColor(tlg: TraceLineGroup): uint
        {
            var fillColors: Array = tlg.getStyle("fillColors") as Array;
            return fillColors[tracelineGroupColorIndex++ % fillColors.length];
        }

    }
}
