package com.ithaca.timeline 
{
	public class CursorIcons
	{
		import mx.managers.CursorManager;

		[Bindable]
		[Embed(source="images/resize.png")]
		static public var Resize:Class;
		
		static public function SetResizeCursor() : void
		{
			CursorManager.setCursor(CursorIcons.Resize, 2, -8, -8);
		}
		
		static public function RemoveCursor() : void
		{
			CursorManager.removeAllCursors();
		}
	}
}
