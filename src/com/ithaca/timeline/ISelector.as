package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;
	
	/**
	 * <p>The ISelector interface is implemented by classes that are used to select obsels ( Tracelines have an ISelector properties for example ).</p>
	 * 	 
	 * @see SelectorRegexp
	 */
	public interface ISelector
	{
		/**
		 * Test if an obsel match the selector
		 * @param  obsel The obsel to test
		 * @return true if the obsel is matching, false otherwise.
		 */		
		function isObselMatching( obsel : Obsel ) : Boolean ;		
				
		/**
		 * Select the matching set of obsel from an array of obsels
		 * @param	obselsArray the array of obsels to test
		 * @return	the array of matching obsels
		 */
		function getMatchingObsels ( obselsArray : Array ) : Array ; 
		
		/**
		 * Test if another ISelector is the same of this one.
		 * <p>This function is used to test if a selector has already been created by a LayoutModifier in order to know if a new traceline need to be created.</p>
		 * 
		 * @see LayoutModifier
		 * 
		 * @param selector the selector to test
		 * @return true if equal, else return false
		 */
		function isEqual (selector : ISelector  ) : Boolean ;
		
		
		/**
		 * This function return the array of parameters needed to define the Selector.
		 * 
		 * <p> It is used to save the current layout in an xml descriptor.</p>
		 * 		 
		 * @return the parameters of the selectors in the same order as the argument of the setParameters method.
		 * 
		 * @see #setParameters
		 */
		function getParameters() : Array;
		
		/**
		 * Change the parameters of the selector.
		 * 
		 * @param parameters The array of parameters in the same order as the array returned by the getParameters method.
		 * 
		 * @see #getParameters
		 */
		function setParameters(parameters : Array) : void;
	}
}