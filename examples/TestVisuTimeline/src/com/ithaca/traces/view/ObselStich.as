package com.ithaca.traces.view
{
	import com.ithaca.traces.Obsel;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ObselStich extends SkinnableComponent implements IObselComponenet
	{
		
		
		[SkinPart("true")]
		public var timeLabel:Label;
		
		private var _begin:Number;
		private var _end:Number;
		private var _parentObsel:Obsel;
		private var _label:String;
		
		private var showLabel:Boolean;
		private var labelChange:Boolean;
		
		public function ObselStich()
		{
			super();
			this.minWidth = 50;
			this.width = 50;
		}
		public function setLabel(value:String):void
		{
			showLabel = true;
			this.invalidateSkinState();
			_label = value;
			labelChange = true;
			this.invalidateProperties();
			
		}
		public function setBegin(value:Number):void
		{
			this._begin = value;
		}
		
		public function getBegin():Number
		{
			return this._begin;
		}
		
		public function setEnd(value:Number):void
		{
			this._end = value;
		}
		
		public function getEnd():Number
		{
			return this._end;
		}
		
		public function setObselViewVisible(value:Boolean):void
		{
			this.visible = value;
		}
		
		public function set parentObsel(value:Obsel):void{_parentObsel = value;}
		public function get parentObsel():Obsel{return this._parentObsel};
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == timeLabel)
			{
				timeLabel.text = _label;
			}

			
			
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (labelChange)
			{
				labelChange = false;
				if(timeLabel != null)
				{
					timeLabel.text = _label;
				}
				
			}
		}
		override protected function getCurrentSkinState():String
		{
			return !enabled? "disabled" : showLabel? "label" : "stich";
		}
		
	}

}