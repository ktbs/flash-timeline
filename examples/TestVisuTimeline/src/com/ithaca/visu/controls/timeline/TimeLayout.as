package com.ithaca.visu.controls.timeline
{

import flash.geom.Point;

import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.LayoutBase;

import com.ithaca.traces.view.IObselComponenet;
	
public class TimeLayout extends LayoutBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function TimeLayout()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

  	private var MIN_WIDTH:int = 30;
	
	private var _durationSession:Number;
	public function set durationSession(value:Number):void
	{
		_durationSession = value;
		if (target)
			target.invalidateDisplayList();
	}
	private var _startTime:Number;
	public function set startTime(value:Number):void
	{
		_startTime = value;
		if(target)
			target.invalidateDisplayList();
	}
	
	private function calculateMinMaxTimeBeginTimeEnd():Point
	{
		var minTime:Number = _startTime;
		var maxTime:Number = 0;
		
		if(target){
			var count:int = target.numElements;
			var layoutElement:ILayoutElement;
			
			for(var i:int = 0; i < count; i++){
				
				// get the current layout element
				layoutElement = target.getElementAt(i);

				var elementObsel:IObselComponenet =layoutElement as IObselComponenet;
				var timeBegin:Number = elementObsel.getBegin();
				var timeEnd:Number   = elementObsel.getEnd();
				// check only obsel with begin > than startTime
				if(timeBegin >= _startTime)
				{
					minTime = Math.min(timeBegin, minTime);
					maxTime = Math.max(maxTime, timeEnd);
					elementObsel.setObselViewVisible(true);
				}else
				{
					elementObsel.setObselViewVisible(false);
				}
			}	
			maxTime= minTime+_durationSession;
			
		}
		return new Point(minTime, maxTime);
	}
	


    //--------------------------------------------------------------------------
    //
    //  Overridden methods: LayoutBase
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */

    override public function measure():void
    {
       /* var bounds:Point = calculateBounds();

        target.measuredWidth = bounds.x;
        target.measuredHeight = bounds.y;*/
    }

    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
		//super.updateDisplayList(unscaledWidth,unscaledHeight);
		
		target.setContentSize(unscaledWidth, unscaledHeight);	
		
        var minMaxTime:Point = calculateMinMaxTimeBeginTimeEnd();
		var delta:Number = minMaxTime.y - minMaxTime.x;
		if(target){
			var count:int = target.numElements;
			var layoutElement:ILayoutElement;
			
			for(var i:int = 0; i < count; i++){
				
				// get the current layout element
				layoutElement = target.getElementAt(i);
				
				//resize the eletement to its preferred size by passing NaN for w/h
				layoutElement.setLayoutBoundsSize(NaN,NaN);
				
				var elementObsel:IObselComponenet = layoutElement as IObselComponenet;
				var timeBegin:Number = elementObsel.getBegin();
				var timeEnd:Number   = elementObsel.getEnd();
				
				var xAbs:Number = timeBegin - minMaxTime.x;
				var koeff:Number = xAbs/delta;		
				var x:Number = target.width*koeff;
				//var y:Number = 0;
				var widthElementObse:Number;
				if(timeBegin == timeEnd){
					widthElementObse = MIN_WIDTH;
				}else
				{
					var wAbs:Number = timeEnd - minMaxTime.x;
					var wKoeff:Number = wAbs/delta;		
					var wPos:Number = target.width*wKoeff;	
					widthElementObse = wPos - x;
				}
				
				layoutElement.setLayoutBoundsSize(widthElementObse, NaN);
				layoutElement.setLayoutBoundsPosition(x,NaN);
			}				
		}
		

    }



}
}

