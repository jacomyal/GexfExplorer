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

package com.GEXFExplorer.y2009.visualization {
	
	import flash.ui.Keyboard;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.GEXFExplorer.y2009.ui.*;
	import com.GEXFExplorer.y2009.data.*;
	import com.GEXFExplorer.y2009.loading.*;
	
	/**
	 * Gère l'affichage du graphe, et contient tous les éléments qui s'affichent à l'écran.
	 *
	 * @author Alexis Jacomy
	 */
	public class PlotGraph extends Sprite{
		
		public static const GRAPH_DRAWN:String = "Graph drawn";
		
		public var ratio:Number;
		public var globalGraph:Graph;
		public var edgesContainer:Sprite;
		public var nodesContainer:Sprite;
		public var textsContainer:Sprite;
		public var hitAreasContainer:Sprite;
		public var quadtree:Quadtree;
		public var ifShowLabels:Boolean;
		
		public var clickable:Boolean;
		public var curved:Boolean;
		public var edgesThickness:Number;
		
		public var optWin:OptionsWindow;
		
		public function PlotGraph(gGraph:Graph,s:Stage,newEdgesThickness=1,clickableNodes:Boolean=false,curvedEdges:Boolean=false){
			
			globalGraph = gGraph;
			clickable = clickableNodes;
			curved = curvedEdges;
			edgesThickness = newEdgesThickness;
			
			s.addChild(this);
			ratio = 1;
			
			edgesContainer = new Sprite();
			nodesContainer = new Sprite();
			textsContainer = new Sprite();
			hitAreasContainer = new Sprite();
			
			ifShowLabels = true;
			
			quadtree = new Quadtree(3,this);
			quadtree.actualize();
			
			scaleAndFixeGraph();
			
			var nodeRadius:Number = Math.floor((400/ratio)/(globalGraph.getNodes().length)^2);
			
			var tempQuad:Quad;
			var thisNode:Node;
			var thisEdge:Edge;
			var i:Number;
			
			for each(tempQuad in quadtree.fullAreasArray){
				for each(thisNode in tempQuad.nodesArray){
					plotNode(thisNode);
					plotHitArea(thisNode);
					thisNode.setTextStyle();
					if(clickable) thisNode.activateClickableURL();
					
					for (i = 0;i<thisNode.getEdgesTo().length;i++){
						thisEdge = thisNode.getEdgesTo()[i];
						if(curved) plotCurvedEdge(thisEdge);
						else plotLinearEdge(thisEdge);
						tempQuad.edgesContainer.addChild(thisEdge);
					}
					
					tempQuad.nodesContainer.addChild(thisNode);
					tempQuad.textsContainer.addChild(thisNode.labelText);
					tempQuad.hitAreasContainer.addChild(thisNode.circleHitArea);
				}
				
				edgesContainer.addChild(tempQuad.edgesContainer);
				nodesContainer.addChild(tempQuad.nodesContainer);
				textsContainer.addChild(tempQuad.textsContainer);
				hitAreasContainer.addChild(tempQuad.hitAreasContainer);
			}
			
			addChild(edgesContainer);
			addChild(nodesContainer);
			addChild(textsContainer);
			addChild(hitAreasContainer);
			
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, zoomScene);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, moveSceneWithKeyboard);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, dragScene);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, dropScene);
			
			dispatchEvent(new Event(GRAPH_DRAWN));
			
			optWin = new OptionsWindow(this);
			
			trace("Graph drawn.");
		}
	
		public function scaleAndFixeGraph():void{
			trace("Scale the graph");
			var xMin:Number = globalGraph.getNodes()[0].x;
			var xMax:Number = globalGraph.getNodes()[0].x;
			var yMin:Number = globalGraph.getNodes()[0].y;
			var yMax:Number = globalGraph.getNodes()[0].y;
			
			for (var i:Number = 1;i<globalGraph.getNodes().length;i++){
				if(globalGraph.getNodes()[i].x < xMin)
					xMin = globalGraph.getNodes()[i].x;
				if(globalGraph.getNodes()[i].x > xMax)
					xMax = globalGraph.getNodes()[i].x;
				if(globalGraph.getNodes()[i].y < yMin)
					yMin = globalGraph.getNodes()[i].y;
				if(globalGraph.getNodes()[i].y > yMax)
					yMax = globalGraph.getNodes()[i].y;
			}
			
			trace("xMax: "+xMax+", xMin: "+xMin+", yMax: "+yMax+", yMin: "+yMin);
			
			
			var xCenter:Number = (xMax + xMin)/2;
			var yCenter:Number = (yMax + yMin)/2;
			
			var xSize:Number = xMax - xMin;
			var ySize:Number = yMax - yMin;
			
			if (xSize>ySize){
				ratio = stage.stageWidth/(xSize);
			}
			else{
				ratio = stage.stageHeight/(ySize);
			}
			
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			this.scaleX = ratio;
			this.scaleY = ratio;
		}
		
		public function plotArrowEdge(tempEdge:Edge){
			tempEdge.drawArrow(globalGraph);
		}
		
		public function plotLinearEdge(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNodes()[globalGraph.getNodeRegularId(tempEdge.idTargetAccess)];
			var nodeFrom:Node = globalGraph.getNodes()[globalGraph.getNodeRegularId(tempEdge.idSourceAccess)];
			
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
			
			tempEdge.graphics.clear();
			tempEdge.graphics.lineStyle(edgesThickness,nodeFrom.colorUInt);
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.lineTo(tempX2,tempY2);
			
		}
		
		public function plotCurvedEdge(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNodes()[globalGraph.getNodeRegularId(tempEdge.idTargetAccess)];
			var nodeFrom:Node = globalGraph.getNodes()[globalGraph.getNodeRegularId(tempEdge.idSourceAccess)];
			
			var tempX2:Number = nodeFrom.x;
			var tempY2:Number = nodeFrom.y;
			var tempX1:Number = nodeTo.x;
			var tempY1:Number = nodeTo.y;
			
			var x_controle:Number = (tempX1+tempX2)/2 - (tempY2-tempY1)/4;
			var y_controle:Number = (tempY1+tempY2)/2 - (tempX1-tempX2)/4;
			
			tempEdge.graphics.lineStyle(edgesThickness,nodeFrom.colorUInt);
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.curveTo(x_controle,y_controle,tempX2,tempY2);
		}
		
		public function plotNode(tempNode:Node):void{
			tempNode.graphics.clear();
			
			tempNode.graphics.beginFill(tempNode.colorUInt,1);
			tempNode.graphics.drawCircle(0,0,tempNode.diameter/2*tempNode.ratio);
			tempNode.graphics.beginFill(0xFFFFFF,0.2);
			tempNode.graphics.drawCircle(0,0,3*tempNode.diameter/10*tempNode.ratio);
		}
		
		public function plotHitArea(tempNode:Node):void{
			tempNode.circleHitArea.graphics.clear();
			
			tempNode.circleHitArea.x = tempNode.x;
			tempNode.circleHitArea.y = tempNode.y;
			tempNode.circleHitArea.graphics.beginFill(0xFFFFFF,0);
			tempNode.circleHitArea.graphics.drawCircle(0,0,3*tempNode.diameter/10*tempNode.ratio);
			tempNode.hitArea = tempNode.circleHitArea;
			
			tempNode.circleHitArea.mouseEnabled = true;
			tempNode.circleHitArea.addEventListener(MouseEvent.MOUSE_OVER,tempNode.onMouseMoveOverNode);
			tempNode.circleHitArea.addEventListener(MouseEvent.MOUSE_OUT,tempNode.onMouseMoveOutNode);
		}
		
		public function actualizeSize(newRatio:Number,tempNode:Node,ifLabels:Boolean){
			tempNode.ratio = newRatio;
			tempNode.labelText.y -= tempNode.labelText.height/2;
			plotNode(tempNode);
			plotHitArea(tempNode);
			if(ifLabels) tempNode.setTextStyle();
		}
		
		public function moveSceneWithKeyboard(evt:KeyboardEvent):void{
			switch(evt.keyCode)
			{
			   case Keyboard.LEFT:
				  this.x+=20;
				  break;
			   case Keyboard.UP:
				  this.y+=20;
				  break;
			   case Keyboard.RIGHT:
				  this.x-=20;
				  break;
			   case Keyboard.DOWN:
				  this.y-=20;
				  break;
			   default :
			}
		}

		protected function zoomScene(evt:MouseEvent):void{
			trace("Zoom :");
			trace("   -> Mouse : localX : "+evt.localX+", localY : "+evt.localY);
			trace("   -> Mouse : stageX : "+(evt.stageX-275)+", stageY : "+(evt.stageY-200));
			trace("   -> Scene : x : "+this.x+", y : "+this.y);
			var tempX:Number = new Number(this.x);
			var tempY:Number = new Number(this.y);
			if (evt.delta>=0){
				this.x = evt.stageX+(this.x-evt.stageX)*1.2;
				this.y = evt.stageY+(this.y-evt.stageY)*1.2;
				this.scaleX *= 1.2;
				this.scaleY *= 1.2;
			}
			else {
				this.x = evt.stageX+(this.x-evt.stageX)*5/6;
				this.y = evt.stageY+(this.y-evt.stageY)*5/6;
				this.scaleX *= 5/6;
				this.scaleY *= 5/6;
			}
			
			//checkQuadtree();
		}
		
		protected function dragScene(evt:MouseEvent):void{
			if(stage.displayState== "fullScreen"){
				if((evt.stageX>=stage.fullScreenWidth-104)&&(evt.stageY>=stage.fullScreenHeight-129)){
				}else{
					if(this.contains(textsContainer)){
						this.removeChild(textsContainer);
					}
					this.startDrag();
				}
			}else{
				if(this.contains(textsContainer)){
					this.removeChild(textsContainer);
				}
				this.startDrag();
			}
		}
		
		protected function dropScene(evt:MouseEvent):void{
			if(ifShowLabels){
				this.removeChild(hitAreasContainer);
				this.addChild(textsContainer);
				this.addChild(hitAreasContainer);
			}
			this.stopDrag();
			
			//checkQuadtree();
		}
		
		protected function checkQuadtree(){
			var tempQuad:Quad;
			
			for each(tempQuad in quadtree.fullAreasArray){
				if(quadtree.isOnScreen(tempQuad.quadPosition)){
					addAllChild(tempQuad);
				}else{
					removeAllChild(tempQuad);
				}
			}
		}
		
		protected function addAllChild(tempQuad:Quad){
			edgesContainer.addChild(tempQuad.edgesContainer);
			nodesContainer.addChild(tempQuad.nodesContainer);
			textsContainer.addChild(tempQuad.textsContainer);
			hitAreasContainer.addChild(tempQuad.hitAreasContainer);
		}
		
		protected function removeAllChild(tempQuad:Quad){
			if(edgesContainer.contains(tempQuad.edgesContainer)) edgesContainer.removeChild(tempQuad.edgesContainer);
			if(nodesContainer.contains(tempQuad.nodesContainer)) nodesContainer.removeChild(tempQuad.nodesContainer);
			if(textsContainer.contains(tempQuad.textsContainer)) textsContainer.removeChild(tempQuad.textsContainer);
			if(hitAreasContainer.contains(tempQuad.hitAreasContainer)) hitAreasContainer.removeChild(tempQuad.hitAreasContainer);
		}
	}
	
}