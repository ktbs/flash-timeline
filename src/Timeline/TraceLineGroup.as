package Timeline
{
	import com.ithaca.traces.Trace;

	public class TraceLineGroup
	{
		var _trace : Trace;
		var _traceLines : Array;
		
		public function TraceLineGroup()
		{
		}
		
		
		public function onTraceChange () : void ;
		
		public function getTraceline( obsel : Obsel ) :  TraceLine ;
	}
}