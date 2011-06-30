package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;

	public interface ISelector
	{
		function isObselValid( obsel : Obsel ) : Boolean ;
		function getValidObsels ( obselsArray : Array ) : Array ; 
	}
}