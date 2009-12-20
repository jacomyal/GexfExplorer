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
	import flash.utils.Dictionary;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFieldType;
    import flash.display.Sprite;
    import flash.display.SimpleButton;
    import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
    import flash.events.MouseEvent;
    import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import fl.controls.CheckBox;
    import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.listClasses.*;
	import fl.controls.dataGridClasses.*;
	import fl.controls.progressBarClasses.*;
	import fl.data.DataProvider;
	import fl.events.SliderEvent;
	import fl.events.ComponentEvent;
	import fl.containers.*;
	import fl.core.UIComponent;
	import com.GEXFExplorer.y2009.data.HashMap;
	import com.GEXFExplorer.y2009.data.Edge;
	import com.GEXFExplorer.y2009.data.Node;
	import com.GEXFExplorer.y2009.data.Graph;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
	import com.GEXFExplorer.y2009.visualization.VisualGraph;
	import com.GEXFExplorer.y2009.text.InputTextField;
	
	/**
	  * Represents and synthesize most of the interactive functionalities of this widget.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  */
	public class OptionsWindow extends Sprite{
		
		private var dataGrid:DataGrid;
		
		private var backGround:Sprite;
		private var nodesSizeSlider1:Slider;
		private var nodesSizeLabel1:TextField;
		private var nodesSizeSlider2:Slider;
		private var nodesSizeLabel2:TextField;
		private var zoomPlus:ZoomOut;
		private var zoomMoins:ZoomIn;
		private var windowed:Windowed;
		private var fullscreen:Fullscreen;
		private var windowedPalette:Sprite;
		private var titleTextField:TextField;
		private var diffX:Number;
		private var diffY:Number;
		private var visualGraph:VisualGraph;
		private var attributesTest:Boolean;
		
		/**
		  * Initializes options parameters.
		  * It draws also each interactive element on a palette, and adds each event listener.
		  * 
		  * @param pGraph The global VisualGraph, which it will interact with.
		  */
		public function OptionsWindow(pGraph:VisualGraph) {
			var tempTextFormat:TextFormat = new TextFormat("Tahoma",11);
			var tempTitleTextFormat:TextFormat = new TextFormat("Verdana",14,0x00234c,false,true);
			
			visualGraph = pGraph;
			visualGraph.stage.addChild(this);
			
			attributesTest = (visualGraph.getGraph().isAttributeHashNull() || (root.loaderInfo.parameters["showAttributes"]!="true"));
			
			backGround = new Sprite();
			addChild(backGround);
			with(backGround){
				graphics.beginFill(0xDDDDDD,0.8);
				if(attributesTest) graphics.drawRoundRect(0,0,104,169,10);
				else graphics.drawRoundRect(0,0,174,239,10);
			}
			
			titleTextField = new TextField();
			with(titleTextField){
				x = 7;
				y = 7;
				text = "GexfExplorer";
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				setTextFormat(tempTitleTextFormat);
			}
			
			nodesSizeLabel1 = new TextField();
			with(nodesSizeLabel1){
				x = 10;
				y = 30;
				text = "Nodes size";
				selectable = false;
				setTextFormat(tempTextFormat);
				enable = true;
			}
			
			nodesSizeLabel2 = new TextField();
			with(nodesSizeLabel2){
				text = "Nodes size";
				selectable = false;
				setTextFormat(tempTextFormat);
				enable = true;
			}
			
			var tempMark:Number;
			if(stage.root.loaderInfo.parameters["initialNodesRatio"]==undefined){tempMark = 1;}
			else{
				tempMark = new Number(stage.root.loaderInfo.parameters["initialNodesRatio"]);
			}
			
			tempMark *= 75;
			
			nodesSizeSlider1 = new Slider();
			with(nodesSizeSlider1){
				move(10,50);
				setSize(backGround.width-20,0);
				minimum = 0;
				maximum = Math.max(3*tempMark,300);
				value = tempMark;
				liveDragging = true;
			}
			
			nodesSizeSlider2 = new Slider();
			with(nodesSizeSlider2){
				move(10,50);
				setSize(backGround.width-20,0);
				minimum = 0;
				maximum = Math.max(3*tempMark,300);
				value = tempMark;
				liveDragging = true;
			}
			
			zoomPlus = new ZoomOut();
			with(zoomPlus){
				x = 10;
				y = backGround.height-35;
				width = 24;
				height = 24;
			}
			
			zoomMoins = new ZoomIn();
			with(zoomMoins){
				x = backGround.width-34;
				y = backGround.height-35;
				width = 24;
				height = 24;
			}
			
			windowed = new Windowed();
			with(windowed){
				x = backGround.width/2-12;
				y = backGround.height-35;
				width = 24;
				height = 24;
			}

			dataGrid = new DataGrid();
			with(dataGrid){
				move(10,nodesSizeSlider1.y+20);
				setSize(backGround.width-20,windowed.y-y-15);
				columns = [ new DataGridColumn("Attribute"), new DataGridColumn("Value") ];
			}
			
			windowedPalette = new Sprite();
			with(windowedPalette){
				graphics.beginFill(0xDDDDDD,0.8);
				graphics.drawRoundRect(0,0,144,40,10);
			}
			
			fullscreen = new Fullscreen();
			with(fullscreen){
				x = 8;
				y = 8;
				width = 24;
				height = 24;
			}
			
			titleTextField.addEventListener(MouseEvent.CLICK,onClickTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutTitle);
			nodesSizeSlider1.addEventListener(SliderEvent.CHANGE,nodesSizeEventListener);
			nodesSizeSlider2.addEventListener(SliderEvent.CHANGE,nodesSizeEventListener);
			zoomPlus.addEventListener(MouseEvent.MOUSE_DOWN,zoomPlusEventListener);
			zoomMoins.addEventListener(MouseEvent.MOUSE_DOWN,zoomMoinsEventListener);
			windowed.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			fullscreen.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			if(!attributesTest) visualGraph.addEventListener(VisualGraph.SELECT,setDataGridContent);
			stage.addEventListener(Event.RESIZE,whenChangeStageDisplayState);
			
			backGround.addChild(titleTextField);
			backGround.addChild(nodesSizeLabel1);
			backGround.addChild(windowed);
			backGround.addChild(zoomPlus);
			backGround.addChild(zoomMoins);
			backGround.addChild(nodesSizeSlider1);
			windowedPalette.addChild(fullscreen);
			if(!attributesTest) backGround.addChild(dataGrid);
			else dataGrid = null;
			windowedPalette.addChild(nodesSizeLabel2);
			windowedPalette.addChild(nodesSizeSlider2);
			
			nodesSizeSlider2.x = 40;
			nodesSizeSlider2.y = 25;
			nodesSizeLabel2.x = 40;
			nodesSizeLabel2.y = 5;
		
			nodesSizeSlider1.x = 10;
			nodesSizeSlider1.y = 50;
			nodesSizeLabel1.x = 10;
			nodesSizeLabel1.y = 30;
			
			if(root.loaderInfo.parameters["path"]==null){
				windowedPalette.x = 0;
				windowedPalette.y = stage.stageHeight-40;
				backGround.x = 0;
				backGround.y = stage.stageHeight-backGround.height;
				
				addChild(windowedPalette);
				removeChild(windowedPalette);
				addChild(backGround);
			}else{
				windowedPalette.x = 0;
				windowedPalette.y = stage.stageHeight-40;
				backGround.x = 0;
				backGround.y = stage.fullScreenHeight-backGround.height;
				
				addChild(windowedPalette);
				addChild(backGround);
			}
		}
		
		/**
		  * Returns the main palette graphic element.
		  * 
		  * @return The main palette graphic element, <code>backGround</code>.
		  */
		public function getBackground():Sprite{
			return backGround;
		}
		
		/**
		  * Returns the little palette graphic element.
		  * 
		  * @return The little palette graphic element, <code>windowedPalette</code>.
		  */
		public function getWindowedPalette():Sprite{
			return windowedPalette;
		}
		
		/**
		  * Zooms in the graph.
		  * 
		  * @param evt MouseEvent.CLICK
		  */
		public function zoomPlusEventListener(evt:MouseEvent):void{
			var middleX:Number = stage.stageWidth/2;
			var middleY:Number = stage.stageHeight/2;
			
			visualGraph.x = middleX+(visualGraph.x-middleX)*10/13;
			visualGraph.y = middleY+(visualGraph.y-middleY)*10/13;
			visualGraph.scaleX *= 10/13;
			visualGraph.scaleY *= 10/13;
		}
		
		/**
		  * Zooms out the graph.
		  * 
		  * @param evt MouseEvent.CLICK
		  */
		public function zoomMoinsEventListener(evt:MouseEvent):void{
			var middleX:Number = stage.stageWidth/2;
			var middleY:Number = stage.stageHeight/2;
			
			visualGraph.x = middleX+(visualGraph.x-middleX)*1.3;
			visualGraph.y = middleY+(visualGraph.y-middleY)*1.3;
			visualGraph.scaleX *= 1.3;
			visualGraph.scaleY *= 1.3;
		}
		
		/**
		  * Changes the color of the widget title when the mouse is over it.
		  * 
		  * @param evt MouseEvent.MOUSE_OVER
		  */
		protected function onMouseOverTitle(evt:MouseEvent):void{
			Mouse.cursor = flash.ui.MouseCursor.BUTTON;
			titleTextField.textColor = 0x7f0a0a;
		}
		
		/**
		  * Changes the color of the widget title when the mouse is out of it.
		  * 
		  * @param evt MouseEvent.MOUSE_OUT
		  */
		protected function onMouseOutTitle(evt:MouseEvent):void{
			Mouse.cursor = flash.ui.MouseCursor.ARROW;
			titleTextField.textColor = 0x00234c;
		}
		
		/**
		  * Opens in a new window the current web page of this widget.
		  * 
		  * @param evt MouseEvent.CLICK
		  */
		protected function onClickTitle(evt:MouseEvent):void{
			navigateToURL(new URLRequest("http://github.com/jacomyal/GexfExplorer/"));
		}
		
		/**
		  * Changes the size of each node of the graph by moving a slider.
		  * 
		  * @param evt SliderEvent.CHANGE
		  */
		protected function nodesSizeEventListener(evt:SliderEvent):void{
			var thisNode:Node;
			if(evt.target==nodesSizeSlider1) nodesSizeSlider2.value = evt.target.value;
			if(evt.target==nodesSizeSlider2) nodesSizeSlider1.value = evt.target.value;
			
			
			for each(thisNode in visualGraph.getNodes()){
				visualGraph.actualizeSize(evt.target.value/10,thisNode,true);
			}
		}
		
		/**
		  * Changes the display state of the stage (Fullscreen or Normal)
		  * 
		  * @param evt MouseEvent.CLICK
		  */
		protected function onClickFullScreen(evt:MouseEvent):void{
			var tempWidth = stage.stageWidth/2;
			var tempHeight = stage.stageHeight/2;
			
			if(stage.displayState == StageDisplayState.NORMAL){
                try{
                    stage.displayState=StageDisplayState.FULL_SCREEN; 
					
					visualGraph.scaleAndFixeGraph();
					Mouse.cursor = flash.ui.MouseCursor.ARROW;
					
					if(contains(windowedPalette)) removeChild(windowedPalette);
					backGround.x = 0;
					backGround.y = stage.fullScreenHeight-backGround.height;
                }  
                catch (e:SecurityError){ 
                    trace("an error has occured. please modify the html file to allow fullscreen mode")  
                }  
			} else {
				stage.displayState=StageDisplayState.NORMAL;
				trace("Fullscreen off");
				visualGraph.scaleAndFixeGraph();
				
				backGround.x = stage.stageWidth+10;
				backGround.y = stage.stageHeight+10;
			
				addChild(windowedPalette);
			}
			
			if(!attributesTest) dataGrid.drawNow();
			
		}
		
		/**
		  * Changes the user interface, between backGround and fullscreen, when <code>stage.displayState</code> changes.
		  * 
		  * @param evt Event.RESIZE
		  */
		protected function whenChangeStageDisplayState(evt:Event):void{
			var tempWidth = stage.fullScreenWidth/2;
			var tempHeight = stage.fullScreenHeight/2;
			
			visualGraph.scaleAndFixeGraph();
			trace("Fullscreen off");
			
			backGround.x = stage.stageWidth+10;
			backGround.y = stage.stageHeight+10;
			
			addChild(windowedPalette);
		}
		
		/**
		  * Sets selectedNodeLabel in visualGraph.
		  * 
		  * @param evt Event.CHANGE
		  */
		protected function onChange(evt:Event):void{
			
		}
		
		/**
		  * Fills in the DataGrid with attributes of visual graph selected node.
		  * 
		  * @param evt VisualGraph.SELECT
		  */
		protected function setDataGridContent(e:Event):void{
			var newContent:Dictionary = visualGraph.getSelectedNode().getAttributes().getMap();
			var styleData:DataProvider = new DataProvider();
			
			for(var key:* in newContent){
				styleData.addItem( { Attribute:visualGraph.getGraph().getAttribute(key),
									 Value:visualGraph.getSelectedNode().getAttributes().getValue(key) } );
			}
			
			styleData.sortOn("Attribute");
			dataGrid.dataProvider = styleData;
			dataGrid.drawNow();
			dataGrid.setFocus();
		}
		
		/**
		  * Centers the graph around <code>n</code> node, step by step, with a Timer.
		  * 
		  * @param n Target
		  */
		protected function moveTo(n:Node):void{
			diffX = -(visualGraph.scaleX*n.x+visualGraph.x)+stage.stageWidth/2;
			diffY = -(visualGraph.scaleY*n.y+visualGraph.y)+stage.stageHeight/2;
			
			moveIter();
		}
		
		/**
		  * Moves a little the graph, and launch a Timer to redo if it isn't yet the good place.
		  * 
		  * @see #moveHandler
		  */
		protected function moveIter():void{
			visualGraph.x += diffX/3;
			visualGraph.y += diffY/3;
			diffX = diffX*2/3;
			diffY = diffY*2/3;
			
			trace(diffX);
			trace(diffY);
			
			if(Math.abs(diffX)>5 || Math.abs(diffY)>5){
				var t:Timer;
				t = new Timer(40);
				t.addEventListener(TimerEvent.TIMER, moveHandler);
				t.start();
			}else trace('Move finish...');
		}
		
		/**
		  * Reiters <code>moveIter</code> at the end of the timer.
		  * 
		  * @param e TimerEvent.TIMER
		  * @see #moveIter
		  */
		protected function moveHandler(e:TimerEvent):void{
			e.target.removeEventListener(TimerEvent.TIMER, moveHandler);
			moveIter();
		}
	}
}
