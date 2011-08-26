package com.ithaca.timeline 
{
	public class CursorIcons
	{
		import flash.events.MouseEvent;
		import flash.ui.Mouse;
		import flash.ui.MouseCursor;
		import mx.managers.CursorManager;

		[Bindable]
		[Embed(source="images/resize.png")]
		static public var Resize:Class;
		
		static public function SetResizeCursor(e:MouseEvent) : void
		{
			CursorManager.setCursor(CursorIcons.Resize, 2, -8, -8);
		}
		
		static public function SetHandCursor(e:MouseEvent) : void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		static public function SetButtonCursor(e:MouseEvent) : void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		static public function SetDefaultCursor(e:MouseEvent) : void
		{
			CursorManager.removeAllCursors();
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
}
