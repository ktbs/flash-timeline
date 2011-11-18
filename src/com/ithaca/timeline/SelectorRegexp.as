package com.ithaca.timeline
{
    import com.ithaca.traces.Obsel;
    
    /**
     * The SelectorRegexp class implements the ISelector interface. It
     * is defined by two properties : field and _regexp.
     *
     * The selector checks if the obsel property named 'field' is matching the regular expression defined by '_regexp'.
     *
     * @see ISelector
     */
    public class SelectorRegexp implements ISelector
    {
        private var _regexp : RegExp;
        
        public var field : String = "";
      
        /**
         * Instanciate a new SelectorRegexp
         *
         * The parameters syntax is a comma-separated list with two
         * elements: field and regexp.
         *
         * For instance, "type,Message" matches all obsels whose type
         * attribute contains the string "Message".
         *
         */
        public function SelectorRegexp(  params : String = null )
        {
            if (params)
                setParameters( params );
        }
        
        public function set regexp(value:String):void
        {
            _regexp = new RegExp( value );
        }
        
        public function get regexp( ):String
        {
            return _regexp.source;
        }

        public function getMatchingObsels(obselsArray:Array):Array
        {
            return null;
        }
        
        public function isObselMatching(obsel:Obsel):Boolean
        {    
            if ( obsel.hasOwnProperty( field ) )
                return _regexp.test( obsel[field] );
            else
                return _regexp.test( obsel.props[field] );
        }
        
        public function isEqual( selector : ISelector) : Boolean
        {
            if (selector is SelectorRegexp)
            {
                return ( (selector as SelectorRegexp).field == field)
                        && ( (selector as SelectorRegexp)._regexp.source == _regexp.source );
            }
            return false
        }
        
        public function getParameters() : String
        {
            return field + "," + regexp;
        }
        
        public function setParameters( params : String) : void
        {
            var arr     : Array = params.split(',');

            this.field = arr[0];
            _regexp = new RegExp( arr[1] );
        }
    }
}