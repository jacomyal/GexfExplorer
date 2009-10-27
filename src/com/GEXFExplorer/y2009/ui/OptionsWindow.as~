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
	
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import flash.display.SimpleButton;
    import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
    import flash.events.MouseEvent;
    import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.controls.Button;
	import fl.events.SliderEvent;
	import com.GEXFExplorer.y2009.ui.FullScreenButton;
	import com.GEXFExplorer.y2009.data.Edge;
	import com.GEXFExplorer.y2009.data.Node;
	import com.GEXFExplorer.y2009.data.Graph;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
	import com.GEXFExplorer.y2009.visualization.PlotGraph;
	
	/**
	 * Fenêtre des options d'affichage du graphe, qui s'affiche directement au dessus du graphe
	 * en transparence.
	 *
	 * @author Alexis Jacomy
	 */
	public class OptionsWindow extends Sprite{
		
		public var backGround:Sprite;
		public var setNodesSizeSlider:Slider;
		
		private var nodesSizeLabel:TextField;
		private var zoomPlus:ZoomOut;
		private var zoomMoins:ZoomIn;
		private var windowed:Windowed;
		private var fullscreen:Fullscreen;
		private var titleTextField:TextField;
		
		private var fullScreenButton:FullScreenButton = new FullScreenButton();
		
		private var plotGraph:PlotGraph;
	
		public function OptionsWindow(pGraph:PlotGraph) {
			
			var tempTextFormat:TextFormat = new TextFormat("Tahoma",11);
			var tempTitleTextFormat:TextFormat = new TextFormat("Verdana",14,0x00234c,false,true);
			plotGraph = pGraph;
			plotGraph.stage.addChild(this);
			
			// backGround :
			backGround = new Sprite();
			with(backGround){
				x = 0;
				y = 0;
				graphics.beginFill(0xDDDDDD,0.8);
				graphics.drawRoundRect(0,0,104,129,10);
			}
			
			// titleTextField :
			titleTextField = new TextField();
			with(titleTextField){
				x = 7;
				y = 7;
				text = "GexfExplorer";
				selectable = false;
				setTextFormat(tempTitleTextFormat);
			}
			
			// nodesSizeLabel :
			nodesSizeLabel = new TextField();
			with(nodesSizeLabel){
				x = 10;
				y = 30;
				text = "Nodes size";
				selectable = false;
				setTextFormat(tempTextFormat);
			}
			
			// setNodesSizeSlider :
			setNodesSizeSlider = new Slider();
			with(setNodesSizeSlider){
				x = 10;
				y = 50;
				setSize(84,0);
				minimum = 0;
				maximum = 400;
				value = 75;
				liveDragging = true;
			}
			
			// zoomPlus :
			zoomPlus = new ZoomOut();
			with(zoomPlus){
				x = 10;
				y = 95;
				width = 24;
				height = 24;
			}
			
			// zoomMoins :
			zoomMoins = new ZoomIn();
			with(zoomMoins){
				x = 70;
				y = 95;
				width = 24;
				height = 24;
			}
			
			// windowed :
			windowed = new Windowed();
			with(windowed){
				x = 40;
				y = 95;
				width = 24;
				height = 24;
			}
			
			// fullscreen :
			fullscreen = new Fullscreen();
			with(fullscreen){
				x = 0;
				y = 0;
				width = 24;
				height = 24;
			}
			
			plotGraph.optWin = this;
			
			fullscreen.x = stage.stageWidth-24;
			fullscreen.y = stage.stageHeight-24;
			backGround.x = stage.fullScreenWidth-104;
			backGround.y = stage.fullScreenHeight-129;
			
			titleTextField.addEventListener(MouseEvent.CLICK,onClickTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutTitle);
			setNodesSizeSlider.addEventListener(SliderEvent.CHANGE,nodesSizeEventListener);
			zoomPlus.addEventListener(MouseEvent.MOUSE_DOWN,zoomPlusEventListener);
			zoomMoins.addEventListener(MouseEvent.MOUSE_DOWN,zoomMoinsEventListener);
			windowed.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			fullscreen.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			stage.addEventListener(Event.RESIZE,whenChangeStageDisplayState);
			
			backGround.addChild(titleTextField);
			backGround.addChild(nodesSizeLabel);
			backGround.addChild(setNodesSizeSlider);
			backGround.addChild(zoomPlus);
			backGround.addChild(zoomMoins);
			backGround.addChild(windowed);
			
			addChild(fullscreen);
		}
		
		protected function onMouseOverTitle(evt:MouseEvent){
			Mouse.cursor = flash.ui.MouseCursor.BUTTON;
		}
		
		protected function onMouseOutTitle(evt:MouseEvent){
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
		}
		
		protected function onClickTitle(evt:MouseEvent){
			var tempURL:URLRequest = new URLRequest("http://gephi.org/community/gexfexplorer");
			navigateToURL(tempURL);
		}
		
		protected function nodesSizeEventListener(evt:SliderEvent){
			var thisNode:Node;
			
			for each(thisNode in plotGraph.globalGraph.getNodes()){
				plotGraph.actualizeSize(evt.target.value/10,thisNode,true);
			}
		}
		
		protected function zoomPlusEventListener(evt:MouseEvent){
			var middleX:Number = stage.stageWidth/2;
			var middleY:Number = stage.stageHeight/2;
			
			plotGraph.x = middleX+(plotGraph.x-middleX)*10/13;
			plotGraph.y = middleY+(plotGraph.y-middleY)*10/13;
			plotGraph.scaleX *= 10/13;
			plotGraph.scaleY *= 10/13;
		}
		
		protected function zoomMoinsEventListener(evt:MouseEvent){
			var middleX:Number = stage.stageWidth/2;
			var middleY:Number = stage.stageHeight/2;
			
			plotGraph.x = middleX+(plotGraph.x-middleX)*1.3;
			plotGraph.y = middleY+(plotGraph.y-middleY)*1.3;
			plotGraph.scaleX *= 1.3;
			plotGraph.scaleY *= 1.3;
		}
		
		protected function onClickFullScreen(evt:MouseEvent){
			
			var tempWidth = stage.stageWidth/2;
			var tempHeight = stage.stageHeight/2;
			
			if(stage.displayState == StageDisplayState.NORMAL){
                try{
                    stage.displayState=StageDisplayState.FULL_SCREEN; 
					
					plotGraph.scaleAndFixeGraph();
					
					if(contains(fullscreen)) removeChild(fullscreen);
					addChild(backGround); 
                }  
                catch (e:SecurityError){ 
                    trace("an error has occured. please modify the html file to allow fullscreen mode")  
                }  
			} else {
				stage.displayState=StageDisplayState.NORMAL;
				trace("Fullscreen off");
				plotGraph.scaleAndFixeGraph();
				if(contains(backGround)) removeChild(backGround);
				addChild(fullscreen);
			}
		}
		
		protected function whenChangeStageDisplayState(evt:Event){
			var tempWidth = stage.fullScreenWidth/2;
			var tempHeight = stage.fullScreenHeight/2;
			
			plotGraph.scaleAndFixeGraph();
			trace("Fullscreen off");
			if(contains(backGround)) removeChild(backGround);
			addChild(fullscreen);
		}
	}
}