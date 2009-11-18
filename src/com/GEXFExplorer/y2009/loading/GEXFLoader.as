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
	
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.GEXFExplorer.y2009.data.*;
	
	/**
	  * Parses the gexf file to enter into the memory everything about the graph, each node and each edge.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  */
	public class GEXFLoader extends EventDispatcher{
		
		public static const COMPLETE = "Complete";
		
		private var globalGraph:Graph;
		private var loader:URLLoader;
		private var file:URLRequest;
		private var backGround:Sprite;
		private var progressBar:ProgressBar;
		private var progressReport:TextField;
		
		private var testLoadedFalse:Boolean;
		
		private var nodesTest:Boolean;
		private var edgesTest:Boolean;
		private var attributesTest:Boolean;
		
		private var nodeCounter:Number;
		private var edgeCounter:Number;
		private var attributesCounter:Number;
		private var nodesTotal:Number;
		private var edgesTotal:Number;
		private var attributesTotal:Number;
				
		private var timer:Timer;
		private var adresse:String;
		private var labelsColor:uint;
		private var font:String;
		
		/**
		  * Creates the GEXFLoader instance and initializes all variables.
		  * It also launches the whole processus.
		  * 
		  * @param gGraph Global graph
		  * @param s Scene stage
		  */
		public function GEXFLoader(gGraph:Graph,s:Stage){
			
			globalGraph = gGraph;
			
			if(s.root.loaderInfo.parameters["path"]==undefined){adresse = "D:/Text-Mining (stage)/dev/GEXFExplorer/bin/codeminer.gexf";}
			else{adresse = s.root.loaderInfo.parameters["path"];}
			
			if(s.root.loaderInfo.parameters["labelsColor"]==undefined){labelsColor = 0x000000;}
			else{labelsColor = new uint(s.root.loaderInfo.parameters["labelsColor"]);}
			
			if(s.root.loaderInfo.parameters["font"]==undefined){font = "Arial";}
			else{font = s.root.loaderInfo.parameters["font"];}
			
			backGround = new Sprite();
			backGround.x = 0;
			backGround.y = 0;
			backGround.graphics.beginFill(0xDDDDDD,0.8);
			backGround.graphics.drawRect(0,0,s.stageWidth,70);
			s.addChild(backGround);
			
			nodesTest = true;
			edgesTest = true;
			attributesTest = true;
			
			file = new URLRequest(adresse);
			loader = new URLLoader();
			
			progressReport = new TextField();
			with(progressReport){
				text = "Loading "+adresse;
				setTextFormat(new TextFormat("Verdana",20,0x000000,true));
				x = 5;
				y = 5;
				autoSize = TextFieldAutoSize.LEFT;
			}
			backGround.addChild(progressReport);
			
			progressBar = new ProgressBar();
			with(progressBar){
				x = 5;
				y = 30;
				width = s.stageWidth-10;
				height = 20;
				mode = ProgressBarMode.MANUAL;
			}
			backGround.addChild(progressBar);
			
			loader.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			
			backGround.stage.addEventListener(Event.ENTER_FRAME,loadingHandler);
			
			loader.load(file);
		}
		
		/**
		  * Deletes each variables, to empty the memory.
		  */
		public function empty(){
			backGround.stage.removeEventListener(Event.ENTER_FRAME,loadingHandler);
			if(backGround.parent!=null) backGround.parent.removeChild(backGround);
			globalGraph = null;
			loader = null;
			file = null;
			backGround = null;
			progressBar = null;
			progressReport = null;
			adresse = null;
			font = null;
		}
		
		/**
		  * Prints the loading and parsing progresses with a progress bar.
		  * It refreshes on each frame.
		  * 
		  * @param e Event.ENTER_FRAME
		  */
		protected function loadingHandler(e:Event){
			if(testLoadedFalse){
				progressBar.setProgress(loader.bytesLoaded,loader.bytesTotal);
				progressReport.text = Math.round(progressBar.percentComplete) + "% Loaded (file)";
				progressReport.setTextFormat(new TextFormat("Verdana",25,0x000000,true));
			}else{
				progressReport.text = "Extracting datas from the file...";
				progressReport.setTextFormat(new TextFormat("Verdana",25,0x000000,true));
				backGround.stage.removeEventListener(Event.ENTER_FRAME,loadingHandler);
			}
		}
		
		/**
		  * Parses the file when it's completely loaded.
		  * It writes too all datas into the memory.
		  * 
		  * @param e Event.COMPLETE
		  */
		protected function onLoadCompleteHandler(e:Event):void{
			testLoadedFalse = false;
			
			nodeCounter = 0;
			edgeCounter = 0;
			
			var viz:Namespace = new Namespace("viz","http://www.gephi.org/gexf");
			var isOK = true;
			var tempNode:Node;
			var tempEdge:Edge;
			var tempAttributes:Object;
			var i:int;
			var sTitle:String;
			
			var base:XML = new XML( e.target.data );
			var meta:XMLList = base.children();
			var categories:XMLList = base.children().children();
			
			var metaInFile:XMLList;
			var nodesInFile:XMLList;
			var edgesInFile:XMLList;
			var attributesInFile:XMLList;
			
			for(i=0;i<categories.length();i++){
				if(categories[i].name().localName=='nodes'){
					nodesInFile = categories[i].children();
				}else if(categories[i].name().localName=='edges'){
					edgesInFile = categories[i].children();
				}else if((categories[i].name().localName=='attributes')&&(categories[i].attribute("class")=='node')){
					attributesInFile = categories[i].children();
				}
			}
			
			for each(var tempXML:XML in meta){
				if(tempXML.name().localName=='meta'){
					metaInFile = tempXML.children();
				}
			}
			if(metaInFile!=null){
				for each(tempXML in metaInFile){
					if(tempXML.name().localName=='description'){
						globalGraph.setTitle(tempXML);
					}
					if(tempXML.name().localName=='creator'){
						globalGraph.setCreator(tempXML);
					}
				}
			}
			
			if(nodesInFile==null) nodesTest=false;
			if(edgesInFile==null) edgesTest=false;
			if(attributesInFile==null) attributesTest=false;
			
			if(attributesTest){
				attributesTotal = attributesInFile.length();
				for each(var attributeXML:XML in attributesInFile) {
					globalGraph.setAttribute(attributeXML.@title,attributeXML.@id);
					
					attributesCounter++;
				}
			}else{
				trace('GEXFLoader:\n\tProblem during the parsing process: No category named "attributes" available.');
			}
			
			if(nodesTest){
				nodesTotal = nodesInFile.length();
				for each(var nodeXML:XML in nodesInFile) {
					tempAttributes = new Object();
					var tempB:String;
					var tempG:String;
					var tempR:String;
					
					trace("Node number: " + nodeCounter + ", label: " + nodeXML.@label);
					
					globalGraph.pushLabel(nodeXML.@label);
					globalGraph.setIDConnection(nodeXML.@id,nodeCounter)
					
					tempNode = new Node(nodeCounter, nodeXML.@label, labelsColor, font);
					tempNode.x = nodeXML.children().normalize().@x*10;
					tempNode.y = -1*nodeXML.children().normalize().@y*10;
					tempNode.setDiameter(nodeXML.children().normalize().@value);
					tempB = (nodeXML.children().normalize().@b).toString();
					tempG = (nodeXML.children().normalize().@g).toString();
					tempR = (nodeXML.children().normalize().@r).toString();
					tempNode.setColor(tempB,tempG,tempR);
					
					globalGraph.addNode(tempNode);
					
					nodeCounter++;
				}
			}else{
				trace('GEXFLoader:\n\tProblem during the parsing process: No category named "nodes" available.');
			}
			
			if(edgesTest){
				edgesTotal = edgesInFile.length();
				for each(var edgeXML:XML in edgesInFile){
					if(edgeXML.@source!=edgeXML.@target){
						tempEdge = new Edge(globalGraph.getArtificialID(edgeXML.@source), globalGraph.getArtificialID(edgeXML.@target));
						globalGraph.addEdge(tempEdge);
						globalGraph.getNode(tempEdge.idSourceAccess).addEdgeFrom(tempEdge);
						globalGraph.getNode(tempEdge.idTargetAccess).addEdgeTo(tempEdge);
					}
					edgeCounter++;
				}
			}else{
				trace('GEXFLoader:\n\tProblem during the parsing process: No category named "edges" available.');
			}
			
			globalGraph.cleanHash();
			
			trace("File completely loaded.");
			
			dispatchEvent(new Event(COMPLETE));
		}
	}
}