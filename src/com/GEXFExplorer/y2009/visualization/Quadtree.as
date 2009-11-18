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

package com.GEXFExplorer.y2009.visualization{
	
	import com.GEXFExplorer.y2009.data.Node;
	import com.GEXFExplorer.y2009.data.Quad;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	  * The Quadtree is used to reduce the number of graphic elements, and so to increase graphic performances.
	  * For the moment, I do not implement a reel quadtree, because the root can have more than 4 sons...
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  * @see http://en.wikipedia.org/wiki/Quadtree
	  * @see com.GEXFExplorer.y2009.data.Quad
	  */
	public class Quadtree{
		
		private var visualGraph:VisualGraph;
		private var nodesVector:Vector.<Node>;
		private var fullAreasArray:Array;
		private var quadtreeViz:Sprite;
		
		private var normalWidth:Number;
		private var normalHeight:Number;
		private var depth:int;
	
		/**
		  * Initializes Quadtree attributes and plot the graph, quad by quad.
		  * 
		  * @param newDepth New depth of this quadtree.
		  * @param pGraph The global visual graph.
		  */
		public function Quadtree(newDepth:int,pGraph:VisualGraph){
			depth = newDepth;
			visualGraph = pGraph;
			quadtreeViz = new Sprite();
			visualGraph.addChild(quadtreeViz);
			fullAreasArray = new Array();
		}
		
		/**
		  * Returns the quad list.
		  * 
		  * @return The quads list.
		  * @see com.GEXFExplorer.y2009.data.Quad
		  */
		public function getQuadsArray(){
			return fullAreasArray;
		}
		
		/**
		  * Actualizes the nodesVector valuea and launches setFullAreasArray().
		  * 
		  * @see #setFullAreasArray
		  */
		public function actualize(){
			nodesVector = visualGraph.getNodes();
			setFullAreasArray();
		}
		
		/**
		  * Tests the intersection between a quad and the screen.
		  * 
		  * @param arrayVar The quad position in the tree
		  * @return 1 if the intersection isn't null, else 0.
		  */
		public function isOnScreen(arrayVar:Array):Boolean{
			
			var resultBool:Boolean = true;
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempScreenWidth:Number = visualGraph.stage.stageWidth;
			var tempScreenHeight:Number = visualGraph.stage.stageHeight;
			var tempPowIx:Number = normalWidth;
			var tempPowIy:Number = normalHeight;
			
			while((resultBool==true)&&(i<depth)){
				
				tempPowIx = tempPowIx/2;
				tempPowIy = tempPowIy/2;
				
				tempTopLeft_x += tempPowIx*arrayVar[0][i];
				tempTopLeft_y += tempPowIy*arrayVar[1][i];
				
				if((tempTopLeft_x+visualGraph.x>tempScreenWidth)||
				   (tempTopLeft_x+tempPowIx+visualGraph.x<0)||
				   (tempTopLeft_y+visualGraph.y>tempScreenHeight)||
				   (tempTopLeft_y+tempPowIy+visualGraph.y<0))
				{
					resultBool = false;
					return(resultBool);
				}
				i++;
			}
			
			return(resultBool);
		}
		
		/**
		  * Returns the coordinates of the quad containing the (xVar,yVar) point.
		  * 
		  * @param xVar x position of the tested point
		  * @param yVar y position of the tested point
		  * @return The quad position in the tree.
		  */
		protected function getArrayCoordinates(xVar:Number,yVar:Number):Array{
			
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempPowIx:Number;
			var tempPowIy:Number;
			var tempArrayX:Array = new Array();
			var tempArrayY:Array = new Array();
			var tempWidth:Number = visualGraph.stage.stageWidth;
			var tempHeight:Number = visualGraph.stage.stageHeight;
			
			var tempXCase:Number;
			var tempYCase:Number;
			
			var xArray:Array = new Array();
			var yArray:Array = new Array();
			
			var resultArray:Array = new Array();
			
			for (i=0;i<depth;i++){
				tempPowIx = tempWidth/Math.pow(2,i+1);
				tempPowIy = tempHeight/Math.pow(2,i+1);
				
				tempXCase = Math.floor((xVar-tempTopLeft_x)/tempPowIx);
				tempYCase = Math.floor((yVar-tempTopLeft_y)/tempPowIy);
				
				tempTopLeft_x += tempPowIx*tempXCase;
				tempTopLeft_y += tempPowIy*tempYCase;
				
				xArray.push(tempXCase);
				yArray.push(tempYCase);
			}
			
			resultArray.push(xArray);
			resultArray.push(yArray);
			
			return(resultArray);
			
			tempSprite.graphics.endFill();
		}
		
		/**
		  * Sets the quad list, by testing for each node where is his quad.
		  * 
		  * @see com.GEXFExplorer.y2009.data.Quad
		  */
		protected function setFullAreasArray():void{
			normalWidth = visualGraph.stage.stageWidth;
			normalHeight = visualGraph.stage.stageHeight;
			
			var tempIndex:Number;
			var tempNode:Node;
			var tempCoordinatesArray:Array;
			var tempArray:Array;
			
			var tempQuadArray:Array = new Array();
			
			for each(tempNode in nodesVector){
				tempCoordinatesArray = getArrayCoordinates(tempNode.x,tempNode.y);
				tempIndex = index(tempCoordinatesArray,tempQuadArray);
				if(tempIndex==-1){
					tempQuadArray.push(tempCoordinatesArray);
					fullAreasArray.push(new Quad(tempCoordinatesArray));
					fullAreasArray[fullAreasArray.length-1].push(tempNode);
				}else{
					fullAreasArray[tempIndex].push(tempNode);
				}
			}
			
			//traceAreas();
		}
		
		/**
		  * Plots a rectangle around a quad from his position in the tree.
		  * 
		  * @param arrayVar The quad position in the tree.
		  */
		protected function drawQuadFromArray(arrayVar:Array):void{
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempPowIx:Number;
			var tempPowIy:Number;
			var tempAlpha:Number = 0.01;
			var tempArrayX:Array = new Array([]);
			var tempArrayY:Array = new Array([]);
			var tempWidth:Number = quadtreeViz.stage.stageWidth;
			var tempHeight:Number = quadtreeViz.stage.stageHeight;
			
			for (i=0;i<depth;i++){
				tempPowIx = tempWidth/Math.pow(2,i+1);
				tempPowIy = tempHeight/Math.pow(2,i+1);
				
				tempTopLeft_x += tempPowIx*arrayVar[0][i];
				tempTopLeft_y += tempPowIy*arrayVar[1][i];
				
				if(i==depth-1) quadtreeViz.graphics.beginFill(0x888888,0.1);
				quadtreeViz.graphics.lineStyle(1,0xCCCCCC,1);
				quadtreeViz.graphics.drawRect(tempTopLeft_x,tempTopLeft_y,tempPowIx,tempPowIy);
				quadtreeViz.graphics.endFill();
				
				tempAlpha = (5*tempAlpha + 1)/6;
			}
		}
		
		/**
		  * Returns the index if an array in an array of arrays.
		  * Functions like indexOf().
		  * 
		  * @param array The array to test in arrayContainer.
		  * @param arrayContainer The array of arrays.
		  * @return -1 if array is not in arrayContainer, else the index of array in arrayContainer.
		  * @see com.GEXFExplorer.y2009.data.Quad
		  */
		protected function index(array:Array,arrayContainer:Array):Number{
			
			var i:Number;
			var j:Number;
			var res:Number = -1;
			var ifOk:Boolean;
			var d:Number = array[0].length;
			
			for(i=0;i<arrayContainer.length;i++){
				j=0;
				ifOk = true;
				
				while(ifOk==true && j<d){
					if(arrayContainer[i][0][j]!=array[0][j] || arrayContainer[i][1][j]!=array[1][j]){
						ifOk=false;
					}
					
					j++;
				}
				
				if(ifOk==true){
					res = i;
					return(res);
				}
			}
			return(res);
		}
		
		/**
		  * Traces in the output the list of each quad, with the nodes it contains.
		  */
		protected function traceAreas():void{
			var tempQuad:Quad;
			var tempNode:Node;
			var i:Number = 0;
			
			for each(tempQuad in fullAreasArray){
				trace("Area n°"+i+":\n\tPosition in the tree:\n\t\ton x:("+tempQuad.positionAccess[0]+")\n\t\ton y:("+tempQuad.positionAccess[1]+")");
				for each(tempNode in tempQuad.nodesArrayAccess){
					trace("\tNode n°"+tempNode.idAccess+", x: "+tempNode.x+", y: "+tempNode.y);
				}
				
				drawQuadFromArray(tempQuad.positionAccess);
				
				i++;
			}
		}
	}
	
}