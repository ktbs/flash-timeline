package com.ithaca.timeline
{
	import com.ithaca.traces.Obsel;

	public interface ISelector
	{
		function isObselMatching( obsel : Obsel ) : Boolean ;
		function getMatchingObsels ( obselsArray : Array ) : Array ; 
		function isEqual (selector : ISelector  ) : Boolean ;
	}
}