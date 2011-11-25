package com.ithaca.timeline
{
    import com.ithaca.timeline.skins.ObselGenericEditDialog;
    import com.ithaca.traces.Obsel;
    import com.ithaca.traces.TraceManager;
    import com.ithaca.traces.events.ObselEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.events.ToolTipEvent;
    import mx.events.DragEvent;

    import mx.core.UIComponent;
    import mx.managers.PopUpManager;

    import spark.components.supportClasses.SkinnableComponent;

    [Style(name = "icon", type = "Class", inherit = "no")]
    [Style(name = "backgroundColor", type = "Number", format="Color", inherit = "no")]

    /**
     * The ObselSkin class is a skinnable component that represents a com.ithaca.traces.Obsel.
     *
     * <p> There are two steps to assign a skin to an obsel:
     * <ol>
     *         <li> Create an obselSelector in the <code>obselsSelector</code> section of the xml descriptor. Example : <code> &lt;obselSelector id='Document'        selector="SelectorRegexp" selectorParams="type,Document" /&gt;</code> </li>
     *         <li> Use the id in the CSS file to assign the skin : <code> timeline|ObselSkin.Document { .... } </code> </li>
     * </ol>
     * </p>
     *
     */
    public class ObselSkin extends SkinnableComponent
    {

        [SkinPart]
        /*
         * The leftGrip property is defined here to allow its management when two duratives overlap
         * This is probably not the best solution.....
         */
        public  var leftGrip        : UIComponent;
        [SkinPart]
        /*
         * The rightGrip property is defined here to allow its management when two duratives overlap
         * This is probably not the best solution.....
         */
        public  var rightGrip        : UIComponent;

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
         * TODO : comment
         */
        private var _dragArea:UIComponent = null;
        private var dragAreaChange:Boolean;

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
            toolTip = _obsel.toString();

            this.addEventListener(ToolTipEvent.TOOL_TIP_SHOW, handle_tooltip_event);
            this.addEventListener(DragEvent.DRAG_START, handle_drag_start_event);
            this.setStyle("dragEnabled", "true");
            this.setStyle("dragMoveEnabled", "true");
        }

        private function handle_tooltip_event(event: ToolTipEvent): void
        {
            if (traceline._timeline.activity !== null)
                traceline._timeline.activity.trace("ObselMouseOver", { uri: obsel.uri, tooltip: event.toolTip.text });            
        }
        private function handle_drag_start_event(event: DragEvent): void
        {
            if (traceline._timeline.activity !== null)
                traceline._timeline.activity.trace("ObselStartDrag", { uri: obsel.uri });
        }

        /**
         * @return The obsel
         */
        public function get obsel () : Obsel
        {
            return _obsel;
        }

        /**
         * set drag area of the obsels
         */
        public function set dragArea(value:UIComponent):void
        {
            dragAreaChange = true;
            _dragArea = value;
            invalidateProperties();
        }
        public function get dragArea():UIComponent
        {
            return _dragArea;
        }

        /**
         * Popup a generic edit dialog.
         * @param event
         */
        public function editObsel ( event : Event ) : void
        {
            var editDialog:ObselGenericEditDialog = new ObselGenericEditDialog(  );
            editDialog.obsel = this;
            PopUpManager.addPopUp(editDialog, UIComponent( parentApplication), true);
            PopUpManager.centerPopUp(editDialog);
        };

        private function onMouseDown(event:MouseEvent):void
        {
            // Dispatcher
            var moveObselEvent:ObselEvent = new ObselEvent(ObselEvent.MOUSE_DOWN_OBSEL);
            moveObselEvent.value = this;
            moveObselEvent.event = event;

            if (traceline._timeline.activity !== null)
                traceline._timeline.activity.trace("ObselClick",  { uri: _obsel.uri });
            this.dispatchEvent(moveObselEvent);
        }

        //_____________________________________________________________________
        //
        // Overridden Methods
        //
        //_____________________________________________________________________

        override protected function commitProperties():void
        {
            super.commitProperties();
            if(dragAreaChange)
            {
                dragAreaChange = false;
                if(dragArea)
                {
                    dragArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                }
            }
        }
    }
}