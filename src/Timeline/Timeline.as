package Timeline
{
	import com.ithaca.traces.Trace;

	public class Timeline
	{
		private var _styleSheet : Stylesheet;
		
		public function Timeline()
		{
		}
		
		public function get styleSheet() : Stylesheet { return _styleSheet; }
		public function set styleSheet( value:Stylesheet ):void { _styleSheet = value; }
		
		public function addTrace( trace : Trace ) : void ;
		public function removeTrace( trace : Trace ) : void ;

	}
}