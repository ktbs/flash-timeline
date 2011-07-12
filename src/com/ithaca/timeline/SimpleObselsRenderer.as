package com.ithaca.timeline 
{
	import com.ithaca.traces.Obsel;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	
	public class SimpleObselsRenderer extends UIComponent 
	{
		public	var _colorMarker : uint = 0;
		
		private var _sprite 	: Sprite = new Sprite();;
		private var _obsels 	: ArrayCollection = null;
		[Bindable]
		private var _startTime 	: Number = 0;
		[Bindable]
		private var _duration 	: Number = 1;
		private var _shape 		: Shape = new Shape();
		public var _timeline	: Timeline;		
		
		public function SimpleObselsRenderer( ) 
		{
			super();						
			_sprite.addChild( _shape )
			addChild( _sprite );
			addEventListener(ResizeEvent.RESIZE, onObselsChange );
		}
		
		public function set startTime ( value : Number ) : void { _startTime = value; }
		public function set duration ( value : Number )  : void { _duration = value; }
		public function set obselsCollection( obsels : ArrayCollection ) : void
		{			
			if ( _obsels)
				_obsels.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onObselsChange);
			_obsels = obsels;
			
			onObselsChange(null);
			_obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE, onObselsChange);
		}
		
		
		public function  onTimelineChange( event : Event ) : void
		{
			_startTime = _timeline.startTime;
			_duration  = _timeline.duration;
			
			onObselsChange( null );
		}
		
		public function  onZoomContextChange( event : Event ) : void
		{
			_startTime = _timeline.zoomContext.startTime;
			_duration  = _timeline.zoomContext.duration;
			
			onObselsChange( null );
		}
		
		public function  onObselsChange( event : Event ) : void
		{
			var shape : Shape = new Shape();
					
			shape.graphics.beginFill(_colorMarker);
			shape.graphics.lineStyle(0, _colorMarker);
		
			for each (var obsel :Obsel in _obsels)
			{
				if (obsel.begin >= _startTime )
				{
					if (obsel.end <= _startTime + _duration)
						shape.graphics.drawRect( (obsel.begin - _startTime)*width/_duration , 0, 0, height);
				}
			}
			
			shape.graphics.endFill();	
		
			_sprite.removeChild( _shape );		
			_sprite.addChild( shape );
			_shape = shape;
		}
	}

}