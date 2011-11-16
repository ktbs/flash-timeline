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

	/**
	 * The ObselSkin class is a skinnable component that represent a com.ithaca.traces.Obsel.
	 *
	 * <p> There're two steps to assign a skin to an obsel.
	 * <ol>
	 * 		<li> Create a obselSelector in the obselsSelector section of the xml descriptor. Example : <code> &lt;obselSelector id='Document'  	  selector="SelectorRegexp" selectorParams="type,Document" /&gt;</code> </li>
	 * 		<li> Use the Id in the CSS file to assign the skin : <code> timeline|ObselSkin.Document { .... } </code> </li>
	 * </ol>
	 * </p>
	 *
	 */
	public class ObselSkin extends SkinnableComponent
	{
		
		[SkinPart]
		/*
		 * The leftGrip property is defined here to allow its management when two duratives cover each other.
		 * This is probably not the best solution.....
		 */
		public  var leftGrip		: UIComponent;
		[SkinPart]
		/*
		 * The rightGrip property is defined here to allow its management when two duratives cover each other.
		 * This is probably not the best solution.....
		 */
		public  var rightGrip		: UIComponent;

		/**
		 * The traceline that contains the obsel
		 */
		public var traceline : TraceLine;
		
		/**
		 * The obsel represented by the ObselSkin
		 */
		private var _obsel : Obsel;
		
		/**
		 * Specifies if the obsel is editable or not.
		 */
		public var editable : Boolean;
		
		/**
		 *
		 * @param o The obsel represented by the ObselSkin
		 * @param tl The traceline that contains the obsel
		 */
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
		
		/**		
		 * @return The obsel
		 */
		public function get obsel () : Obsel
		{
			return _obsel;
		}
		
		/**
		 *
		 * @param event
		 */
		public function editObsel ( event : Event ) : void
		{
			var editDialog:ObselGenericEditDialog = new ObselGenericEditDialog(  );
			editDialog.obsel = this;
			PopUpManager.addPopUp(editDialog, UIComponent( parentApplication), true);
			PopUpManager.centerPopUp(editDialog);
		};
	}
}