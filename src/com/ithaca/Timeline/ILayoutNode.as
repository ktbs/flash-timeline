package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	
	import mx.collections.ArrayCollection;
	
	public interface ILayoutNode
	{
		function get children ( ) : ArrayCollection;
		
		function set layout ( layoutXML : XML ) : void;
		function get layout (  ) : XML;
		
		function acceptObsel ( obsel : Obsel ) : Boolean ;
		function splitBy ( ) : String ;
	}
}