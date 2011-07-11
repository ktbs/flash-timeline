package com.ithaca.timeline 
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Divider extends SkinnableComponent
	{
		[Bindable]
		public var leftMinSize : Number =0;
		[Bindable]
		public var rightMinSize : Number = 0;
		
		public function Divider() 
		{
		}
	}

}