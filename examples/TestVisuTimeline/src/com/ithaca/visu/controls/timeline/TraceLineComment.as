package com.ithaca.visu.controls.timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.visu.model.TraceModel;
	import com.ithaca.traces.view.ObselComment;
	import com.ithaca.visu.events.ObselEvent;
	import com.ithaca.visu.events.SalonRetroEvent;
	import com.ithaca.visu.model.Model;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.IVisualElement;
	import mx.events.CollectionEvent;
	import mx.events.ToolTipEvent;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * @flowerModelElementId _lcrHoJdPEeCiv8kQN5Cv0A
	 */
	public class TraceLineComment extends SkinnableComponent
	{
		[SkinPart("true")]
		public var textTitre:Label;
		
		[SkinPart("true")]
		public var buttonAddComment:Image;
		
		[SkinPart("true")]
		public var traceTitleLoggedUser:Group;
		
		[SkinPart("true")] 
		public var timeLayoutTitle:TimeLayout;
		
		private var _listTitleObsels:ArrayCollection;
		private var listObselChange:Boolean;
		
		private var _startTimeSession:Number;
		private var _durationSession:Number;
		private var _userId:int;
		
		private var durationChanged:Boolean;
		private var startSessionChanged:Boolean;
		private var _backGroundColor:uint;
		
		private var MIN_TIME_EXPLORE_OBSEL:Number = 1000;
		
		public function TraceLineComment()
		{
			super();
			// TODO icon cursor for double click
		}
		
		public function set startTimeSession(value:Number):void
		{
			this._startTimeSession = value;
			startSessionChanged = true;
			invalidateProperties();
		}
		public function get startTimeSession():Number{return this._startTimeSession};
		public function set durationSession(value:Number):void
		{
			this._durationSession = value;
			durationChanged = true;
			invalidateProperties();
		}
		public function get durationSession():Number{return this._durationSession};
		public function set idUserTraceLine(value:int):void{this._userId = value;}
		public function get idUserTraceLine():int{return this._userId};
		public function set backGroundColor(value:uint):void{_backGroundColor = value; invalidateProperties();}
		public function get backGroundColor():uint{return this._backGroundColor}
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if(instance == buttonAddComment)
			{
				buttonAddComment.addEventListener(MouseEvent.CLICK, onMouseClickAddComment);
				buttonAddComment.useHandCursor = true;
				buttonAddComment.buttonMode = true;
				buttonAddComment.toolTip = "Poser";
			}
			if(instance == traceTitleLoggedUser)
			{
				traceTitleLoggedUser.doubleClickEnabled = true;
				traceTitleLoggedUser.buttonMode = true;
				traceTitleLoggedUser.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseClicktraceTitleLoggedUser);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == buttonAddComment)
			{
				buttonAddComment.removeEventListener(MouseEvent.CLICK, onMouseClickAddComment);
			}
		}
		public function get listTitleObsels():ArrayCollection { return this._listTitleObsels; }
		public function set listTitleObsels(value:ArrayCollection):void
		{
			traceTitleLoggedUser.removeAllElements();
			this._listTitleObsels = value;
			listObselChange = true;	
			invalidateProperties();
			
			if (this._listTitleObsels)
			{
				this._listTitleObsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, listTitleObsels_ChangeHandler);
			}
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (listObselChange)
			{
				listObselChange = false;
				
				if(this._listTitleObsels != null)
				{
					if(traceTitleLoggedUser != null)
					{
						traceTitleLoggedUser.removeAllElements();
					}
					var nbrObsels:int = this._listTitleObsels.length;
					for(var nObsel:int = 0 ; nObsel < nbrObsels ; nObsel++)
					{
						var obsel = this._listTitleObsels.getItemAt(nObsel);
						obsel.addEventListener(MouseEvent.DOUBLE_CLICK, onStartEditCancelEditObsel);
						obsel.addEventListener(ObselEvent.CANCEL_EDIT_OBSEL, onStartEditCancelEditObsel);
						obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
						traceTitleLoggedUser.addElement(obsel);
					}
				}
			}
			
			if(startSessionChanged)
			{
				startSessionChanged = false;			
				timeLayoutTitle.startTime = this._startTimeSession;
			}
			
			if(durationChanged)
			{
				durationChanged = false;			
				timeLayoutTitle.durationSession = this._durationSession
			}
		}
			
		protected function listTitleObsels_ChangeHandler(event:CollectionEvent):void
		{
			traceTitleLoggedUser.removeAllElements();
			listObselChange = true;
			invalidateProperties();
		}
		
		
		private function onMouseClicktraceTitleLoggedUser(event:MouseEvent):void
		{
			if(event.target is Group && event.target.id == "traceTitleLoggedUser")
			{
				var obselEvent:ObselEvent = new ObselEvent(ObselEvent.ADD_OBSEL);
				obselEvent.clickOnButtonAdd = false;
				obselEvent.clickLocalX = event.localX;
				this.dispatchEvent(obselEvent);				
			}
		}
		
		private function onMouseClickAddComment(event:MouseEvent):void
		{
			var obselEvent:ObselEvent = new ObselEvent(ObselEvent.ADD_OBSEL);
			obselEvent.clickOnButtonAdd = true;
			this.dispatchEvent(obselEvent);
		}
		
		private function onStartEditCancelEditObsel(event:*):void
		{
			// set current obsel comment
			var currentObsel:ObselComment = event.currentTarget;
			var eventActionUserEditObsel:SalonRetroEvent = new SalonRetroEvent(SalonRetroEvent.PRE_ACTION_ON_OBSEL_COMMENT_START_EDIT_CANCEL_EDIT);
			var obselView:ObselComment = Model.getInstance().getCurrentObselComment();
			if(obselView != null)
			{
				var timeStamp:Number = obselView.parentObsel.props[TraceModel.TIMESTAMP];
				if(timeStamp == 0)
				{
					var indexCurrentObsel:int = this._listTitleObsels.getItemIndex(obselView);
					this._listTitleObsels.removeItemAt(indexCurrentObsel);
					
				}else
				{
					obselView.setCancelEditObsel();
				}
				Model.getInstance().setCurrentObselComment(null,this.traceTitleLoggedUser);
			}

			var parentObsel:Obsel = null;
			var text:String ="";
			var timestamp:String ="";
			var editType:String = "void";
			// the button cancel
			if(event is ObselEvent)
			{
				eventActionUserEditObsel.typeAction = TraceModel.RETRO_CANCEL_EDIT_EVENT;
				parentObsel = event.obsel;
				if(parentObsel.props[TraceModel.TIMESTAMP] == 0)
				{
					editType = TraceModel.RETRO_EDIT_TYPE_CANCEL_CREATE;
					// remove obsel from the stage
					var obselComment:ObselComment = event.currentTarget;
					var indexObsel:int = this._listTitleObsels.getItemIndex(obselComment);
					if(indexObsel != -1)
					{
						this._listTitleObsels.removeItemAt(indexObsel);
					}
				}else
				{
					editType = TraceModel.RETRO_EDIT_TYPE_CANCEL_EDIT;
					text = parentObsel.props[TraceModel.TEXT];
					timestamp = parentObsel.props[TraceModel.TIMESTAMP];
				}
				
				Model.getInstance().setCurrentObselComment(null,this.traceTitleLoggedUser);	
			}else
				// double click on the obsel
			{
				eventActionUserEditObsel.typeAction = TraceModel.RETRO_START_EDIT_EVENT;
				parentObsel = event.currentTarget.parentObsel;
				text = parentObsel.props[TraceModel.TEXT];
				timestamp = parentObsel.props[TraceModel.TIMESTAMP];	
				Model.getInstance().setCurrentObselComment(currentObsel,this.traceTitleLoggedUser);
			}			
			eventActionUserEditObsel.editTypeCancel = editType;
			eventActionUserEditObsel.text = text;
			eventActionUserEditObsel.timeStamp = Number(timestamp);
			eventActionUserEditObsel.obsel = parentObsel;		
			this.dispatchEvent(eventActionUserEditObsel);		
		}

		
		private function onToolTipObselShow(event:ToolTipEvent):void
		{
			var target = event.target as Object;
			var timer:Timer;
			startTimer();
			
			function startTimer():void
			{	
				timer = new Timer(MIN_TIME_EXPLORE_OBSEL,0);
				timer.addEventListener(TimerEvent.TIMER, onEndTimeMinExploreObsel);
				timer.start();
			}
			
			function onEndTimeMinExploreObsel(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER, onEndTimeMinExploreObsel);
				var obsel:Obsel = target.parentObsel as Obsel;
				var eventExploreObsel:SalonRetroEvent = new SalonRetroEvent(SalonRetroEvent.ACTION_ON_EXPLORE_OBSEL);
				eventExploreObsel.timeStamp = obsel.props[TraceModel.TIMESTAMP];
				// toolTips will egal null when obsel is on the edit state
				if(target.toolTip != null)
				{
					eventExploreObsel.text = target.toolTip;
					onDispatcher(eventExploreObsel);
				}
			}
		}
		
		private function onDispatcher(event:*):void
		{
			this.dispatchEvent(event);
		}
	}
}