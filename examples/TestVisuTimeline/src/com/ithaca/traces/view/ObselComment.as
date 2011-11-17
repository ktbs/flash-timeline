package com.ithaca.traces.view
{
    import com.ithaca.traces.Obsel;
    import com.ithaca.traces.model.TraceModel;
    import com.ithaca.visu.events.MessageEvent;
    import com.ithaca.visu.events.ObselEvent;
    import com.ithaca.visu.events.SalonRetroEvent;
    
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    
    import mx.controls.Image;
    
    import spark.components.Button;
    import spark.components.Label;
    import spark.components.TextArea;
    import spark.components.supportClasses.SkinnableComponent;
    
    import flash.events.MouseEvent;
    import mx.core.DragSource;
    import mx.managers.DragManager;
    
    public class ObselComment extends SkinnableComponent implements IObselComponenet
    {
        
        [SkinPart("true")]
        public var textContent:Label;
        
        [SkinPart("true")]
        public var imageObsel:Image;
        
        [SkinPart("true")]
        public var textEdit:TextArea;
        
        [SkinPart("true")]
        public var buttonDelete:Button;
        
        [SkinPart("true")]
        public var buttonOk:Button;
        
        [SkinPart("true")]
        public var buttonCancel:Button;
        
        private var _begin:Number;
        private var _end:Number;
        
        private var _text:String;
        private var textChange:Boolean;
        private var normal:Boolean;
        
        private var _parentObsel:Obsel = null;
        private var _order:int;
        private var _backGroundColor:uint;
        
        public function ObselComment()
        {
            super();
            this.buttonMode = true;
            this.doubleClickEnabled = true;
            this.addEventListener(MouseEvent.DOUBLE_CLICK, onDobleClickObselComment);
            this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveOverObsel);
        }
        
        public function set parentObsel(value:Obsel):void{_parentObsel = value;}
        public function get parentObsel():Obsel{return this._parentObsel}
        public function set order(value:int):void{_order = value;}
        public function get order():int{return this._order}
        public function get text():String {return _text; }
        public function set text(value:String):void{_text = value;}
        public function set backGroundColor(value:uint):void{_backGroundColor = value; invalidateProperties();}
        public function get backGroundColor():uint{return this._backGroundColor}
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            if (textChange)
            {
                textChange = false;
                if(normal){
                    textContent.text = text;        
                    this.toolTip = text;        
                }else
                {
                    textEdit.text = text;
                    this.toolTip = null;
                    textEdit.selectAll();
                }
            }
        }
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName,instance);
            if(instance == buttonDelete)
            {
                buttonDelete.addEventListener(MouseEvent.CLICK, onMouseClickButtonDelete);
                buttonDelete.toolTip = "Effacer";
                if(parentObsel.props[TraceModel.TIMESTAMP] == 0)
                {
                    buttonDelete.enabled = false;
                }
            }
            if(instance == buttonOk)
            {
                buttonOk.addEventListener(MouseEvent.CLICK, returnResult);
                buttonOk.toolTip = "Valider";
            }
            if(instance == buttonCancel)
            {
                buttonCancel.addEventListener(MouseEvent.CLICK, onMouseClickButtonCancel);
                buttonCancel.toolTip = "Annuler";
            }
            if(instance == textContent)
            {
                textContent.text = text;
                this.toolTip = text;
            }
            if(instance == textEdit)
            {
                textEdit.text = text;
                textEdit.addEventListener(KeyboardEvent.KEY_UP, returnResult);
            }
            
        }
        override protected function partRemoved(partName:String, instance:Object):void
        {
            super.partRemoved(partName,instance);
            if(instance == buttonDelete)
            {
                buttonDelete.removeEventListener(MouseEvent.CLICK, onMouseClickButtonDelete);
                buttonDelete.toolTip = "Effacer";
            }
            if(instance == buttonOk)
            {
                buttonOk.removeEventListener(MouseEvent.CLICK, returnResult);
                buttonOk.toolTip = "Valider";
            }
            if(instance == buttonCancel)
            {
                buttonCancel.removeEventListener(MouseEvent.CLICK, onMouseClickButtonCancel);
                buttonCancel.toolTip = "Annuler";
            }
        }
        
        override protected function getCurrentSkinState():String
        {
            return !enabled? "disabled" : normal? "editabled" : "normal" ;
        }
        
        public function setEditabled(value:Boolean):void
        {
            normal = value;
            this.invalidateSkinState();
        }
        
// LISTENERS
        private function onMouseClickButtonDelete(event:MouseEvent):void
        {
            setEditabled(false);
            var deleteObsel:ObselEvent = new ObselEvent(ObselEvent.DELETE_OBSEL);
            deleteObsel.obsel = this.parentObsel;        
            deleteObsel.textObsel = text;
            this.dispatchEvent(deleteObsel);
        }

        public function setCancelEditObsel():void
        {
            this.textEdit.text = text;
            setEditabled(false);
            textChange = true;
            this.invalidateProperties();        
        }
        private function onMouseClickButtonCancel(event:MouseEvent):void
        {
            this.textEdit.text = text;
            setEditabled(false);
            textChange = true;
            this.invalidateProperties();
            var eventCancelEditObsel:ObselEvent = new ObselEvent(ObselEvent.CANCEL_EDIT_OBSEL);        
            eventCancelEditObsel.obsel = this.parentObsel;
            this.dispatchEvent(eventCancelEditObsel);
        }
        
        private function onDobleClickObselComment(event:MouseEvent):void
        {
            // TODO check where you will edit comment
            setEditabled(true);
        }
        
        private function returnResult(event:*):void {
            if(event is MouseEvent){
                text = textEdit.text;
                this.sendComment();
            }else if (event is KeyboardEvent)
            {
                if(event.keyCode == Keyboard.ENTER)
                {
                    // remove last simbol "enter"
                    text =  textEdit.text.slice(0,textEdit.text.length-1);
                    this.sendComment();
                }
            }
        }
        
        private function sendComment():void{
            setEditabled(false);
            textChange = true;
            this.invalidateProperties();
            var updateObsel:ObselEvent = new ObselEvent(ObselEvent.EDIT_OBSEL);
            updateObsel.obsel = this.parentObsel;
            updateObsel.textObsel = text;
            this.dispatchEvent(updateObsel);    
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
        private function onMouseMoveOverObsel(event:MouseEvent):void
        {
            var ds:DragSource = new DragSource();
            ds.addData(_parentObsel,"obsel");
            ds.addData(_text,"textObsel");    
            var imageProxy:Image = new Image();
            if(imageObsel != null)
            {
                imageProxy.source = imageObsel.source;
            }
            imageProxy.height=this.height*0.75;
            imageProxy.width=this.width*0.75;
            DragManager.doDrag(this,ds,event,imageProxy, -15, -15, 1.00);

        }
        public function cloneMe():ObselComment
        {
            var result:ObselComment = new ObselComment();
             result._begin = this._begin;
            result._end = this._end;
            result._parentObsel = this._parentObsel;
            result._backGroundColor = this._backGroundColor;
            result._order = this._order;
            return result;
        }
    }
}