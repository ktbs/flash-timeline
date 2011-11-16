package com.ithaca.timeline
{
	import mx.controls.Spacer;
	import mx.core.UIComponent;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;

	/**
	 * The TraceLineTitle component is the title part of traceline. 
	 * 
	 * <p> This title component is skinnable in order to allow to put it outside of the TraceLineGroup</p>
	 * <p> It extends SkinnableContainer because it contains the TraceLineTitles of the Traceline children.</p>
	 */
	public class TraceLineTitle  extends SkinnableContainer
	{
		/**
		 * The traceline for which this component is the title
		 */
		public var tl		: TraceLine
		
		
		[SkinPart(required="true")]
		/**
		 * Used to represent the hierarchical level of the traceline in the tree structure.
		 */
		public var hierarchicalSpacer : Spacer;
		
		/**
		 * Button used to show or hide the traceline children.
		 */
		[SkinPart(required="true")]
		public var OpenButton : UIComponent;

		/**
		 * Constructor
		 * @param	value The TraceLine for which this component is the title
		 */
		public function TraceLineTitle( value : TraceLine) : void
		{
			tl = value;
		}	
		
		/**
		 * Used to update the offset of the traceline title to represent the hierarchical level of the traceline in the tree structure.
		 */
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