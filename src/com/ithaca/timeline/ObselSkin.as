package com.ithaca.timeline
{
	import spark.components.supportClasses.SkinnableComponent;
	import com.ithaca.traces.Obsel;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ithaca.timeline.skins.ObselGenericEditDialog;
	import mx.managers.PopUpManager;
	import mx.core.UIComponent;
	
	[Style(name = "icon", type = "Class", inherit = "no")]
	[Style(name = "backgroundColor", type = "Number", format="Color", inherit = "no")]
	public class ObselSkin extends SkinnableComponent
	{
		[SkinPart]
		public  var leftGrip		: UIComponent;
		[SkinPart]
		public  var rightGrip		: UIComponent;

		public var traceline : TraceLine;
		private var _obsel : Obsel;
		public var editable : Boolean;
		
		public function ObselSkin( o : Obsel, tl : TraceLine )
		{
			super();			
			editable = false;
			traceline = tl;
			_obsel = o;
			doubleClickEnabled = true;
			toolTip = obsel.toString();
//			addEventListener( MouseEvent.DOUBLE_CLICK, editObsel );
		}
		
		public function get obsel () : Obsel
		{
			return _obsel;
		}
		
		public function editObsel ( event : Event ) : void 
		{
			var editDialog:ObselGenericEditDialog = new ObselGenericEditDialog(  );
			editDialog.obsel = this;
			PopUpManager.addPopUp(editDialog, UIComponent( parentApplication), true);
			PopUpManager.centerPopUp(editDialog);
		};

		// Update the obsel values in the trace
		protected function UpdateObsel () : void {};
	}
}