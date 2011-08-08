package com.ithaca.timeline
{	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class TraceLineGroupTitle  extends SkinnableContainer
	{
		public var tlg 		: TraceLineGroup;
				
		public function TraceLineGroupTitle( value : TraceLineGroup) : void
		{
			tlg = value;
		}	
	}
}