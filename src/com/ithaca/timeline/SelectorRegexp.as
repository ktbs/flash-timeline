package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;

	public class SelectorRegexp implements ISelector
	{
		private var _regexp : RegExp;
		public var field : String = ""; 
		
		public function SelectorRegexp( regexp : String = null, obselField : String = "")
		{
			_regexp = new RegExp( regexp );
			this.field = obselField;
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
	}
}