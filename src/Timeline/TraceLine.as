package Timeline
{
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;

	public class TraceLine
	{
		var _selector : Selector;
		var _children : ArrayCollection;
		
		public function TraceLine()
		{
		}
		
		public function addObsel ( obsel : Obsel ) : void ;
		
		public function removeObsel ( obsel : Obsel ) : void ;
	}
}