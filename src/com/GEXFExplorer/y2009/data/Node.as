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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.net.URLRequest;
    import flash.net.navigateToURL;
	
	/**
	  * Represents each node from the file in the memory.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  * @see com.GEXFExplorer.y2009.data.Edge
	  * @see com.GEXFExplorer.y2009.data.Graph
	  */
	public class Node extends Sprite {
		
		public static const SELECT = "Node selected";
		
		public var labelText:TextField;
		public var labelStyle:TextFormat;
		public var diameter:Number;
		public var ratio:Number;
		public var colorUInt:uint;
		public var labelColorUInt:uint;
		public var font:String;
		public var circleHitArea:Sprite;
		
		private var id:Number;
		private var label:String;
		private var edgesListTo:Vector.<Edge>;
		private var edgesListFrom:Vector.<Edge>;
		private var attributes:HashMap;
		
		/**
		  * Initializes the node.
		  * 
		  * @param newId Node ID
		  * @param newLabel Node label
		  * @param newLabelColor Node label color
		  * @param newFont Node label font
		  */
		public function Node(newId:Number, newLabel:String, newLabelColor:uint, newFont:String) {
			
			font = newFont;
			labelStyle = new TextFormat(font);
			labelColorUInt = newLabelColor;
			
			circleHitArea = new Sprite();
			
			edgesListTo = new Vector.<Edge>();
			edgesListFrom = new Vector.<Edge>();
			label = newLabel;
			
			id = newId;
			diameter = new Number();
			ratio = 7.5;
			
			hitArea = circleHitArea;
			
			circleHitArea.mouseEnabled = true;
			
			labelText = new TextField();
			labelText.autoSize = TextFieldAutoSize.CENTER;
			labelText.text = label;
			labelText.setTextFormat(labelStyle);
			labelText.textColor = labelColorUInt;
		}
		
		/**
		  * Returns the node ID.
		  * 
		  * @return The node ID.
		  */
		public function get idAccess():Number {
			return id;
		}
		
		/**
		  * Returns the node label.
		  * 
		  * @return The node label.
		  */
		public function get labelAccess():String {
			return label;
		}
		
		/**
		  * Returns edges which are from this node.
		  * 
		  * @return edgesListFrom
		  * @see com.GEXFExplorer.y2009.data.Edge
		  */
		public function getEdgesFrom():Vector.<Edge>{
			return edgesListFrom;
		}
		
		/**
		  * Returns edges which move into this node.
		  * 
		  * @return edgesListTo
		  * @see com.GEXFExplorer.y2009.data.Edge
		  */
		public function getEdgesTo():Vector.<Edge>{
			return edgesListTo;
		}
		
		/**
		  * Returns this node attributes.
		  * 
		  * @return This node attributes hash tab
		  */
		public function getAttributes():HashMap{
			return attributes;
		}
		
		/**
		  * Sets this node diameter.
		  * 
		  * @param d New diameter
		  */
		public function setDiameter(d:Number){
			diameter = d;
		}
		
		/**
		  * Sets this node attributes.
		  * 
		  * @param o New attributes hash tab
		  */
		public function setAttributes(o:HashMap){
			attributes = o;
		}
		
		/**
		  * Plots the node bigger than when mouse isn't over it.
		  * 
		  * @see #onMouseMoveOverNode
		  */
		public function plot():void{
			this.graphics.clear();
			this.graphics.beginFill(brightenColor(this.colorUInt,35),1);
			this.graphics.drawCircle(0,0,this.diameter/2*this.ratio);
			this.graphics.drawCircle(0,0,3.5*this.diameter/10*this.ratio);
			this.graphics.beginFill(this.colorUInt,1);
			this.graphics.drawCircle(0,0,2.75*this.diameter/10*this.ratio);
		}
		
		/**
		  * Plots the node lighter when it is selected.
		  */
		public function plotAsSelected():void{
			this.graphics.clear();
			this.graphics.beginFill(brightenColor(this.colorUInt,75),1);
			this.graphics.drawCircle(0,0,this.diameter/2*this.ratio);
			this.graphics.drawCircle(0,0,3.2*this.diameter/10*this.ratio);
			this.graphics.beginFill(brightenColor(this.colorUInt,85),1);
			this.graphics.drawCircle(0,0,2.75*this.diameter/10*this.ratio);
		}
		
		/**
		  * Select this node.
		  */
		public function select():void{
			this.graphics.clear();
			
			this.circleHitArea.removeEventListener(MouseEvent.MOUSE_OVER,onMouseMoveOverNode);
			this.circleHitArea.removeEventListener(MouseEvent.MOUSE_OUT,onMouseMoveOutNode);
			this.circleHitArea.addEventListener(MouseEvent.MOUSE_OVER,onMouseMoveOverNodeSelected);
			this.circleHitArea.addEventListener(MouseEvent.MOUSE_OUT,onMouseMoveOutNodeSelected);
			
			onMouseMoveOutNode(null);
			onMouseMoveOverNodeSelected(null);
		}
		
		/**
		  * Unselect this node.
		  */
		public function unselect():void{
			this.plot();
			
			this.circleHitArea.removeEventListener(MouseEvent.MOUSE_OVER,onMouseMoveOverNodeSelected);
			this.circleHitArea.removeEventListener(MouseEvent.MOUSE_OUT,onMouseMoveOutNodeSelected);
			this.circleHitArea.addEventListener(MouseEvent.MOUSE_OVER,onMouseMoveOverNode);
			this.circleHitArea.addEventListener(MouseEvent.MOUSE_OUT,onMouseMoveOutNode);
		}
		
		/**
		  * Adds an edge in <code>edgesListFrom</code>.
		  * 
		  * @param newEdge Edge to add.
		  */
		public function addEdgeFrom(newEdge:Edge):void {
			edgesListFrom.push(newEdge);
		}
		
		/**
		  * Adds an edge in <code>edgesListTo</code>.
		  * 
		  * @param newEdge Edge to add.
		  */
		public function addEdgeTo(newEdge:Edge):void {
			edgesListTo.push(newEdge);
		}
		
		/**
		  * Sets this node color, from three <code>Number</code> value (B, G, R) into a <code>uint</code> value.
		  * 
		  * @param B Blue value, between 0 and 255
		  * @param G Green value, between 0 and 255
		  * @param R Red value, between 0 and 255
		  * @see #decaToHexa
		  */
		public function setColor(B:String,G:String,R:String):void{
			var tempColor:String ="0x"+decaToHexa(R)+decaToHexa(G)+decaToHexa(B);
			colorUInt = new uint(tempColor);
		}
		
		/**
		  * Sets or refresh the label style.
		  */
		public function setTextStyle(scaledTextSize:Boolean=true):void{
			var tempSize:Number;
			if(!scaledTextSize) tempSize = 1;
			else tempSize = 1*diameter/3;
			
			labelStyle.size = tempSize*ratio;
			labelText.setTextFormat(labelStyle);
			
			labelText.height = labelText.textHeight;
			
			labelText.x = x-labelText.width/2;
			labelText.y = y-labelText.height/2;
			
			labelText.selectable = false;
			labelText.textColor = labelColorUInt;
			
			labelText.setTextFormat(labelStyle);
		}
		
		/**
		  * Activates the MouseEvent.CLICK event on this node (if <code>label</code> is an URL, for example).
		  */
		public function activateClickableURL():void{
			circleHitArea.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		/**
		  * Disactivates the MouseEvent.CLICK event on this node.
		  */
		public function unactivateClickableURL():void{
			circleHitArea.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		/**
		  * Opens a new window, with <code>label</code> as URL, when this node is clicked.
		  * 
		  * @param evt MouseEvent.CLICK
		  */
		public function onClick(evt:MouseEvent):void{
			var tab:Array = ["http://","www.",".fr",".org",".fr",".net"];
			var test:Boolean = false;
			for(var i:int=0;i<tab.length;i++){
				if(label.indexOf(tab[i])>=0){
					test = true;
					break;
				}
			}
			var tempURL:URLRequest = new URLRequest(label);
			if(test && stage.root.loaderInfo.parameters["clickableNodes"]) navigateToURL(tempURL);
			
			dispatchEvent(new Event(SELECT));
		}
		
		/**
		  * Changes the display of this node while mouse is over it.
		  * 
		  * @param evt MouseEvent.MOUSE_OVER
		  */
		public function onMouseMoveOverNode(evt:MouseEvent):void{
			with(this.graphics){
				clear();
				beginFill(brightenColor(colorUInt,35),1);
				drawCircle(0,0,diameter/1.5*ratio);
				drawCircle(0,0,3.5*diameter/7.5*ratio);
				beginFill(colorUInt,1);
				drawCircle(0,0,2.75*diameter/7.5*ratio);
			}
			
			Mouse.cursor = flash.ui.MouseCursor.BUTTON;
			labelStyle.bold = true;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = brightenColor(colorUInt,20);
		}
		
		/**
		  * Returns the display as the other nodes when mouse left <code>hitArea</code>.
		  * 
		  * @param evt MouseEvent.MOUSE_OUT
		  */
		public function onMouseMoveOutNode(evt:MouseEvent):void{
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			labelStyle.bold = false;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = labelColorUInt;
			
			this.plot();
		}
		
		/**
		  * Changes the display of this node while mouse is over it and when it is selected.
		  * 
		  * @param evt MouseEvent.MOUSE_OVER
		  */
		public function onMouseMoveOverNodeSelected(evt:MouseEvent):void{
			with(this.graphics){
				clear();
				beginFill(brightenColor(colorUInt,75),1);
				drawCircle(0,0,diameter/1.5*ratio);
				drawCircle(0,0,3.5*diameter/7.5*ratio);
				beginFill(brightenColor(colorUInt,85),1);
				drawCircle(0,0,2.75*diameter/7.5*ratio);
			}
			
			Mouse.cursor = flash.ui.MouseCursor.BUTTON;
			labelStyle.bold = true;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = brightenColor(colorUInt,20);
		}
		
		/**
		  * Returns the display as the other nodes when mouse left <code>hitArea</code> and when it is selected.
		  * 
		  * @param evt MouseEvent.MOUSE_OUT
		  */
		public function onMouseMoveOutNodeSelected(evt:MouseEvent):void{
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			labelStyle.bold = false;
			
			labelText.setTextFormat(labelStyle);
			labelText.textColor = labelColorUInt;
			
			this.plotAsSelected();
		}
		
		/**
		  * Transforms a decimal value (int formated) into an hexadecimal value.
		  * Is only useful with the other function, decaToHexa.
		  * 
		  * @param d int formated decimal value
		  * @return Hexadecimal string translation of d
		  * 
		  * @author Ammon Lauritzen
		  * @see http://goflashgo.wordpress.com/
		  * @see #decaToHexa
		  */
		private function decaToHexaFromInt(d:int):String{
			var c:Array = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
			if(d>255) d = 255;
			var l:int = d/16;
			var r:int = d%16;
			return c[l]+c[r];
		}
		
		/**
		  * Transforms a decimal value (string formated) into an hexadecimal value.
		  * Really helpfull to adapt the RGB gexf color format in AS3 uint format.
		  * 
		  * @param dec String formated decimal value
		  * @return Hexadecimal string translation of dec
		  * 
		  * @author Ammon Lauritzen
		  * @see http://goflashgo.wordpress.com/
		  */
		private function decaToHexa(dec:String):String {
			var hex:String = "";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i <bytes.length; i++ )
				hex += decaToHexaFromInt( int(bytes[i]) );
			return hex;
		}
		
		/**
		  * Makes a uint color become brigther or darker, depending of the parameter.
		  * If the <code>perc</code> parameter is above 50, it will brighten the color.
		  * If the parameter is below 50, it will darken it.
		  * 
		  * @param color Original color value, such as 0x88AACC.
		  * @param perc Value between 0 and 100 to modify original color.
		  * @return New color value (still such as 0x113355)
		  * 
		  * @author Martin Legris
		  * @see http://blog.martinlegris.com
		  */
		protected function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
	}
}