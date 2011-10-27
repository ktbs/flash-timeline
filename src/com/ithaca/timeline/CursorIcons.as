package com.ithaca.timeline 
{
	/**
	 * This class is used to change the appearance of the cursor
	 * */
	public class CursorIcons
	{
		import flash.events.MouseEvent;
		import flash.ui.Mouse;
		import flash.ui.MouseCursor;
		import mx.managers.CursorManager;

		[Bindable]
		[Embed(source="images/resize.png")]

		static public var Resize:Class;
		
		static private var currentObject:Object = null;

		static public function SetResizeCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				CursorManager.setCursor(CursorIcons.Resize, 3, -8, -8);
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
				{
					currentObject = (event.currentTarget as Object);
					currentObject.alpha = 0.5;
				}
				else
					currentObject = null;
			}
		}
		
		static public function SetHandCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				Mouse.cursor = MouseCursor.HAND;
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
				{
					currentObject = (event.currentTarget as Object);
					currentObject.alpha = 0.5;
				}
				else
					currentObject = null;
			}
		}

		static public function SetButtonCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
				Mouse.cursor = MouseCursor.BUTTON;
		}

		static public function SetIBeamCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				Mouse.cursor = MouseCursor.IBEAM;
				if ( (event.currentTarget as Object).hasOwnProperty("alpha") )
				{
					currentObject = (event.currentTarget as Object);
					currentObject.alpha = 0.5;
				}
				else
					currentObject = null;
			}				
		}

		static public function SetDefaultCursor(event:MouseEvent) : void
		{
			if ( !event.buttonDown )
			{
				CursorManager.removeAllCursors();
				Mouse.cursor = MouseCursor.AUTO;
				if ( currentObject )
					currentObject.alpha = 1.0;
				currentObject = null;
			}
		}
	}
}
