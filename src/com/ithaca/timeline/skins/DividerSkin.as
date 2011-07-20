package com.ithaca.timeline.skins
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.events.FlexEvent;
	import spark.components.supportClasses.Skin;
	
	[HostComponent("com.ithaca.timeline.Divider")]
	public class DividerSkin extends Skin
	{						
			[Bindable]
			public var dividerWidth : Number = 5;			
			[Bindable]
			public var leftMinSize : Number =0;
			[Bindable]
			public var rightMinSize : Number =0;
			
			protected var currentCenterDragingPoint:Point;
			public var startEdge:Number =1000;			
			public var endEdge:Number = 0;
			
			public function DividerSkin()
			{
				super();
				addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete);		
			}
		
			protected function onCreationComplete(e:Event):void
			{
				leftMinSize  = hostComponent.leftMinSize - hostComponent.x;
				rightMinSize = hostComponent.rightMinSize;
			}
			
			protected function dividerStartDrag(e:MouseEvent):void
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,dividerDragging);
				stage.addEventListener(MouseEvent.MOUSE_UP,dividerStopDrag);
				
				currentCenterDragingPoint = new Point( e.localX, e.localY );
			}
			
			protected function dividerDragging(e:MouseEvent):void
			{
				var parentMouse:Point = this.parent.globalToLocal(new Point(e.stageX, e.stageY));
				
				leftMinSize  = hostComponent.leftMinSize - hostComponent.x;
				rightMinSize = hostComponent.rightMinSize;
							
				var newX : Number = parentMouse.x - currentCenterDragingPoint.x;				
				if ( newX < leftMinSize ) 
					x = leftMinSize;
				else if ( parent.width - newX < rightMinSize )				
					x = width - rightMinSize;
				else
					x = newX;												
			}
			
			protected function dividerStopDrag(e:MouseEvent):void
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,dividerDragging);
				stage.removeEventListener(MouseEvent.MOUSE_UP,dividerStopDrag);		
			}
	}
}