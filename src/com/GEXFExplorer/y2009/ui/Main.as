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
	
	import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFieldType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import com.GEXFExplorer.y2009.data.Graph;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
	import com.GEXFExplorer.y2009.visualization.VisualGraph;
	
	
	/**
	  * Main class of this program.
	  * It manages all stages from reading the file to drawing the graph.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  */
	public class Main extends Sprite{
		
		private var Gexf:GEXFLoader;
		
		private var visualGraph:VisualGraph;
		private var graph:Graph;
		
		/**
		  * Initializes the instance.
		  * 
		  * @param s Scene stage
		  */
		public function Main(s:Stage) {
			
			s.addChild(this);
			graph = new Graph();
			
			Gexf = new GEXFLoader(graph,stage);
			Gexf.addEventListener(GEXFLoader.COMPLETE, onComplete);
		}
		
		/**
		  * Initiates the VisualGraph instance when datas are loaded into the memory.
		  * 
		  * @param evt GEXFLoader.COMPLETE
		  * @see com.GEXFExplorer.y2009.visualization.VisualGraph
		  */
		protected function onComplete(evt:Event){
			Gexf.removeEventListener(GEXFLoader.COMPLETE, onComplete);
			Gexf.empty();
			
			var tempColor:uint;
			
			if(root.loaderInfo.parameters["titleColor"]!=undefined) tempColor = new uint(root.loaderInfo.parameters["titleColor"]);
			else tempColor = 0x000000;
			
			if(graph.getTitle!=null){
				var tTF:TextField = new TextField();
				with(tTF){
					x = 12;
					y = 12;
					text = graph.getTitle;
					selectable = false;
					autoSize = TextFieldAutoSize.LEFT;
					setTextFormat(new TextFormat("Verdana",25,tempColor,true));
				}
				addChild(tTF);
				
				if(graph.getCreator!=null){
					var cTF:TextField = new TextField();
					with(cTF){
						x = 12;
						y = 35;
						text = "by "+graph.getCreator;
						selectable = false;
						autoSize = TextFieldAutoSize.LEFT;
						setTextFormat(new TextFormat("Verdana",20,tempColor,true));
					}
					addChild(cTF);
				}
			}
			
			visualGraph = new VisualGraph(graph,stage);
		}
	}
	
}