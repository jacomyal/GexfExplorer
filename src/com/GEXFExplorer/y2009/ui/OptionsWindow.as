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
	import fl.data.DataProvider;
	import fl.events.SliderEvent;
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
		
		private var searchBox:ComboBox;
		private var setNodesSizeSlider:Slider;
		private var dataGrid:DataGrid;
		
		private var backGround:Sprite;
		private var nodesSizeLabel:TextField;
		private var searchField:TextField;
		private var searchButton:SearchButton;
		private var zoomPlus:ZoomOut;
		private var zoomMoins:ZoomIn;
		private var windowed:Windowed;
		private var fullscreen:Fullscreen;
		private var titleTextField:TextField;
		private var diffX:Number;
		private var diffY:Number;
		private var visualGraph:VisualGraph;
		
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
			
			backGround = new Sprite();
			with(backGround){
				x = 0;
				y = 0;
				graphics.beginFill(0xDDDDDD,0.8);
				graphics.drawRoundRect(0,0,104,169,10);
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
			
			nodesSizeLabel = new TextField();
			with(nodesSizeLabel){
				x = 10;
				y = 30;
				text = "Nodes size";
				selectable = false;
				setTextFormat(tempTextFormat);
				enable = true;
			}
			
			setNodesSizeSlider = new Slider();
			with(setNodesSizeSlider){
				move(10,50);
				setSize(84,0);
				minimum = 0;
				maximum = 400;
				value = 75;
				liveDragging = true;
			}
			
			zoomPlus = new ZoomOut();
			with(zoomPlus){
				x = 10;
				y = 135;
				width = 24;
				height = 24;
			}
			
			zoomMoins = new ZoomIn();
			with(zoomMoins){
				x = 70;
				y = 135;
				width = 24;
				height = 24;
			}
			
			searchField = new TextField();
			with(searchField){
				x = 10;
				y = 70;
				text = "Search field";
				selectable = false;
				setTextFormat(tempTextFormat);
			}
			
			searchBox = new ComboBox();
			with(searchBox){
				move(10,90);
				width = 84;
				height = 19;
				dropdownWidth = 94;
				editable = false;
				enable = true;
			}
			setSearchBoxList(visualGraph.getGraph().getLabels);
			
			searchButton = new SearchButton();
			with(searchButton){
				x = 74;
				y = 68;
				width = 20;
				height = 20;
			}
			
			windowed = new Windowed();
			with(windowed){
				x = 40;
				y = 135;
				width = 24;
				height = 24;
			}
			
			fullscreen = new Fullscreen();
			with(fullscreen){
				x = 0;
				y = 0;
				width = 24;
				height = 24;
			}
			
			titleTextField.addEventListener(MouseEvent.CLICK,onClickTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverTitle);
			titleTextField.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutTitle);
			setNodesSizeSlider.addEventListener(SliderEvent.CHANGE,nodesSizeEventListener);
			zoomPlus.addEventListener(MouseEvent.MOUSE_DOWN,zoomPlusEventListener);
			zoomMoins.addEventListener(MouseEvent.MOUSE_DOWN,zoomMoinsEventListener);
			windowed.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			fullscreen.addEventListener(MouseEvent.CLICK,onClickFullScreen);
			searchBox.addEventListener(Event.CHANGE, onChange);
			searchButton.addEventListener(MouseEvent.CLICK, searchHandler);
			stage.addEventListener(Event.RESIZE,whenChangeStageDisplayState);
			
			backGround.addChild(titleTextField);
			backGround.addChild(nodesSizeLabel);
			//backGround.addChild(searchField);
			//backGround.addChild(searchButton);
			//backGround.addChild(searchBox);
			backGround.addChild(windowed);
			backGround.addChild(zoomPlus);
			backGround.addChild(zoomMoins);
			backGround.addChild(setNodesSizeSlider);
			
			if(root.loaderInfo.parameters["path"]==null){
				fullscreen.x = stage.stageWidth-24;
				fullscreen.y = stage.stageHeight-24;
				backGround.x = stage.stageWidth-104;
				backGround.y = stage.stageHeight-169;
				
				addChild(fullscreen);
				removeChild(fullscreen);
				addChild(backGround);
			}else{
				fullscreen.x = stage.stageWidth-24;
				fullscreen.y = stage.stageHeight-24;
				backGround.x = stage.fullScreenWidth-104;
				backGround.y = stage.fullScreenHeight-169;
					
				addChild(fullscreen);
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
		  * Returns the main palette graphic element.
		  * 
		  * @return The main palette graphic element, <code>backGround</code>.
		  */
		public function setSearchBoxList(a:Array){
			var o:Object;
			
			searchBox.removeAll();
			
			for(var i:int = 0;i<a.length;i++){
				o = new Object();
				o.label = a[i];
				searchBox.addItem(o);
			}
			
			searchBox.sortItems();
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
					
					if(contains(fullscreen)) removeChild(fullscreen);
					addChild(backGround);
                }  
                catch (e:SecurityError){ 
                    trace("an error has occured. please modify the html file to allow fullscreen mode")  
                }  
			} else {
				stage.displayState=StageDisplayState.NORMAL;
				trace("Fullscreen off");
				visualGraph.scaleAndFixeGraph();
				if(contains(backGround)) removeChild(backGround);
				addChild(fullscreen);
			}
			
			searchBox.drawNow();
			setNodesSizeSlider.drawNow();
			
		}
		
		/**
		  * Changes the user interface, between <code>backGround</code> and <code>fullscreen</code>, when <code>stage.displayState</code> changes.
		  * 
		  * @param evt Event.RESIZE
		  */
		protected function whenChangeStageDisplayState(evt:Event):void{
			var tempWidth = stage.fullScreenWidth/2;
			var tempHeight = stage.fullScreenHeight/2;
			
			visualGraph.scaleAndFixeGraph();
			trace("Fullscreen off");
			if(contains(backGround)){
				removeChild(backGround);
			}
			addChild(fullscreen);
			
			searchBox.drawNow();
			setNodesSizeSlider.drawNow();
		}
		
		/**
		  * Sets selectedNodeLabel in visualGraph.
		  * 
		  * @param evt Event.CHANGE
		  */
		protected function onChange(evt:Event):void{
			
		}
		
		/**
		  * Centers the graph on selected node, or define the list in the search box.
		  * 
		  * @param evt MouseEvent.CLICK
		  * @see #moveTo
		  */
		protected function searchHandler(e:MouseEvent):void{
			
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
