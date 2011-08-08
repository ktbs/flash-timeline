package com.ithaca.timeline
{
	import com.ithaca.timeline.ObselSkin;
	import com.ithaca.timeline.skins.IconSkin;
	import com.ithaca.timeline.TraceLineGroup;
	import flash.events.Event;
	import mx.events.FlexEvent;
	
	import com.ithaca.traces.Obsel;

	public class Stylesheet
	{		
		static public var ZoomContextInitPercentWidth : Number = 30;
		static public var TlgDefaultFillColors : Array = [ 0xFFFFFF ];
		
		static public var obselsSkinsSelectors : Array = [  { id : 'Message' , 		selector : new SelectorRegexp('Message','type') },
															{ id : 'Document' ,  	selector : new SelectorRegexp('Document','type')},
															{ id : 'Instructions' ,	selector : new SelectorRegexp('Instructions','type')},
															{ id : 'Keyword' , 		selector : new SelectorRegexp('Keyword','type')} ];
		
		public function Stylesheet()
		{
		}	
		 		
		public function getParameteredSkin( obsel : Obsel, traceline : TraceLine ) :  ObselSkin 
		{ 	
			var obselSkin : ObselSkin = new ObselSkin();
			obselSkin.obsel = obsel;
			for each ( var item : Object in obselsSkinsSelectors )
				if ( (item.selector as ISelector).isObselMatching( obsel ) )
					obselSkin.styleName = item.id;			
			
			if ( obselSkin.styleName )
				return obselSkin;
			else
				return null;
		}
		
		static public function getTracelineGroupColor( tlg : TraceLineGroup ) : uint
		{
			var fillColors : Array = tlg.getStyle( "fillColors" ) as Array;	
			if (!fillColors)
				fillColors = TlgDefaultFillColors;
				
			return fillColors[ Math.floor( Math.random() * fillColors.length ) ] ;
		}
		
	}
}