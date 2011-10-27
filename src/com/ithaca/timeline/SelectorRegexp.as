package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	
	/**
	 * The SelectorRegexp class implements the ISelector interface. It is defined by two properties : field (first parameter in the xml definition) and _regexp (second parameter). 
	 * The selector checks if the obsel property named 'field' is matching the regular expression defined by '_regexp'.
	 * 
	 * @see ISelector
	 */
	public class SelectorRegexp implements ISelector
	{
		private var _regexp : RegExp;
		
		public var field : String = ""; 
				
		public function SelectorRegexp(  params : Array = null ) 
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
		
		public function getParameters() : Array
		{
			return [ field, regexp ];
		}
		
		public function setParameters( params : Array) : void
		{
			this.field = params[0];
			_regexp = new RegExp( params[1] );			
		}
	}
}