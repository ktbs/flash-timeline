package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import mx.collections.ArrayCollection;	

	public class TraceLine
	{
		// tmp Debug
		static public var 	traceLineTmp : ArrayCollection = new ArrayCollection(); //temporaire pour debug
		public static var index : Number = 0;
		public var uid : Number;
		
		public var title : String;
		public var _selector : ISelector;
		public var _obsels 	: ArrayCollection = new ArrayCollection();
				
		public function TraceLine()
		{		
			uid = index;
			traceLineTmp.addItemAt( this , index++ );
		}
		
		public function acceptObsel ( obsel : Obsel ) : Boolean
		{
			return ( !_selector || _selector.isObselMatching( obsel ) ); 
		}
		
		public function addObsel ( obsel : Obsel ) : void 
		{
			_obsels.addItem( obsel );
		}
		
		public function removeObsel ( obsel : Obsel ) : void {};
	}
}