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
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObjectContainer;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import com.GEXFExplorer.y2009.ui.OptionsWindow;
	import com.GEXFExplorer.y2009.ui.FPSCounter;
	import com.GEXFExplorer.y2009.data.Graph;
	import com.GEXFExplorer.y2009.data.Edge;
	import com.GEXFExplorer.y2009.data.Node;
	import com.GEXFExplorer.y2009.data.Quad;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
 
	/**
	  * Contains each graphic element directly regarding some data (currently nodes and edges).
	  * All the methods to draw graphic elements (except for the debug) are here.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  */
	public class VisualGraph extends Sprite{
 
		public static const GRAPH_DRAWN:String = "Graph drawn";
		public static const SELECT:String = "New node has been selected";
 
		public var edgesContainer:Sprite;
		public var nodesContainer:Sprite;
		public var textsContainer:Sprite;
		public var hitAreasContainer:Sprite;
 
		private var selectedNodeId:int;
		private var edgesColor:uint;
		private var ratio:Number;
		private var globalGraph:Graph;
		private var quadtree:Quadtree;
		private var clickableAttribute:String;
		private var curved:Boolean;
		private var ifShowLabels:Boolean;
		private var clickableNodes:Boolean;
		private var edgesColorTest:Boolean;
		private var scaledTextSize:Boolean;
		private var edgesThickness:Number;
		private var optionsWindow:OptionsWindow;
 
		/**
		  * Initializes VisualGraph attributes and plot the graph, quad by quad.
		  * 
		  * @param gGraph The global graph.
		  * @param s Main stage (it's easier to use like this).
		  * @see com.GEXFExplorer.y2009.visualization.Quadtree
		  */
		public function VisualGraph(gGraph:Graph,s:Stage){
			s.addChildAt(this,0);
			globalGraph = gGraph;
 
			optionsWindow = new OptionsWindow(this);
 
			if(root.loaderInfo.parameters["fps"]=="true") s.addChild(new FPSCounter(10,6,0xFFAA66));
 
			if(root.loaderInfo.parameters["clickableNodes"]=="false"){clickableNodes = false;}
			else{clickableNodes = true;}
 
			if(root.loaderInfo.parameters["edgesThickness"]==undefined){edgesThickness = 1;}
			else{edgesThickness = new Number(root.loaderInfo.parameters["edgesThickness"]);}
 
			if(root.loaderInfo.parameters["clickableAttribute"]==undefined){clickableAttribute = null;}
			else{
				clickableAttribute = new String(root.loaderInfo.parameters["url"]);
				clickableNodes = false;
			}
 
			//if(root.loaderInfo.parameters["path"]==undefined){clickableAttribute = "url"; clickableNodes = false;}
 
			if(root.loaderInfo.parameters["scaledTextSize"]=="false"){scaledTextSize = false;}
			else{scaledTextSize = true;}
 
			if(root.loaderInfo.parameters["edgesColor"]==undefined){edgesColorTest = false;}
			else{
				edgesColor = new uint(root.loaderInfo.parameters["edgesColor"]);
				edgesColorTest = true;
			}
 
			if(root.loaderInfo.parameters["curvedEdges"]=="true"){curved = true;}
			else{curved = false;}
 
			edgesContainer = new Sprite();
			nodesContainer = new Sprite();
			textsContainer = new Sprite();
			hitAreasContainer = new Sprite();
 
			ifShowLabels = true;
			if(root.loaderInfo.parameters["quadtreeDepth"]==undefined) quadtree = new Quadtree(2,this);
			else quadtree = new Quadtree(root.loaderInfo.parameters["quadtreeDepth"],this);
			quadtree.actualize();
 
			scaleAndFixeGraph();
 
			var nodeRadius:Number = Math.floor((400/ratio)/(globalGraph.getNodes.length)^2);
 
			var tempQuad:Quad;
			var thisNode:Node;
			var thisEdge:Edge;
			var i:Number;
 
			addChild(edgesContainer);
			addChild(nodesContainer);
			addChild(textsContainer);
			addChild(hitAreasContainer);
 
			for each(tempQuad in quadtree.getQuadsArray()){
				edgesContainer.addChild(tempQuad.edgesContainer);
				nodesContainer.addChild(tempQuad.nodesContainer);
				textsContainer.addChild(tempQuad.textsContainer);
				hitAreasContainer.addChild(tempQuad.hitAreasContainer);
 
				for each(thisNode in tempQuad.nodesArrayAccess){
					tempQuad.nodesContainer.addChild(thisNode);
 
					thisNode.plot();
 
					thisNode.setTextStyle(scaledTextSize);
 
					thisNode.addEventListener(Node.CLICK,onClickANode);
					plotHitArea(thisNode);
 
					var key:String = globalGraph.getAttributeKey(clickableAttribute);
 
					if(clickableNodes){
						thisNode.setURL();
						thisNode.activateClickableURL();
					}
					else if(clickableAttribute!=null){
						thisNode.setURL(thisNode.getAttributes().getValue(key));
						thisNode.activateClickableURL();
					}
 
					for (i = 0;i<thisNode.getEdgesTo().length;i++){
						thisEdge = thisNode.getEdgesTo()[i];
						if(edgesColorTest){
							if(curved) plotCurvedEdge(thisEdge);
							else plotLinearEdge(thisEdge);
						}else{
							if(curved) plotCurvedEdgeWithNodeColor(thisEdge);
							else plotLinearEdgeWithNodeColor(thisEdge);
						}
						tempQuad.edgesContainer.addChild(thisEdge);
					}
 
					tempQuad.textsContainer.addChild(thisNode.labelText);
					tempQuad.hitAreasContainer.addChild(thisNode.circleHitArea);
				}
			}
 
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, moveSceneWithKeyboard);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, dropScene);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, zoomScene);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, dragScene);
 
			dispatchEvent(new Event(GRAPH_DRAWN));
 
			trace("Graph drawn.");
		}
 
		/**
		  * Returns the graph.
		  * 
		  * @return The global graph.
		  * @see com.GEXFExplorer.y2009.data.Graph
		  */
		public function getGraph():Graph{
			return globalGraph;
		}
 
		/**
		  * Returns the selected node label.
		  * 
		  * @return The selected node label.
		  */
		public function getSelectedNode():Node{
			return globalGraph.getNode(selectedNodeId);
		}
 
		/**
		  * Returns the nodes vector.
		  * 
		  * @return The global nodes vector.
		  */
		public function getNodes():Vector.<Node>{
			return globalGraph.getNodes;
		}
 
		/**
		  * Select a node when user clicks on it.
		  * 
		  * @param e Node.CLICK
		  */
		public function onClickANode(e:Event):void{
			selectNode(e.target as Node);
		}
 
		/**
		  * Sets selectedNodeLabel.
		  * 
		  * @param n New selected node
		  */
		public function selectNode(n:Node):void{
			var currentSelection:Node = globalGraph.getNode(selectedNodeId);
 
			currentSelection.unselect();
			if(!unselectEdges(currentSelection))trace("Problem:\n\tOld selected node not found (number "+selectedNodeId+").");
 
			selectedNodeId = n.idAccess;
			n.select();
			selectEdges(n);
 
			dispatchEvent(new Event(SELECT));
		}
 
		/**
		  * Plots each node from/to the parameter node as selected edge.
		  * 
		  * @param n The selected node.
		  */
		public function selectEdges(n:Node):void{
			var e:Edge;
			var i:int = 0;
			var o:int = 0;
 
			if(edgesColorTest){
				if(curved){
					for each(e in n.getEdgesFrom()){
						plotCurvedEdgeAsSelected(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotCurvedEdgeAsSelected(e);
						i++;
					}
				}else{
					for each(e in n.getEdgesFrom()){
						plotLinearEdgeAsSelected(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotLinearEdgeAsSelected(e);
						i++;
					}
				}
			}else{
				if(curved){
					for each(e in n.getEdgesFrom()){
						plotCurvedEdgeAsSelectedWithNodeColor(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotCurvedEdgeAsSelectedWithNodeColor(e);
						i++;
					}
				}else{
					for each(e in n.getEdgesFrom()){
						plotLinearEdgeAsSelectedWithNodeColor(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotLinearEdgeAsSelectedWithNodeColor(e);
						i++;
					}
				}
			}
 
			trace(n.labelAccess+" node:\n\t"+i+" in edges drawn as selected / "+o+" out edges drawn as selected.");
		}
 
		/**
		  * Plots each node from/to the parameter node as normal.
		  * 
		  * @param n The old selected node.
		  * @return True if it is okay, Flase else.
		  */
		public function unselectEdges(n:Node):Boolean{
			var e:Edge;
			var i:int = 0;
			var o:int = 0;
 
			if(edgesColorTest){
				if(curved){
					for each(e in n.getEdgesFrom()){
						plotCurvedEdge(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotCurvedEdge(e);
						i++;
					}
				}else{
					for each(e in n.getEdgesFrom()){
						plotLinearEdge(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotLinearEdge(e);
						i++;
					}
				}
			}else{
				if(curved){
					for each(e in n.getEdgesFrom()){
						plotCurvedEdgeWithNodeColor(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotCurvedEdgeWithNodeColor(e);
						i++;
					}
				}else{
					for each(e in n.getEdgesFrom()){
						plotLinearEdgeWithNodeColor(e);
						o++;
					}
 
					for each(e in n.getEdgesTo()){
						plotLinearEdgeWithNodeColor(e);
						i++;
					}
				}
			}
 
			trace(n.labelAccess+" node:\n\t"+i+" in edges drawn as normal / "+o+" out edges drawn as normal.");
 
			return(n!=null);
		}
 
		/**
		  * Changes the size of <code>tempNode</code>, and keep or not the label on the screen, depending of the value of <code>ifLabels</code>.
		  * 
		  * @param newRatio
		  * @param tempNode
		  * @param ifLabels
		  * @see com.GEXFExplorer.y2009.ui.OptionsWindow#nodesSizeEventListener
		  */
		public function actualizeSize(newRatio:Number,tempNode:Node,ifLabels:Boolean):void{
			tempNode.ratio = newRatio;
			tempNode.labelText.y -= tempNode.labelText.height/2;
			tempNode.plot();
			plotHitArea(tempNode);
			if(ifLabels) tempNode.setTextStyle(scaledTextSize);
		}
 
		/**
		  * Zooms and move the graph to center it and to scale it.
		  */
		public function scaleAndFixeGraph():void{
			trace("Scale the graph");
			var xMin:Number = globalGraph.getNodes[0].x;
			var xMax:Number = globalGraph.getNodes[0].x;
			var yMin:Number = globalGraph.getNodes[0].y;
			var yMax:Number = globalGraph.getNodes[0].y;
 
			for (var i:Number = 1;i<globalGraph.getNodes.length;i++){
				if(globalGraph.getNodes[i].x < xMin)
					xMin = globalGraph.getNodes[i].x;
				if(globalGraph.getNodes[i].x > xMax)
					xMax = globalGraph.getNodes[i].x;
				if(globalGraph.getNodes[i].y < yMin)
					yMin = globalGraph.getNodes[i].y;
				if(globalGraph.getNodes[i].y > yMax)
					yMax = globalGraph.getNodes[i].y;
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
 
			//checkQuadtree();
		}
 
		/**
		  * Plots <code>tempEdge</code> as a linear edge.
		  * 
		  * @param tempEdge
		  */
		protected function plotLinearEdge(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness,edgesColor);
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.lineTo(tempX2,tempY2);
 
		}
 
		/**
		  * Plots <code>tempEdge</code> as a curved edge.
		  * 
		  * @param tempEdge
		  */
		protected function plotCurvedEdge(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX2:Number = nodeFrom.x;
			var tempY2:Number = nodeFrom.y;
			var tempX1:Number = nodeTo.x;
			var tempY1:Number = nodeTo.y;
 
			var x_controle:Number = (tempX1+tempX2)/2 - (tempY2-tempY1)/4;
			var y_controle:Number = (tempY1+tempY2)/2 - (tempX1-tempX2)/4;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness,edgesColor);
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.curveTo(x_controle,y_controle,tempX2,tempY2);
		}
 
		/**
		  * Plots <code>tempEdge</code> as a linear edge when source or target is selected.
		  * 
		  * @param tempEdge
		  */
		protected function plotLinearEdgeAsSelected(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness*2.3,brightenColor(edgesColor,70));
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.lineTo(tempX2,tempY2);
 
		}
 
		/**
		  * Plots <code>tempEdge</code> as a curved edge when source or target is selected.
		  * 
		  * @param tempEdge
		  */
		protected function plotCurvedEdgeAsSelected(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX2:Number = nodeFrom.x;
			var tempY2:Number = nodeFrom.y;
			var tempX1:Number = nodeTo.x;
			var tempY1:Number = nodeTo.y;
 
			var x_controle:Number = (tempX1+tempX2)/2 - (tempY2-tempY1)/4;
			var y_controle:Number = (tempY1+tempY2)/2 - (tempX1-tempX2)/4;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness*2.3,brightenColor(edgesColor,70));
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.curveTo(x_controle,y_controle,tempX2,tempY2);
		}
 
		/**
		  * Plots <code>tempEdge</code> as a linear edge with source node color.
		  * 
		  * @param tempEdge
		  */
		protected function plotLinearEdgeWithNodeColor(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness,nodeFrom.colorUInt);
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.lineTo(tempX2,tempY2);
 
		}
 
		/**
		  * Plots <code>tempEdge</code> as a curved edge with source node color.
		  * 
		  * @param tempEdge
		  */
		protected function plotCurvedEdgeWithNodeColor(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX2:Number = nodeFrom.x;
			var tempY2:Number = nodeFrom.y;
			var tempX1:Number = nodeTo.x;
			var tempY1:Number = nodeTo.y;
 
			var x_controle:Number = (tempX1+tempX2)/2 - (tempY2-tempY1)/4;
			var y_controle:Number = (tempY1+tempY2)/2 - (tempX1-tempX2)/4;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness,nodeFrom.colorUInt);
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.curveTo(x_controle,y_controle,tempX2,tempY2);
		}
 
		/**
		  * Plots <code>tempEdge</code> as a linear edge when source or target is selected with source node color.
		  * 
		  * @param tempEdge
		  */
		protected function plotLinearEdgeAsSelectedWithNodeColor(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX1:Number = nodeFrom.x;
			var tempY1:Number = nodeFrom.y;
			var tempX2:Number = nodeTo.x;
			var tempY2:Number = nodeTo.y;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness*2.3,brightenColor(nodeFrom.colorUInt,70));
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.lineTo(tempX2,tempY2);
 
		}
 
		/**
		  * Plots <code>tempEdge</code> as a curved edge when source or target is selected with source node color.
		  * 
		  * @param tempEdge
		  */
		protected function plotCurvedEdgeAsSelectedWithNodeColor(tempEdge:Edge):void {
			var nodeTo:Node = globalGraph.getNode(tempEdge.idTargetAccess);
			var nodeFrom:Node = globalGraph.getNode(tempEdge.idSourceAccess);
 
			var tempX2:Number = nodeFrom.x;
			var tempY2:Number = nodeFrom.y;
			var tempX1:Number = nodeTo.x;
			var tempY1:Number = nodeTo.y;
 
			var x_controle:Number = (tempX1+tempX2)/2 - (tempY2-tempY1)/4;
			var y_controle:Number = (tempY1+tempY2)/2 - (tempX1-tempX2)/4;
 
			tempEdge.graphics.clear();
 
			tempEdge.graphics.lineStyle(edgesThickness*2.3,brightenColor(nodeFrom.colorUInt,70));
 
			tempEdge.graphics.moveTo(tempX1,tempY1);
			tempEdge.graphics.curveTo(x_controle,y_controle,tempX2,tempY2);
		}
 
		/**
		  * Plots the hit area of <code>tempNode</code>.
		  * 
		  * @param tempNode
		  */
		protected function plotHitArea(tempNode:Node):void{
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
 
		/**
		  * Moves the scene from the keyboard.
		  * 
		  * @param evt KeyboardEvent.KEY_DOWN
		  */
		protected function moveSceneWithKeyboard(evt:KeyboardEvent):void{
			switch(evt.keyCode)
			{
			   case Keyboard.LEFT:
				  this.x+=20;
				  break;
			   case Keyboard.RIGHT:
				  this.x-=20;
				  break;
			   case Keyboard.UP:
				  if(evt.ctrlKey) optionsWindow.zoomMoinsEventListener(null);
				  else this.y+=20;
				  break;
			   case Keyboard.DOWN:
			      if(evt.ctrlKey) optionsWindow.zoomPlusEventListener(null);
				  else this.y-=20;
				  break;
			   case Keyboard.PAGE_DOWN:
				  optionsWindow.zoomPlusEventListener(null);
				  break;
			   case Keyboard.PAGE_UP:
				  optionsWindow.zoomMoinsEventListener(null);
				  break;
			   case Keyboard.SPACE:
				  scaleAndFixeGraph();
				  break;
			   default:
			      break;
			}
			//checkQuadtree();
		}
 
		/**
		  * Zooms in the direction of the mouse cursor.
		  * 
		  * @param evt MouseEvent.MOUSE_WHEEL
		  */
		protected function zoomScene(evt:MouseEvent):void{
			if(((evt.stageY<optionsWindow.getBackground().y)||(evt.stageX<optionsWindow.getBackground().x))
			    &&(optionsWindow.contains(optionsWindow.getBackground()))
			    &&((evt.stageX<stage.stageWidth)&&(evt.stageX>0)
			    &&(evt.stageY<stage.stageHeight)&&(evt.stageY>0))){
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
 
//				checkQuadtree();
			}
		}
 
		/**
		  * Starts dragging the scene.
		  * 
		  * @param evt MouseEvent.MOUSE_DOWN
		  */
		protected function dragScene(evt:MouseEvent):void{
			if((evt.stageY<optionsWindow.getBackground().y+optionsWindow.getBackground().height)&&(evt.stageY>optionsWindow.getBackground().y)
			   &&(evt.stageX<optionsWindow.getBackground().x+optionsWindow.getBackground().width)&&(evt.stageX>optionsWindow.getBackground().x)
			   &&(optionsWindow.contains(optionsWindow.getBackground()))){
			}else{
				if(this.contains(textsContainer)){
					this.removeChild(textsContainer);
				}
				this.startDrag();
			}
		}
 
		/**
		  * Stops dragging the scene.
		  * 
		  * @param evt MouseEvent.MOUSE_UP
		  */
		protected function dropScene(evt:MouseEvent):void{
			if(ifShowLabels){
				this.removeChild(hitAreasContainer);
				this.addChild(textsContainer);
				this.addChild(hitAreasContainer);
			}
			this.stopDrag();
 
			//checkQuadtree();
		}
 
		/**
		  * Checks for each quad if it is out of the screen, or (totally or partially) in, to know if it has to be removed from the screen.
		  * 
		  * @see com.GEXFExplorer.y2009.data.Quad
		  * @see com.GEXFExplorer.y2009.visualization.Quadtree#isOnScreen
		  */
		protected function checkQuadtree():void{
			var tempQuad:Quad;
 
			for each(tempQuad in quadtree.getQuadsArray()){
				if(quadtree.isOnScreen(tempQuad.positionAccess)){
					addAllChild(tempQuad);
				}else{
					removeAllChild(tempQuad);
				}
			}
		}
 
		/**
		  * Adds all elements in a quad from the graphic tree.
		  * 
		  * @param quad The quad to add from the graphic tree.
		  * @see com.GEXFExplorer.y2009.data.Quad
		  */
		protected function addAllChild(quad:Quad):void{
			edgesContainer.addChild(quad.edgesContainer);
			nodesContainer.addChild(quad.nodesContainer);
			textsContainer.addChild(quad.textsContainer);
			hitAreasContainer.addChild(quad.hitAreasContainer);
		}
 
		/**
		  * Removes all elements in a quad from the graphic tree.
		  * 
		  * @param quad The quad to remove from the graphic tree.
		  * @see com.GEXFExplorer.y2009.data.Quad
		  */
		protected function removeAllChild(quad:Quad):void{
			if(edgesContainer.contains(quad.edgesContainer)) edgesContainer.removeChild(quad.edgesContainer);
			if(nodesContainer.contains(quad.nodesContainer)) nodesContainer.removeChild(quad.nodesContainer);
			if(textsContainer.contains(quad.textsContainer)) textsContainer.removeChild(quad.textsContainer);
			if(hitAreasContainer.contains(quad.hitAreasContainer)) hitAreasContainer.removeChild(quad.hitAreasContainer);
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