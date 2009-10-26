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
	
	/**
	 * Permet de stocker en mémoire les arcs.
	 *
	 * @author Alexis Jacomy
	 */
	public class Edge extends Sprite {
		
		public var idSource:Number;
		public var idTarget:Number;
		public var arrow:Sprite;
		
		public function Edge(newIdSource:Number,newIdTarget:Number){
			
			idSource = newIdSource;
			idTarget = newIdTarget;
			
			arrow = new Sprite();
		}

		public function get idSourceAccess():Number {
			return idSource;
		}
		public function get idTargetAccess():Number {
			return idTarget;
		}
		public function drawArrow(globalGraph:Graph){
			var nodeTo:Node = globalGraph.getNode(idTarget);
			var nodeFrom:Node = globalGraph.getNode(idSource);
			
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
			
			var dist:Number = Math.sqrt((tempX2-tempX1)^2+(tempY2-tempY1)^2);
			
			var x_end:Number = tempX2-nodeTo.diameter*(tempX2-tempX1)/dist;
			var y_end:Number = tempY2-nodeTo.diameter*(tempY2-tempY1)/dist;

			var x_1:Number = (tempX1+x_end)/2 + (y_end-tempY1)/7;
			var y_1:Number = (tempY1+y_end)/2 + (tempX1-x_end)/7;
			
			var x_2:Number = (tempX1+x_end)/2 - (y_end-tempY1)/7;
			var y_2:Number = (tempY1+y_end)/2 - (tempX1-x_end)/7;
			
			var x_3:Number = (x_1+x_end)/2;
			var y_3:Number = (y_1+y_end)/2;
			
			var x_4:Number = (x_2+x_end)/2;
			var y_4:Number = (y_2+y_end)/2;
			
			arrow.graphics.lineStyle(0.3,nodeFrom.colorUInt);
			arrow.graphics.moveTo(tempX1,tempY1);
			arrow.graphics.lineTo(tempX2,tempY2);
			arrow.graphics.lineTo(x_3,y_3);
			arrow.graphics.moveTo(x_4,y_4);
			arrow.graphics.lineTo(tempX2,tempY2);
			
			addChild(arrow);
		}
		
	}
	
}