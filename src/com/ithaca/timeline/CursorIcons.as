package com.ithaca.timeline 
{
	public class CursorIcons
	{
		import flash.ui.Mouse;
		import flash.ui.MouseCursor;
		import mx.managers.CursorManager;

		[Bindable]
		[Embed(source="images/resize.png")]
		static public var Resize:Class;
		
		static public function SetResizeCursor() : void
		{
			CursorManager.setCursor(CursorIcons.Resize, 2, -8, -8);
		}
		
		static public function SetHandCursor() : void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		static public function SetDefaultCursor() : void
		{
			CursorManager.removeAllCursors();
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
}
