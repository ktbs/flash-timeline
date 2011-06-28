package com.ithaca.visu.events
{
import flash.events.Event;
import flash.net.NetStream;

public class MessageEvent extends Event
{
	// constants
	static public const SEND_PRV_MESSAGE : String = 'sendPrivateMessage';
	static public const SEND_PUB_MESSAGE : String = 'sendPublicMessage';
	static public const START_RECORDING : String = 'startRecording';
	static public const STOP_RECORDING : String = 'stopRecording';
	static public const GET_TRACE : String = 'getTrace';
	static public const GET_SETMARCK : String = 'getSetMarck';
	static public const CHECK_SEEK_STREAM : String = 'checkSeekStream';
	
	

	// properties
	public var senderUserId:int;
	public var message : String;
	public var resiverUserId:int;
	public var sessionId:int;
	public var sessionStatus:int;
	public var netStream:NetStream;

	// constructor
	public function MessageEvent(type : String = null,
								 bubbles : Boolean = true,
								 cancelable : Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	// methods
	override public  function toString() : String
	{ return "events.MessageEvent"; }
	
	
}
}
