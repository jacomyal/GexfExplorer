/*
# Copyright (c) 2009 Jos Hirth <jh@kaioa.com>
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

package com.GEXFExplorer.y2009.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
		
	/**
	  * Makes appear the current FPS on screen.
	  * To use it, you can for example just write: "addChild(new FPSCounter());".
	  * 
	  * @param xPos x position of this Sprite.
	  * @param yPos y position of this Sprite.
	  * @param color The TextField color.
	  * @param fillBackground Boolean value which determines if you want a background behind this Sprite.
	  * @param backgroundColor Determines this background color if fillBackground==true.
	  * 
	  * @author Jos Hirth <jh@kaioa.com>
	  * @see http://kaioa.com/
	  * @see http://kaioa.com/node/83
	  */
	public class FPSCounter extends Sprite{
		
		private var last:uint = getTimer();
		private var ticks:uint = 0;
		private var tf:TextField;

		public function FPSCounter(xPos:int=0, yPos:int=0, color:uint=0xffffff, fillBackground:Boolean=false, backgroundColor:uint=0x000000) {
			x = xPos;
			y = yPos;
			tf = new TextField();
			tf.textColor = color;
			tf.text = "----- fps";
			tf.selectable = false;
			tf.background = fillBackground;
			tf.backgroundColor = backgroundColor;
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);
			width = tf.textWidth;
			height = tf.textHeight;
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function tick(evt:Event):void {
			ticks++;
			var now:uint = getTimer();
			var delta:uint = now - last;
			if (delta >= 1000) {
				//trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
				var fps:Number = ticks / delta * 1000;
				tf.text = fps.toFixed(1) + " fps";
				ticks = 0;
				last = now;
			}
		}
    }
}