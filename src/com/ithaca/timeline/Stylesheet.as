package com.ithaca.timeline
{
	import com.ithaca.timeline.skins.ObselSkin;
	import com.ithaca.timeline.TraceLineGroup;
	
	import com.ithaca.traces.Obsel;

	public class Stylesheet
	{		
		static public var ZoomContextInitPercentWidth : Number = 30;
		static public var TlgDefaultFillColors : Array = [ 0xFFFFFF ];
		
		public function Stylesheet()
		{
		}	
		 
		// Display
		public function getParameteredSkin( obsel : Obsel, traceline : TraceLine ) :  ObselSkin { return null; };
		
		static public function getTracelineGroupColor( tlg : TraceLineGroup ) : uint
		{
			var fillColors : Array = tlg.getStyle( "fillColors" ) as Array;	
			if (!fillColors)
				fillColors = TlgDefaultFillColors;
				
			return fillColors[ Math.floor( Math.random() * fillColors.length ) ] ;
		}
		
	}
}