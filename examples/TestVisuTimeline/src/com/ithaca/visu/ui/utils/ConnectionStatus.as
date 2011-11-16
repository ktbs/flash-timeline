package com.ithaca.visu.ui.utils
{
	public class ConnectionStatus
	{
		public static const DISCONNECTED:int = 0;
		public static const CONNECTED:int = 1;
		public static const PENDING:int = 2;
		public static const RECORDING:int = 3;
/*		public static const CONNECTED:ConnectionStatus = new ConnectionStatus(0);
		public static const DISCONNECTED:ConnectionStatus = new ConnectionStatus(1);
		public static const PENDING:ConnectionStatus = new ConnectionStatus(2);*/
		private var value:int;
		
		public function ConnectionStatus(value:int)
		{
			this.value = value;
		}
		
		public function valueOf():int
		{
			return value;	
		}
		public function toString():String
		{
			return value==CONNECTED ? "connected " :
					value == DISCONNECTED ? "disconnected" :
					value == PENDING ? "pending" : "recording" ;
		}
	}
}