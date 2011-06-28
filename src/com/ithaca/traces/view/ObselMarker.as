/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.ithaca.traces.view
{
	import com.ithaca.traces.Obsel;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	
	import spark.components.SkinnableContainer;
	
	[SkinState("normal")]
	[SkinState("disabled")]
	[SkinState("open")]
	
	public class ObselMarker extends SkinnableContainer implements IObselComponenet
	{
		private var _begin:Number;
		private var _end:Number;
		
		private var _source:Class;
		private var _text:String;
		private var _backGroundColor:uint;
		private var _parentObsel:Obsel;
		private var _order:int;
		
		private var open:Boolean;
		
		public function ObselMarker()
		{
			//TODO: implement function
			super();
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveOverObsel);
		}
		
		public function set source(value:Class):void{_source = value;}
		public function get source():Class{return this._source}
		public function set text(value:String):void{_text = value;}
		public function get text():String{return this._text}
		public function set backGroundColor(value:uint):void{_backGroundColor = value; invalidateProperties();}
		public function get backGroundColor():uint{return this._backGroundColor}
		public function set parentObsel(value:Obsel):void{_parentObsel = value;}
		public function get parentObsel():Obsel{return this._parentObsel}
		public function set order(value:int):void{_order = value;}
		public function get order():int{return this._order}
		
		
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
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		override protected function getCurrentSkinState():String
		{
			var result:String = !enabled? "disable" : open? "open" : "normal"
			return result;
		}
		
		private function onMouseMoveOverObsel(event:MouseEvent):void
		{
			var ds:DragSource = new DragSource();
			ds.addData(_parentObsel,"obsel");
			ds.addData(_text,"textObsel");	
			var imageProxy:Image = new Image();
			imageProxy.source = _source;
			imageProxy.height=this.height*0.75;
			imageProxy.width=this.width*0.75;                
			DragManager.doDrag(this,ds,event,imageProxy, -15, -15, 1.00);
		}
		
		public function cloneMe():ObselMarker
		{
			var result:ObselMarker = new ObselMarker();
			result._begin = this._begin;
			result._end = this._end;
			result.source = this.source;
			result.toolTip = this.toolTip;
			result.text = this.text;
			result.backGroundColor = this.backGroundColor;
			result._parentObsel = this.parentObsel;
			result._order = this._order;
			return result;
		}
		
		
	}
}