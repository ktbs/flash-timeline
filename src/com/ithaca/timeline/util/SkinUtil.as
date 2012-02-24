package com.ithaca.timeline.util
{
    import com.ithaca.traces.Obsel;
    import com.ithaca.tales.Context;

    public class SkinUtil {
        public static function interpretStyle(obsel: Obsel, st: *): *
        {
            var result: * = st;

            if (st is String && st.indexOf('$') > -1)
            {
                var ctx: Context = new Context(obsel);
                // Expression, with probably a TALES expression embedded
                ctx.locals['obsel'] = obsel;
                ctx.locals['trace'] = obsel.trace;
                result = ctx.evaluate("string:" + st);
            }
            return result;
        }
    }
}
