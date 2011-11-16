package com.ithaca.timeline
{	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * The TraceLineGroupTitle component is the title part of TraceLineGroup.
	 *
	 * <p> This title component is skinnable in order to allow to put it outside of the TraceLineGroup</p>
	 * <p> It extends SkinnableContainer because it contains the TraceLineTitles of the TraceLineGroup children.</p>
	 */
	public class TraceLineGroupTitle  extends SkinnableContainer
	{
		/**
		 * The TraceLineGroup for which this component is the title
		 */
		public var tlg 		: TraceLineGroup;
				
		/**
		 * Constructor
		 * @param	value The TraceLineGroup for which this component is the title
		 */
		public function TraceLineGroupTitle( value : TraceLineGroup) : void
		{
			tlg = value;
		}	
	}
}