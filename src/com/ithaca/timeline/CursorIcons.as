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
		
		static public function SetResizeCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				CursorManager.setCursor(CursorIcons.Resize, 3, -8, -8);
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
					(event.currentTarget as Object).alpha = 0.5;
			}
		}
		
		static public function SetHandCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				Mouse.cursor = MouseCursor.HAND;
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
					(event.currentTarget as Object).alpha = 0.5;
			}
		}
		
		static public function SetButtonCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
				Mouse.cursor = MouseCursor.BUTTON;
		}
		
		static public function SetDefaultCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				CursorManager.removeAllCursors();
				Mouse.cursor = MouseCursor.AUTO;
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
					(event.currentTarget as Object).alpha = 1.0;
			}
		}
	}
}
