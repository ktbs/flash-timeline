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
		
		[Embed("images/motCleVisu1.png")]
		private var keywordIconVisu1:Class;
			
		[Embed("images/chatMessageVisu1.png")]
		private var messageChatIconVisu1:Class;

		[Embed("images/consigneVisu1.png")]
		private var consigneIconVisu1:Class;

		[Embed("images/fichierVisu1.png")]
		private var fichierIconVisu1:Class;
		
		public function Stylesheet()
		{
		}	
		 
		// Display
		public function getParameteredSkin( obsel : Obsel, traceline : TraceLine ) :  ObselSkin 
		{ 	
			var obselSkin : ObselSkin;
			obselSkin = new ObselSkin();
			obselSkin.obsel = obsel;
			obselSkin.setStyle("skinClass", Class(IconSkin));
			obselSkin.addEventListener("creationComplete", initIconSkin );
			
			return obselSkin;
		}
				
		public function  initIconSkin( event : Event ) : void
		{
			var obsel 		: Obsel 	= (event.currentTarget as ObselSkin).obsel;
			var obselSkin 	: IconSkin  = ((event.currentTarget as ObselSkin).skin as IconSkin);
			
			if ( new RegExp( "Message" ).test(obsel.type) )
				obselSkin.icon.source	 	= messageChatIconVisu1;
			else if ( new RegExp( "Document" ).test(obsel.type) )
				obselSkin.icon.source 		= fichierIconVisu1;
			else if ( new RegExp( "Instructions" ).test(obsel.type) )
				obselSkin.icon.source 		= consigneIconVisu1;
			else if ( new RegExp( "Keyword" ).test(obsel.type) )
				obselSkin.icon.source 		= keywordIconVisu1;	
			 
		};
		
		static public function getTracelineGroupColor( tlg : TraceLineGroup ) : uint
		{
			var fillColors : Array = tlg.getStyle( "fillColors" ) as Array;	
			if (!fillColors)
				fillColors = TlgDefaultFillColors;
				
			return fillColors[ Math.floor( Math.random() * fillColors.length ) ] ;
		}
		
	}
}