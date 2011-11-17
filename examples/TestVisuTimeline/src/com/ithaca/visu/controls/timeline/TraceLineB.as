package com.ithaca.visu.controls.timeline
{
    import com.ithaca.traces.Obsel;
    import com.ithaca.visu.model.TraceModel;
    import com.ithaca.visu.events.SalonRetroEvent;
    import com.ithaca.visu.events.TraceLineEvent;
    import com.ithaca.visu.ui.utils.IconEnum;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.controls.Button;
    import mx.controls.Image;
    import mx.events.CollectionEvent;
    import mx.events.ToolTipEvent;
    
    import spark.components.CheckBox;
    import spark.components.Group;
    import spark.components.Label;
    import spark.components.SkinnableContainer;
    import spark.primitives.Path;
    
    /**
     * @flowerModelElementId _lcVwcJdPEeCiv8kQN5Cv0A
     */
    [SkinState("normal")]
    [SkinState("open")]
    
    [Event(name="addListObsel",type="com.ithaca.visu.events.TraceLineEvent")]
    [Event(name="removeListObsel",type="com.ithaca.visu.events.TraceLineEvent")]

    
    public class TraceLineB extends SkinnableContainer
    {
        
        [SkinPart("true")]
        public var contentGroupTraceLine:Group;

        [SkinPart("false")]
        public var partOpenTraceLineElements:Path;
        
        [SkinPart("true")]
        public var imageMarker:Image;
        [SkinPart("true")]
        public var imageConsigne:Image;
        [SkinPart("true")]
        public var imageKeyword:Image;
        
        [SkinPart("true")]
        public var traceLoggedUser:Group;
        [SkinPart("true")]
        public var timeLayoutTitle:TimeLayout;
        
        [SkinPart("false")]
        public var checkBoxMarkerObsel:CheckBox;
        [SkinPart("false")]
        public var checkBoxConsigneObsel:CheckBox;
        [SkinPart("false")]
        public var checkBoxKeywordObsel:CheckBox;
        [SkinPart("false")]
        public var checkBoxFichierObsel:CheckBox;
        [SkinPart("false")]
        public var checkBoxMessageObsel:CheckBox;
        
        [SkinPart("true")]
        public var traceLineIconTrace1:Group;    
        [SkinPart("false")]
        public var buttonAddTypeObselTrace1:Button;
        [SkinPart("false")]
        public var timeLayoutTrace1:TimeLayout;
        [SkinPart("false")]
        public var trace1:Group;
        [SkinPart("false")]
        public var labelTrace1:Label;
        private var listObselTraceLine1Change:Boolean;
            
        [SkinPart("true")]
        public var traceLineIconTrace2:Group;    
        [SkinPart("false")]
        public var buttonAddTypeObselTrace2:Button;
        [SkinPart("false")]
        public var timeLayoutTrace2:TimeLayout;
        [SkinPart("false")]
        public var trace2:Group;
        [SkinPart("false")]
        public var labelTrace2:Label;
        private var listObselTraceLine2Change:Boolean;
        
        [SkinPart("true")]
        public var traceLineIconTrace3:Group;    
        [SkinPart("false")]
        public var buttonAddTypeObselTrace3:Button;
        [SkinPart("false")]
        public var timeLayoutTrace3:TimeLayout;
        [SkinPart("false")]
        public var trace3:Group;
        [SkinPart("false")]
        public var labelTrace3:Label;
        private var listObselTraceLine3Change:Boolean;
        
        [SkinPart("true")]
        public var traceLineIconTrace4:Group;    
        [SkinPart("false")]
        public var buttonAddTypeObselTrace4:Button;
        [SkinPart("false")]
        public var timeLayoutTrace4:TimeLayout;
        [SkinPart("false")]
        public var trace4:Group;
        [SkinPart("false")]
        public var labelTrace4:Label;
        private var listObselTraceLine4Change:Boolean;
        
        [SkinPart("true")]
        public var traceLineIconTrace5:Group;    
        [SkinPart("false")]
        public var buttonAddTypeObselTrace5:Button;
        [SkinPart("false")]
        public var timeLayoutTrace5:TimeLayout;
        [SkinPart("false")]
        public var trace5:Group;
        [SkinPart("false")]
        public var labelTrace5:Label;
        private var listObselTraceLine5Change:Boolean;
        [SkinPart("false")]
        public var sharedIconMarker:Image;
        
        private var open:Boolean;
        private var durationChanged:Boolean;
        private var startSessionChanged:Boolean;
        public var tempList:ArrayCollection;
        public var _listElementTraceline:IList;
        private var elementsOpen:Boolean;
        
        private var _nameUserTraceLine:String;
        private var _sourceImageUserTraceLine:String;
        private var _colorUserTraceLine:uint;
        

        private var _listTitleObsels:ArrayCollection;
        private var elementsTraceLineChange:Boolean = false;
        private var listObselChange:Boolean = false;
        
        private var _startTimeSession:Number;
        private var _durationSession:Number;
        private var _userId:int;
        
        private var _sharedIconMarkerCode:String;
        private var sharedIconMarkerCodeChange:Boolean;
        
        private var MIN_TIME_EXPLORE_OBSEL:Number = 1000;
        
        public function TraceLineB()
        {
            super();
        }
        
        
        public function set nameUserTraceLine(value:String):void{this._nameUserTraceLine = value;}
        public function get nameUserTraceLine():String{return this._nameUserTraceLine};
        public function set idUserTraceLine(value:int):void{this._userId = value;}
        public function get idUserTraceLine():int{return this._userId};
        public function set sourceImageUserTraceLine(value:String):void{this._sourceImageUserTraceLine = value;}
        public function get sourceImageUserTraceLine():String{return this._sourceImageUserTraceLine};
        public function set colorUserTraceLine(value:uint):void{this._colorUserTraceLine = value;}
        public function get colorUserTraceLine():uint{return this._colorUserTraceLine};
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
        
        public function get listTitleObsels():ArrayCollection { return this._listTitleObsels; }
        public function set listTitleObsels(value:ArrayCollection):void
        {
            traceLoggedUser.removeAllElements();
            this._listTitleObsels = value;
            listObselChange = true;    
            invalidateProperties();
            
            if (this._listTitleObsels)
            {
                this._listTitleObsels.addEventListener(CollectionEvent.COLLECTION_CHANGE, listTitleObsels_ChangeHandler);
            }
        }
        public function set sharedIconMarkerCode(value:String):void
        {
            this._sharedIconMarkerCode = value;
            sharedIconMarkerCodeChange = true;
            invalidateProperties();
        }
        public function get sharedIconMarkerCode():String{return this._sharedIconMarkerCode};
        
        protected function listTitleObsels_ChangeHandler(event:CollectionEvent):void
        {
            traceLoggedUser.removeAllElements();
            listObselChange = true;
            invalidateProperties();
        }    
        
        public function get listElementTraceline():IList { return this._listElementTraceline; }
        public function set listElementTraceline(value:IList):void
        {
            
            this._listElementTraceline = value;
            // get traceLine1
            var elementTraceline1:Object = this._listElementTraceline.getItemAt(0) as Object;
            var listObselTraceLine1:ArrayCollection = elementTraceline1.listObsel as ArrayCollection;
            listObselTraceLine1.addEventListener(CollectionEvent.COLLECTION_CHANGE, listObselTraceLine1_ChangeHandler);

            // get traceLine2
            var elementTraceline2:Object = this._listElementTraceline.getItemAt(1) as Object;
            var listObselTraceLine2:ArrayCollection = elementTraceline2.listObsel as ArrayCollection;
            listObselTraceLine2.addEventListener(CollectionEvent.COLLECTION_CHANGE, listObselTraceLine2_ChangeHandler);
            
            // get traceLine3
            var elementTraceline3:Object = this._listElementTraceline.getItemAt(2) as Object;
            var listObselTraceLine3:ArrayCollection = elementTraceline3.listObsel as ArrayCollection;
            listObselTraceLine3.addEventListener(CollectionEvent.COLLECTION_CHANGE, listObselTraceLine3_ChangeHandler);
            
            // get traceLine4
            var elementTraceline4:Object = this._listElementTraceline.getItemAt(3) as Object;
            var listObselTraceLine4:ArrayCollection = elementTraceline4.listObsel as ArrayCollection;
            listObselTraceLine4.addEventListener(CollectionEvent.COLLECTION_CHANGE, listObselTraceLine4_ChangeHandler);
            
            // get traceLine5
            var elementTraceline5:Object = this._listElementTraceline.getItemAt(4) as Object;
            var listObselTraceLine5:ArrayCollection = elementTraceline5.listObsel as ArrayCollection;
            listObselTraceLine5.addEventListener(CollectionEvent.COLLECTION_CHANGE, listObselTraceLine5_ChangeHandler);
        }
        
        protected function listObselTraceLine1_ChangeHandler(event:CollectionEvent):void
        {
            if(open)
            {
                trace1.removeAllElements();
                listObselTraceLine1Change = true;
                invalidateProperties();
            }
        }    
        
        protected function listObselTraceLine2_ChangeHandler(event:CollectionEvent):void
        {
            if(open)
            {
                trace2.removeAllElements();
                listObselTraceLine2Change = true;
                invalidateProperties();
            }
        }    
        
        protected function listObselTraceLine3_ChangeHandler(event:CollectionEvent):void
        {
            if(open)
            {
                trace3.removeAllElements();
                listObselTraceLine3Change = true;
                invalidateProperties();
            }
        }    
        
        protected function listObselTraceLine4_ChangeHandler(event:CollectionEvent):void
        {
            if(open)
            {
                trace4.removeAllElements();
                listObselTraceLine4Change = true;
                invalidateProperties();
            }
        }    

        protected function listObselTraceLine5_ChangeHandler(event:CollectionEvent):void
        {
            if(open)
            {
                trace5.removeAllElements();
                listObselTraceLine5Change = true;
                invalidateProperties();
            }
        }    
        
        
        
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName,instance);
            if (instance == traceLineIconTrace1)
            {
                if(!this._listElementTraceline.getItemAt(0).added)
                {
                    traceLineIconTrace1.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIcon);
                    traceLineIconTrace1.addEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIcon);
                }
            }
            
            if (instance == traceLineIconTrace2)
            {
                if(!this._listElementTraceline.getItemAt(1).added)
                {    
                    traceLineIconTrace2.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace2);
                    traceLineIconTrace2.addEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIconTrace2);
                }
            }
            
            if (instance == traceLineIconTrace3)
            {
                if(!this._listElementTraceline.getItemAt(2).added)
                {    
                    traceLineIconTrace3.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace3);
                    traceLineIconTrace3.addEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIconTrace3);
                }
            }
            
            if (instance == traceLineIconTrace4)
            {
                if(!this._listElementTraceline.getItemAt(3).added)
                {    
                    traceLineIconTrace4.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace4);
                    traceLineIconTrace4.addEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIconTrace4);
                }
            }

            if (instance == traceLineIconTrace5)
            {
                if(!this._listElementTraceline.getItemAt(4).added)
                {    
                    traceLineIconTrace5.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace5);
                    traceLineIconTrace5.addEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIconTrace5);
                }
            }
            
            if (instance == contentGroupTraceLine)
            {
                contentGroupTraceLine.addEventListener(MouseEvent.CLICK, onClickContentGroupTraceLine);
            }
            
            if (instance == checkBoxConsigneObsel)
            {
                checkBoxConsigneObsel.addEventListener(Event.CHANGE, onChangeCheckboxCosigneObse);
            }
            
            if (instance == checkBoxKeywordObsel)
            {
                checkBoxKeywordObsel.addEventListener(Event.CHANGE, onChangeCheckBoxKeywordObsel);
            }
            
            if (instance == checkBoxFichierObsel)
            {
                checkBoxFichierObsel.addEventListener(Event.CHANGE, onChangeCheckBoxFichierObsel);
            }
            
            if (instance == checkBoxMessageObsel)
            {
                checkBoxMessageObsel.addEventListener(Event.CHANGE, onChangeCheckBoxMessageObsel);
            }
            
            if (instance == checkBoxMarkerObsel)
            {
                checkBoxMarkerObsel.addEventListener(Event.CHANGE, onChangeCheckBoxMarkerObsel);
            }
        }
        
        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName,instance);
            if (instance == traceLineIconTrace1)
            {
                traceLineIconTrace1.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIcon);
                traceLineIconTrace1.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutTraceLineIcon);
            }

            if (instance == contentGroupTraceLine)
            {
                contentGroupTraceLine.removeEventListener(MouseEvent.CLICK, onClickContentGroupTraceLine);
            }
            
            if (instance == checkBoxConsigneObsel)
            {
                checkBoxConsigneObsel.removeEventListener(Event.CHANGE, onChangeCheckboxCosigneObse);
            }
            
            
            if (instance == checkBoxKeywordObsel)
            {
                checkBoxKeywordObsel.removeEventListener(Event.CHANGE, onChangeCheckBoxKeywordObsel);
            }
            
            if (instance == checkBoxFichierObsel)
            {
                checkBoxFichierObsel.removeEventListener(Event.CHANGE, onChangeCheckBoxFichierObsel);
            }
            
            if (instance == checkBoxMessageObsel)
            {
                checkBoxMessageObsel.removeEventListener(Event.CHANGE, onChangeCheckBoxMessageObsel);
            }
            
            if (instance == checkBoxMarkerObsel)
            {
                checkBoxMarkerObsel.removeEventListener(Event.CHANGE, onChangeCheckBoxMarkerObsel);
            }
        }
        
        private function onClickContentGroupTraceLine(event:MouseEvent):void
        {
            if(event.target is Group && event.target.id == "contentGroupTraceLine")
            {
                var ind:int=     event.target.getElementIndex(partOpenTraceLineElements);
                var part:Path = event.target.getElementAt(ind) as Path;
                var deltaXPath:Number = part.x +part.width;
                var xLocal:Number = event.localX;
                if(xLocal < deltaXPath)
                {
                    // add obsel explane/minimize traceLine
                    var eventExpandeTraceLine:SalonRetroEvent = new SalonRetroEvent(SalonRetroEvent.ACTION_ON_EXPAND_TRACE_LINE);
                    eventExpandeTraceLine.userId = this._userId;
                    eventExpandeTraceLine.nameUserTraceLine = this._nameUserTraceLine;
                    eventExpandeTraceLine.avatarUser = this._sourceImageUserTraceLine;
                    eventExpandeTraceLine.isOpen = open;
                    this.dispatchEvent(eventExpandeTraceLine);
                    
                    open = !open;
                    invalidateSkinState();
                    elementsOpen = true;
                    invalidateProperties();
                }
            }    
        }
        // checkinfg action  on trace line        
        private function checkActionOnTraceLine(typeAddedObsel:int, typeWidget:int, addObselTitleTrace:Boolean):void
        {
            var addListObselConsigne:SalonRetroEvent = new SalonRetroEvent(SalonRetroEvent.ACTION_ON_TRACE_LINE);            
            addListObselConsigne.isPlus = addObselTitleTrace;
            addListObselConsigne.typeAddedObsel = typeAddedObsel;
            addListObselConsigne.typeWidget = typeWidget;
            addListObselConsigne.userId = this._userId;
            addListObselConsigne.nameUserTraceLine = this._nameUserTraceLine;
            addListObselConsigne.avatarUser = this._sourceImageUserTraceLine;
            this.dispatchEvent(addListObselConsigne);
        }
        
// TraceLine  Consigne
        private function onMouseOverTraceLineIcon(event:MouseEvent):void
        {
            buttonAddTypeObselTrace1.visible = true;
            buttonAddTypeObselTrace1.addEventListener(MouseEvent.CLICK, onClickPlusTrace1)
        }
        private function onMouseOutTraceLineIcon(event:MouseEvent):void
        {
            buttonAddTypeObselTrace1.visible = false;
            buttonAddTypeObselTrace1.removeEventListener(MouseEvent.CLICK, onClickPlusTrace1)
        }
        private function onClickPlusTrace1(event:MouseEvent, typeWidget:int = 0):void{
            // add obsel click plus
            checkActionOnTraceLine(1, typeWidget, true);            
            this.checkBoxConsigneObsel.selected = true;
            imageConsigne.visible = true;
            // set unvisible the button plus
            if(traceLineIconTrace1 != null)
            {
                buttonAddTypeObselTrace1.visible = false;
                traceLineIconTrace1.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIcon);
            }
            
            var elementTrace1:Object = this._listElementTraceline.getItemAt(0) as Object;    
            // set traceLine1 added
            elementTrace1.added = true;
            var listObselTrace1:ArrayCollection = elementTrace1.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace1;
            this.dispatchEvent(addListObselEvent);
        }
    
        private function onChangeCheckboxCosigneObse(event:Event):void
        {
            var checkBox:CheckBox = event.currentTarget as CheckBox;
            if(checkBox.selected)
            {
                onClickPlusTrace1(new MouseEvent(MouseEvent.CLICK),1);
            }else
            {
                onClickMinusTrace1(new MouseEvent(MouseEvent.CLICK),1);
                if(traceLineIconTrace1 != null)
                {
                    traceLineIconTrace1.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIcon);
                }
            }
        }
        
        private function onClickMinusTrace1(event:MouseEvent, typeWidget:int = 0):void{
            // remove obsel
            checkActionOnTraceLine(1, typeWidget, false);
            var elementTrace1:Object = this._listElementTraceline.getItemAt(0) as Object;    
            // set traceLine1 added
            elementTrace1.added = false;
            var listObselTrace1:ArrayCollection = elementTrace1.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace1;
            this.dispatchEvent(addListObselEvent);
            
        }        
// TraceLine  Keyword        
        private function onMouseOverTraceLineIconTrace2(event:MouseEvent):void
        {
            buttonAddTypeObselTrace2.visible = true;
            buttonAddTypeObselTrace2.addEventListener(MouseEvent.CLICK, onClickPlusTrace2)
        }
        private function onMouseOutTraceLineIconTrace2(event:MouseEvent):void
        {
            buttonAddTypeObselTrace2.visible = false;
            buttonAddTypeObselTrace2.removeEventListener(MouseEvent.CLICK, onClickPlusTrace2)
        }
        
        private function onClickPlusTrace2(event:MouseEvent, typeWidget:int = 0):void{
            // add obsel click plus
            checkActionOnTraceLine(2, typeWidget, true);
            this.checkBoxKeywordObsel.selected = true;
            // set unvisible the button plus
            if(traceLineIconTrace2 != null)
            {
                buttonAddTypeObselTrace2.visible = false;
                traceLineIconTrace2.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace2);
            }
            
            var elementTrace2:Object = this._listElementTraceline.getItemAt(1) as Object;    
            // set traceLine1 added
            elementTrace2.added = true;
            var listObselTrace2:ArrayCollection = elementTrace2.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace2;
            this.dispatchEvent(addListObselEvent);

        }
        private function onClickMinusTrace2(event:MouseEvent, typeWidget:int = 0):void{
            // remove obsel
            checkActionOnTraceLine(2, typeWidget, false);
            var elementTrace2:Object = this._listElementTraceline.getItemAt(1) as Object;    
            // set traceLine1 added
            elementTrace2.added = false;
            var listObselTrace2:ArrayCollection = elementTrace2.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace2;
            this.dispatchEvent(addListObselEvent);
        }
        
        private function onChangeCheckBoxKeywordObsel(event:Event):void
        {
            var checkBox:CheckBox = event.currentTarget as CheckBox;
            if(checkBox.selected)
            {
                onClickPlusTrace2(new MouseEvent(MouseEvent.CLICK),1);
            }else
            {
                onClickMinusTrace2(new MouseEvent(MouseEvent.CLICK),1);
                if(traceLineIconTrace2 != null)
                {
                    traceLineIconTrace2.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace2);
                }
            }
        }        
// TraceLine  Documents        
        private function onMouseOverTraceLineIconTrace3(event:MouseEvent):void
        {
            buttonAddTypeObselTrace3.visible = true;
            buttonAddTypeObselTrace3.addEventListener(MouseEvent.CLICK, onClickPlusTrace3)
        }
        private function onMouseOutTraceLineIconTrace3(event:MouseEvent):void
        {
            buttonAddTypeObselTrace3.visible = false;
            buttonAddTypeObselTrace3.removeEventListener(MouseEvent.CLICK, onClickPlusTrace3)
        }
        
        private function onClickPlusTrace3(event:MouseEvent, typeWidget:int = 0):void{
            // add obsel click plus
            checkActionOnTraceLine(3, typeWidget, true);
            this.checkBoxFichierObsel.selected = true;
            // set unvisible the button plus
            if(traceLineIconTrace3 != null)
            {
                buttonAddTypeObselTrace3.visible = false;
                traceLineIconTrace3.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace3);    
            }
            
            var elementTrace3:Object = this._listElementTraceline.getItemAt(2) as Object;    
            // set traceLine1 added
            elementTrace3.added = true;
            var listObselTrace3:ArrayCollection = elementTrace3.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace3;
            this.dispatchEvent(addListObselEvent);
            
        }
        private function onClickMinusTrace3(event:MouseEvent, typeWidget:int = 0):void{
            // remove obsel
            checkActionOnTraceLine(3, typeWidget, false);
            var elementTrace3:Object = this._listElementTraceline.getItemAt(2) as Object;    
            // set traceLine1 added
            elementTrace3.added = false;
            var listObselTrace3:ArrayCollection = elementTrace3.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace3;
            this.dispatchEvent(addListObselEvent);
        }
        
        private function onChangeCheckBoxFichierObsel(event:Event):void
        {
            var checkBox:CheckBox = event.currentTarget as CheckBox;
            if(checkBox.selected)
            {
                onClickPlusTrace3(new MouseEvent(MouseEvent.CLICK),1);
            }else
            {
                onClickMinusTrace3(new MouseEvent(MouseEvent.CLICK),1);
                if(traceLineIconTrace3 != null)
                {
                    traceLineIconTrace3.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace3);
                }
            }
        }
// TraceLine  Message        
        private function onMouseOverTraceLineIconTrace4(event:MouseEvent):void
        {
            buttonAddTypeObselTrace4.visible = true;
            buttonAddTypeObselTrace4.addEventListener(MouseEvent.CLICK, onClickPlusTrace4)
        }
        private function onMouseOutTraceLineIconTrace4(event:MouseEvent):void
        {
            buttonAddTypeObselTrace4.visible = false;
            buttonAddTypeObselTrace4.removeEventListener(MouseEvent.CLICK, onClickPlusTrace4)
        }
        
        private function onClickPlusTrace4(event:MouseEvent, typeWidget:int = 0):void{
            // add obsel click plus
            checkActionOnTraceLine(4, typeWidget, true);
            this.checkBoxMessageObsel.selected = true;
            // set unvisible the button plus
            if(traceLineIconTrace4 != null)
            {
                buttonAddTypeObselTrace4.visible = false;
                traceLineIconTrace4.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace4);
            }
            
            var elementTrace4:Object = this._listElementTraceline.getItemAt(3) as Object;    
            // set traceLine added
            elementTrace4.added = true;
            var listObselTrace4:ArrayCollection = elementTrace4.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace4;
            this.dispatchEvent(addListObselEvent);
            
        }
        private function onClickMinusTrace4(event:MouseEvent, typeWidget:int = 0):void{
            // remove obsel
            checkActionOnTraceLine(4, typeWidget, false);
            var elementTrace4:Object = this._listElementTraceline.getItemAt(3) as Object;    
            // set traceLine4 added
            elementTrace4.added = false;
            var listObselTrace4:ArrayCollection = elementTrace4.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace4;
            this.dispatchEvent(addListObselEvent);
        }
        
        private function onChangeCheckBoxMessageObsel(event:Event):void
        {
            var checkBox:CheckBox = event.currentTarget as CheckBox;
            if(checkBox.selected)
            {
                onClickPlusTrace4(new MouseEvent(MouseEvent.CLICK),1);
            }else
            {
                onClickMinusTrace4(new MouseEvent(MouseEvent.CLICK),1);
                if(traceLineIconTrace4 != null)
                {
                    traceLineIconTrace4.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace4);
                }
            }
        }
// TraceLine  Mark        
        private function onMouseOverTraceLineIconTrace5(event:MouseEvent):void
        {
            buttonAddTypeObselTrace5.visible = true;
            buttonAddTypeObselTrace5.addEventListener(MouseEvent.CLICK, onClickPlusTrace5)
        }
        private function onMouseOutTraceLineIconTrace5(event:MouseEvent):void
        {
            buttonAddTypeObselTrace5.visible = false;
            buttonAddTypeObselTrace5.removeEventListener(MouseEvent.CLICK, onClickPlusTrace5)
        }
        
        private function onClickPlusTrace5(event:MouseEvent, typeWidget:int = 0):void{
            // add obsel click plus
            checkActionOnTraceLine(5, typeWidget, true);
            this.checkBoxMarkerObsel.selected = true;
            // set unvisible the button plus
            if(traceLineIconTrace5 != null)
            {
                buttonAddTypeObselTrace5.visible = false;
                traceLineIconTrace5.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace5);
            }
            
            var elementTrace5:Object = this._listElementTraceline.getItemAt(4) as Object;    
            // set traceLine added
            elementTrace5.added = true;
            var listObselTrace5:ArrayCollection = elementTrace5.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.ADD_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace5;
            this.dispatchEvent(addListObselEvent);
            
        }
        private function onClickMinusTrace5(event:MouseEvent, typeWidget:int = 0):void{
            // remove obsel
            checkActionOnTraceLine(5, typeWidget, false);
            var elementTrace5:Object = this._listElementTraceline.getItemAt(4) as Object;    
            // set traceLine4 added
            elementTrace5.added = false;
            var listObselTrace5:ArrayCollection = elementTrace5.listObsel as ArrayCollection;
            var addListObselEvent:TraceLineEvent = new TraceLineEvent(TraceLineEvent.REMOVE_LIST_OBSEL);
            addListObselEvent.listObsel = listObselTrace5;
            this.dispatchEvent(addListObselEvent);
            
        }
        
        private function onChangeCheckBoxMarkerObsel(event:Event):void
        {
            var checkBox:CheckBox = event.currentTarget as CheckBox;
            if(checkBox.selected)
            {
                onClickPlusTrace5(new MouseEvent(MouseEvent.CLICK),1);
            }else
            {
                onClickMinusTrace5(new MouseEvent(MouseEvent.CLICK),1);
                if(traceLineIconTrace5 != null)
                {
                    traceLineIconTrace5.addEventListener(MouseEvent.ROLL_OVER, onMouseOverTraceLineIconTrace5);
                }
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
                    var nbrObsels:int = this._listTitleObsels.length;
                    for(var nObsel:int = 0 ; nObsel < nbrObsels ; nObsel++)
                    {
                        var obsel = this._listTitleObsels.getItemAt(nObsel);
                        obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow);
                        traceLoggedUser.addElement(obsel);

                    }
                }
            }
                    
            if(startSessionChanged)
            {
                startSessionChanged = false;
                
                timeLayoutTitle.startTime = this._startTimeSession;
                if(open)
                {
                    timeLayoutTrace1.startTime = this._startTimeSession;
                    timeLayoutTrace2.startTime = this._startTimeSession;
                    timeLayoutTrace3.startTime = this._startTimeSession;
                    timeLayoutTrace4.startTime = this._startTimeSession;
                    timeLayoutTrace5.startTime = this._startTimeSession;
                }
            }
            
            if(durationChanged)
            {
                durationChanged = false;
                
                timeLayoutTitle.durationSession = this._durationSession;
                if(open)
                {
                    timeLayoutTrace1.durationSession = this._durationSession;
                    timeLayoutTrace2.durationSession = this._durationSession;
                    timeLayoutTrace3.durationSession = this._durationSession;
                    timeLayoutTrace4.durationSession = this._durationSession;
                    timeLayoutTrace5.durationSession = this._durationSession;
                }
            }
            
            if(sharedIconMarkerCodeChange)
            {
                sharedIconMarkerCodeChange = false;
                if(sharedIconMarker != null)
                {
                    // set source the shared icon
                    sharedIconMarker.source = IconEnum.getIconByCodeShared(this._sharedIconMarkerCode);
                }                
            }
            
            if(elementsOpen)
            {
                elementsOpen = false;
    
                var element:Object = this._listElementTraceline.getItemAt(0) as Object;                
                timeLayoutTrace1.durationSession = this._durationSession;
                timeLayoutTrace1.startTime = this._startTimeSession;
                labelTrace1.text = element.titleTraceLine;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace1.addElement(obsel);    
                }
                // traceLine2
                var element:Object = this._listElementTraceline.getItemAt(1) as Object;
                timeLayoutTrace2.durationSession = this._durationSession;
                timeLayoutTrace2.startTime = this._startTimeSession;
                labelTrace2.text = element.titleTraceLine;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace2.addElement(obsel);    
                }    
                // traceLine3
                var element:Object = this._listElementTraceline.getItemAt(2) as Object;
                timeLayoutTrace3.durationSession = this._durationSession;
                timeLayoutTrace3.startTime = this._startTimeSession;
                labelTrace3.text = element.titleTraceLine;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace3.addElement(obsel);    
                }    
                // traceLine4
                var element:Object = this._listElementTraceline.getItemAt(3) as Object;
                timeLayoutTrace4.durationSession = this._durationSession;
                timeLayoutTrace4.startTime = this._startTimeSession;
                labelTrace4.text = element.titleTraceLine;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace4.addElement(obsel);    
                }    
                // traceLine5 : marker
                var element:Object = this._listElementTraceline.getItemAt(4) as Object;
                timeLayoutTrace5.durationSession = this._durationSession;
                timeLayoutTrace5.startTime = this._startTimeSession;
                labelTrace5.text = element.titleTraceLine;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace5.addElement(obsel);    
                }    
                // set source the shared icon
                sharedIconMarker.source = IconEnum.getIconByCodeShared(this._sharedIconMarkerCode);
            }
            
            if(listObselTraceLine1Change)
            {
                listObselTraceLine1Change = false;

                var element:Object = this._listElementTraceline.getItemAt(0) as Object;                
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;        
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace1.addElement(obsel);    
                }
            }
            
            if(listObselTraceLine2Change)
            {
                listObselTraceLine2Change = false;

                var element:Object = this._listElementTraceline.getItemAt(1) as Object;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace2.addElement(obsel);    
                }    
            }

            if(listObselTraceLine3Change)
            {
                listObselTraceLine3Change = false;

                var element:Object = this._listElementTraceline.getItemAt(2) as Object;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace3.addElement(obsel);    
                }    
            }

            if(listObselTraceLine4Change)
            {
                listObselTraceLine4Change = false;

                var element:Object = this._listElementTraceline.getItemAt(3) as Object;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace4.addElement(obsel);    
                }    
            }
            
            if(listObselTraceLine5Change)
            {
                listObselTraceLine5Change = false;
                
                var element:Object = this._listElementTraceline.getItemAt(4) as Object;
                var listObsel:ArrayCollection = element.listObsel as ArrayCollection;
                var nbrObsel:int = listObsel.length;
                for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
                {
                    var obsel= listObsel.getItemAt(nObsel);
                    obsel.addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, onToolTipObselShow)
                    trace5.addElement(obsel);    
                }    
            }
            
        }
        
        public function updateObsel():void
        {
            listObselChange = true;
            invalidateProperties();
        }
        override protected function getCurrentSkinState():String
        {
            var result:String = !enabled? "disable" : open? "open" : "normal"
            return result ;
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
                eventExploreObsel.text = target.toolTip;
                // FIXME : can say where was explore action titreTriceLine or in traceLine detaile(state open)
                onDispatcher(eventExploreObsel);
            }
        }
        
        private function onDispatcher(event:*):void
        {
            this.dispatchEvent(event);
        }
        
        
    }
}