package com.ithaca.timeline
{
	import flash.events.Event;
	import mx.events.FlexEvent;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;

	public class ZoomContext  extends SkinnableContainer
	{
		[SkinPart(required="true")]
		public var maxRange	 	: SkinnableComponent;
		[SkinPart(required="true")]
		public var minRange		: SkinnableComponent;
		[SkinPart(required="true")]
		public var cursor	 		: SkinnableComponent;
		[SkinPart(required="true")]
		public var timelinePreview	 	: SkinnableComponent;
		
		public var _timeline	    : Timeline;
		
		public var startTime		: Number = 0;
		public var duration			: Number = 1000;	
		
		
		public function ZoomContext() : void 
		{
			super();
			
		}
		
		public function updateSkinPositionFromValues() : void
		{
			if ( cursor && _timeline && timelinePreview)
			{		
				cursor.width 	= duration * timelinePreview.width / _timeline.duration;
				cursor.x 		= timelinePreview.x +  (startTime - _timeline.startTime ) * timelinePreview.width / _timeline.duration;
				minRange.x 		=  cursor.x -minRange.width;
				maxRange.x 		=  Math.min(cursor.x + cursor.width, timelinePreview.width+timelinePreview.x -1);
			}
		}
		
		public function updateValuesFromSkinPosition() : void
		{
			trace(" st : " + startTime + ", d :" +duration);
			startTime 	=  _timeline.startTime + (cursor.x -timelinePreview.x)* _timeline.duration / timelinePreview.width;
			duration 	=  cursor.width * _timeline.duration / timelinePreview.width;
		}		
	}
}