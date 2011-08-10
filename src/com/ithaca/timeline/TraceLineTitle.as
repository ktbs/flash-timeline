package com.ithaca.timeline
{
	import mx.controls.Spacer;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;

	public class TraceLineTitle  extends SkinnableContainer
	{
		public var tl		: TraceLine
		[SkinPart(required="true")]
		public var hierarchicalSpacer : Spacer;
				
		public function TraceLineTitle( value : TraceLine) : void
		{
			tl = value;
		}	
		
		public function updateDisplayLevel():void
		{
			var node			: LayoutNode = tl;
			var displayLevel 	: Number 	= -1;
			while (node && !(node is TraceLineGroup))
			{
				node = node.parentNode;
				displayLevel++;
			}
			if (!node)
				displayLevel = 0;
			hierarchicalSpacer.width = 15 * displayLevel;
		}
	}
}