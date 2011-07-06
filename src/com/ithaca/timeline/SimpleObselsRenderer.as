package com.ithaca.timeline 
{
	import com.ithaca.traces.Obsel;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	
	public class SimpleObselsRenderer extends UIComponent 
	{
		public	var _colorMarker : uint = 0;
		
		private var _sprite 	: Sprite = null;
		private var _obsels 	: ArrayCollection = null;		
		private var _startTime 	: Number = 0;
		private var _duration 	: Number = 0;
		private var _shape 		: Shape = null;
		
		public function SimpleObselsRenderer( w : Number, h : Number, startTime : Number, duration : Number ) 
		{
			super();			
			width  = w;
			height = h;
			_startTime = startTime;
			_duration = duration;
			_sprite = new Sprite();			
			_shape = new Shape();
			_sprite.addChild(_shape)
			addChild( _sprite );
		}
		
		
		public function set obselsCollection( obsels : ArrayCollection ) : void
		{			
			if ( _obsels)
				_obsels.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onObselsChange);
			_obsels = obsels;
			
			onObselsChange(null);
			_obsels.addEventListener( CollectionEvent.COLLECTION_CHANGE, onObselsChange);
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