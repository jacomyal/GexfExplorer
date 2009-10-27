/*
# Copyright (c) 2009 Alexis Jacomy <alexis.jacomy@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

package com.GEXFExplorer.y2009.data{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.net.URLRequest;
    import flash.net.navigateToURL;
	
	/**
	 * Permet de stocker en mémoire les noeuds.
	 *
	 * @author Alexis Jacomy
	 */
	public class Node extends Sprite {
		
		public var id:Number;
		public var regularId:Number;
		public var labelText:TextField;
		public var labelStyle:TextFormat;
		
		public var diameter:Number;
		public var ratio:Number;
		public var colorUInt:uint;
		public var labelColorUInt:uint;
		public var font:String;
		
		public var circleHitArea:Sprite;
		public var onMouseOverNodeSprite:Sprite;
		
		private var label:String;
		private var edgesListTo:Vector.<Edge>;
		private var edgesListFrom:Vector.<Edge>;
		
		public function Node(newId:Number, newRegularId:Number, newLabel:String, newLabelColor:uint, newFont:String) {
			
			font = newFont;
			labelStyle = new TextFormat(font);
			labelColorUInt = newLabelColor;
			
			circleHitArea = new Sprite();
			onMouseOverNodeSprite = new Sprite();
			
			edgesListTo = new Vector.<Edge>();
			edgesListFrom = new Vector.<Edge>();
			label = newLabel;
			
			id = newId;
			regularId = newRegularId;
			diameter = new Number();
			ratio = 7.5;
			
			hitArea = circleHitArea;
			
			circleHitArea.mouseEnabled = true;
			
			labelText = new TextField();
			labelText.autoSize = TextFieldAutoSize.CENTER;
			labelText.text = label;
			labelText.setTextFormat(labelStyle);
			labelStyle.size = 1*diameter/3;
			labelText.textColor = labelColorUInt;
		}

		public function get idAccess():Number {
			return id;
		}
		
		public function get labelAccess():String {
			return label;
		}
		
		public function getEdgesFrom():Vector.<Edge>{
			return edgesListFrom;
		}
		
		public function getEdgesTo():Vector.<Edge>{
			return edgesListTo;
		}
		
		public function addEdgeFrom(newEdge:Edge):void {
			edgesListFrom.push(newEdge);
		}
		
		public function addEdgeTo(newEdge:Edge):void {
			edgesListTo.push(newEdge);
		}
		
		public function setColor(B:String,G:String,R:String):void{
			var tempColor:String ="0x"+dec2hex(R)+dec2hex(G)+dec2hex(B);
			colorUInt = new uint(tempColor);
		}
		
		public function activateClickableURL(){
			circleHitArea.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function unactivateClickableURL(){
			circleHitArea.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function onClick(evt:MouseEvent){
			var tempURL:URLRequest = new URLRequest(label.replace(" ","_")+".htm");
			navigateToURL(tempURL);
		}
		
		public function onMouseMoveOverNode(evt:MouseEvent){
			trace("Mouse over node "+label);
			
			var tempParent = parent;
			var tempGParent = parent.parent.parent;
			
			Mouse.cursor = flash.ui.MouseCursor.BUTTON;
			
			with(onMouseOverNodeSprite.graphics){
				clear();
				beginFill(colorUInt,1);
				drawCircle(0,0,8*diameter/10*ratio);
				beginFill(0xFFFFFF,0.6);
				drawCircle(0,0,8*diameter/10*ratio);
				beginFill(0xFFFFFF,0.6);
				drawCircle(0,0,5*diameter/10*ratio);
			}
			
			onMouseOverNodeSprite.x = x;
			onMouseOverNodeSprite.y = y;
			
			tempParent.removeChild(this);
			tempParent.addChild(this);
			
			labelStyle.bold = true;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = colorUInt;
			
			tempGParent.addChildAt(onMouseOverNodeSprite,tempGParent.getChildIndex(tempGParent.hitAreasContainer)-1);
			tempGParent.textsContainer.addChild(labelText);
			tempGParent.hitAreasContainer.addChild(circleHitArea);
		}
		
		public function onMouseMoveOutNode(evt:MouseEvent){
			
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			
			var tempParent = parent;
			var tempGParent = parent.parent.parent;
			
			trace("Mouse out node "+label);
			
			tempParent.removeChild(this);
			tempParent.addChildAt(this,0);
			
			labelStyle.bold = false;
			labelText.background = false;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = labelColorUInt;
			
			tempGParent.removeChild(onMouseOverNodeSprite);
			tempGParent.hitAreasContainer.addChild(circleHitArea);
			
			tempGParent.textsContainer.addChild(labelText);
		}
		
		public function setTextStyle(){
			var tempSize:Number = 1*diameter/3;
			
			labelStyle.size = tempSize*ratio;
			labelText.setTextFormat(labelStyle);
			
			labelText.height = labelText.textHeight;
			
			labelText.x = x-labelText.width/2;
			labelText.y = y-labelText.height/2;
			
			labelText.selectable = false;
			labelText.textColor = labelColorUInt;
			
			labelText.setTextFormat(labelStyle);
		}

		private function d2h( d:int ) : String {
			var c:Array = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ];
			if( d> 255 ) d = 255;
			var l:int = d / 16;
			var r:int = d % 16;
			return c[l]+c[r];
		}
		
		private function dec2hex( dec:String ) : String {
			var hex:String = "";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i <bytes.length; i++ )
				hex += d2h( int(bytes[i]) );
			return hex;
		}
		
	}
	
}