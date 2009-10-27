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

package com.GEXFExplorer.y2009.loading {
	
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.GEXFExplorer.y2009.data.*;
	import com.GEXFExplorer.y2009.visualization.PlotGraph;
	
	/**
	 * Permet de charger en mémoire les arcs et les noeuds définis par le '.gexf'. Ne prend pas en compte
	 * les attributs (sauf le label des noeuds), ni le cardinal des arcs.
	 *
	 * @author Alexis Jacomy
	 */
	public class GEXFLoader extends EventDispatcher{
		
		public static const COMPLETE = "Complete";
		
		public var graphViz:PlotGraph;
		public var globalGraph:Graph;
		
		private var adresse:String;
		private var labelsColor:uint;
		private var font:String;
	
		public function GEXFLoader(gGraph:Graph,newLabelsColor:uint,newFont:String,tempAdresse:String="C:/test.gexf"){
			
			labelsColor = newLabelsColor;
			font =  newFont;
			
			globalGraph = gGraph;
			
			var chargementXML:URLLoader = new URLLoader();
			var file:URLRequest = new URLRequest(tempAdresse);
			chargementXML.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			
			chargementXML.load(file);
		}
		
		protected function onLoadCompleteHandler(pEvt:Event):void{
			
			var tempNode:Node;
			var tempEdge:Edge;
			var nodeCounter:Number = 0
			
			var base:XML = new XML( pEvt.target.data );
			
			var nodesInFile:XMLList = base.children().children()[1].children();
			var edgesInFile:XMLList = base.children().children()[2].children();
			
			for each(var nodeXML:XML in nodesInFile) {
				
				var tempB:String; 
				var tempG:String; 
				var tempR:String;
				
				trace("Node number: " + nodeCounter + ", URL: " + nodeXML.@label);
				
				tempNode = new Node(nodeXML.@id,nodeCounter, nodeXML.@label, labelsColor, font);
				tempNode.x = nodeXML.children()[1].@x*10;
				tempNode.y = nodeXML.children()[1].@y*10;
				tempNode.diameter = nodeXML.children()[2].@value;
				tempB = (nodeXML.children()[0].@b).toString();
				tempG = (nodeXML.children()[0].@g).toString();
				tempR = (nodeXML.children()[0].@r).toString();
				tempNode.setColor(tempB,tempG,tempR);
				trace("   -> x: " + tempNode.x + ", y: " + tempNode.y);
				trace("      color: "+tempNode.colorUInt.toFixed());
				trace("      size: "+tempNode.diameter);
				globalGraph.addNode(tempNode);
				
				nodeCounter++;
			}
			
			for each(var edgeXML:XML in edgesInFile) {
				
				tempEdge = new Edge(edgeXML.@source, edgeXML.@target);
				globalGraph.edgesList.push(tempEdge);
				globalGraph.getNode(edgeXML.@source).addEdgeFrom(tempEdge);
				globalGraph.getNode(edgeXML.@target).addEdgeTo(tempEdge);
				trace("Edge n°"+globalGraph.edgesList.length+" from " + tempEdge.idSource + " to " + tempEdge.idTarget);
			}
		
			trace("File completely loaded.");
			
			dispatchEvent(new Event(COMPLETE));
		}
	}
}