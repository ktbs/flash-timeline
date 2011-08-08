package com.ithaca.timeline
{
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;

	public class TraceLineTitle  extends SkinnableContainer
	{
		public var tl		: TraceLine
				
		public function TraceLineTitle( value : TraceLine) : void
		{
			tl = value;
		}	
	}
}