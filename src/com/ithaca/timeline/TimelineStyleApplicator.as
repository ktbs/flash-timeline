/*
 * Style applicator for Timeline components.
 */
package com.ithaca.timeline
{
    import mx.events.PropertyChangeEvent;
    import com.flashartofwar.fcss.applicators.AbstractApplicator;

    public class TimelineStyleApplicator extends AbstractApplicator
    {

        public function TimelineStyleApplicator()
        {
            super(this);
        }

        /*
         * Apply the given style object (IStyleSheet) to the specified target.
         */
        override public function applyStyle(target: Object, style: Object): void
        {
            if (style['styleName'] != 'EmptyStyle') {
                // trace("Applying style " , style, " to ", target);
                for (var prop: String in style)
                {
                    var oldValue: *;
                    var value: * = style[prop];

                    if (prop == 'styleName')
                        continue;
                    oldValue = target.getStyle(prop);
                    /* Hard-coded string conversion.
                     * FIXME: to do things properly, we should use 
                     * fcss TypeCheckerUtil.getType
                     */
                    if (value === "true")
                        value = true;
                    else if (value === "false")
                        value = false;
                    else if (value === "undefined")
                        value = undefined;

                    if (prop == 'skinName')
                        prop = 'styleName';

                    //trace("Applying prop", prop, "to target", target, "(from:", oldValue, "to:", style[prop], ")");
                    if (value !== undefined && (oldValue != value))
                    {
                        /* The style is different. Update it. */

                        /* FIXME: check against the type (String, Number, Class...) */

                        /* FIXME: for the moment, we use common CSS
                         * syntax, i.e. strings are not surrounded by
                         * quotes.  However, the default.css Flex
                         * syntax uses different notations. Maybe we
                         * should try to accomodate both here
                         * (automatically strip ").
                         */
                        target.setStyle(prop, value);
                    }
                }
            }
        }
    }

}
