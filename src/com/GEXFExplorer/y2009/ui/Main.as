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

package com.GEXFExplorer.y2009.ui {
	
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import com.GEXFExplorer.y2009.data.Graph;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
	import com.GEXFExplorer.y2009.visualization.PlotGraph;
	
	public class Main extends Sprite{
		
		private var Gexf:GEXFLoader;
		private var curvedEdges:Boolean;
		private var clickableNodes:Boolean;
		private var path:String;
		private var font:String;
		private var edgesThickness:Number;
		private var labelsColor:uint;
		
		public var plotGraph:PlotGraph;
		public var graph:Graph;
		
		public function Main(s:Stage) {
			
			s.addChild(this);
			
			path = root.loaderInfo.parameters["path"];
			
			if(root.loaderInfo.parameters["labelsColor"]==undefined){labelsColor = 0x000000;}
			else{labelsColor = new uint(root.loaderInfo.parameters["labelsColor"]);}
			
			if(root.loaderInfo.parameters["font"]==undefined){font = "Arial";}
			else{font = root.loaderInfo.parameters["font"];}
			
			if(root.loaderInfo.parameters["edgesThickness"]==undefined){edgesThickness = 1;}
			else{edgesThickness = new Number(root.loaderInfo.parameters["edgesThickness"]);}
			
			if(root.loaderInfo.parameters["clickableNodes"]=="true"){clickableNodes = true;}
			else{clickableNodes = false;}
			
			if(root.loaderInfo.parameters["curvedEdges"]=="true"){curvedEdges = true;}
			else{curvedEdges = false;}
			
			graph = new Graph();
			if(path==null){
				Gexf = new GEXFLoader(graph,labelsColor,font,"C:/test.gexf");
			} else {
				Gexf = new GEXFLoader(graph,labelsColor,font,path);
			}
			Gexf.addEventListener(GEXFLoader.COMPLETE, onComplete);
		}
		
		private function onComplete(evt:Event){
			Gexf.removeEventListener(GEXFLoader.COMPLETE, onComplete);
			
			plotGraph = new PlotGraph(graph,stage,edgesThickness,clickableNodes,curvedEdges);
		}
	}
	
}