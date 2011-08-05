package com.ithaca.timeline
{
	import spark.components.supportClasses.SkinnableComponent;
	import com.ithaca.traces.Obsel;
	
	public class ObselSkin extends SkinnableComponent
	{
		public function ObselSkin()
		{
			super();
		}
		
		public var obsel : Obsel;
		
		// Update the obsel values in the trace
		protected function UpdateObsel () : void {};
	}
}