package com.ithaca.timeline
{
	import com.ithaca.timeline.ObselSkin;
	import com.ithaca.timeline.skins.IconSkin;
	import com.ithaca.timeline.TraceLineGroup;
	import flash.events.Event;
	import mx.events.FlexEvent;
	
	import com.ithaca.traces.Obsel;

	/**
	 * Created to manage colors, obsels skins and other CSS like properties but not really used ; should be merged with the Layout class.
	 * 
	 * @see Layout
	 */
	public class Stylesheet
	{
		static private var tracelineGroupColorIndex : uint = 0;
		static public var ZoomContextInitPercentWidth : Number = 30;
		static public var renderersSidePadding : Number = 25;
		
		public var obselsSkinsSelectors : Array = new Array();
		
		public function Stylesheet()
		{
		}	
		 		
		/**
		 * Create a ObselSkin from an Obsel and set a stylename according to the obselsSkinsSelectors array defined in the XML timeline descriptor.
		 * @param	obsel The obsel to render
		 * @param	traceline The traceline that's contained the Obsel
		 * @return an ObselSkin
		 */
		public function getParameteredSkin( obsel : Obsel, traceline : TraceLine ) :  ObselSkin 
		{ 	
			var obselSkin : ObselSkin = new ObselSkin( obsel, traceline );			
			for each ( var item : Object in obselsSkinsSelectors )
				if ( (item.selector as ISelector).isObselMatching( obsel ) )
				{
					obselSkin.styleName = item.id;			
					break;
				}
				
			return obselSkin;
		}
		
		/**
		 * Select a color in the "fillColors" array of the TraceLineGroups
		 * @param	tlg A TraceLineGroup
		 * @return the selected color
		 */
		static public function getTracelineGroupColor( tlg : TraceLineGroup ) : uint
		{
			var fillColors : Array = tlg.getStyle( "fillColors" ) as Array;	
			return fillColors[ tracelineGroupColorIndex++ % fillColors.length ] ;
		}		
		
	}
}