package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;

	public class selectorRegexp implements ISelector
	{
		private var _regexp : RegExp;
		public var field : String = ""; 
		
		public function selectorRegexp( regexp : String = null, obselField : String = "")
		{
			_regexp = new RegExp( regexp );
			this.field = obselField;
		}
	
		public function set regexp(value:String):void
		{
			_regexp = new RegExp( value );
		}

		public function getValidObsels(obselsArray:Array):Array
		{
			return null;
		}
		
		public function isObselValid(obsel:Obsel):Boolean
		{
			return _regexp.test( obsel[field] );
		}
		
	}
}