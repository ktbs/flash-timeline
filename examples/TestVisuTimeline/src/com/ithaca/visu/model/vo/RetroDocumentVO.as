package com.ithaca.visu.model.vo
{
	[RemoteClass(alias="com.ithaca.domain.model.RetroDocument")]
	[Bindable]
	public class RetroDocumentVO
	{
		public var documentId:int;
		public var title:String;
		public var description:String;
		public var ownerId:int;
		public var sessionId:int;
		public var creationDate:Date;
		public var lastModified:Date;
		public var xml:String;		
		public var inviteeIds:Array;		
		public var session:SessionVO;	
	}
}
