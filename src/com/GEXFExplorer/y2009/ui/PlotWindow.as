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
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;
    import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import com.GEXFExplorer.y2009.text.InputFormatTextField;
	import com.GEXFExplorer.y2009.loading.GEXFLoader;
	import com.GEXFExplorer.y2009.ui.FullScreenButton;
	import com.GEXFExplorer.y2009.visualization.PlotGraph;
	
	/**
	 * Interface d'accueil du projet sous sa version d'essai, permettant de rentrer l'adresse du
	 * graphe directement après le lancement du '.swf'.
	 *
	 * @author Alexis Jacomy
	 */
	public class PlotWindow extends Sprite{
		
		public var windowTitle:TextField;
		public var path:TextField;
		public var pathINPUT:InputFormatTextField;
		public var Gexf:GEXFLoader;
		
		public var titleFormat:TextFormat;
		public var questionFormat:TextFormat;
		
		public var plotButton:SimpleButton;
		
		public function PlotWindow(){
			
			var normal:TextField = new TextField();
			var survol:TextField = new TextField();
			var clic:TextField = new TextField();
			
			normal.text = survol.text = clic.text = "-> Draw the graph";
			
			var plotButtonFormat:TextFormat = new TextFormat();
			plotButtonFormat.font = "Verdana";
			plotButtonFormat.size = 35;
			
			normal.setTextFormat(plotButtonFormat);
			survol.setTextFormat(plotButtonFormat);
			clic.setTextFormat(plotButtonFormat);
			
			normal.textColor = 0x000000;
			survol.textColor = 0x999999;
			clic.textColor = 0xAAAAAA;
			
			var plotButton:SimpleButton = new SimpleButton(normal, survol, clic, normal);
			plotButton.x = 10;
			plotButton.y = 375;
			plotButton.height = 25;
			plotButton.width = 100;
			
			plotButton.addEventListener(MouseEvent.CLICK, plot);
			
			titleFormat = new TextFormat();
			titleFormat.font = "Verdana";
			titleFormat.bold = true;
			titleFormat.size = 10;
			
			questionFormat = new TextFormat();
			questionFormat.font = "Verdana";
			questionFormat.size = 10;
			
			windowTitle = new TextField();
			with(windowTitle){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "GEXF Reader 0.2";
				x = 10;
				y = 295;
				setTextFormat(titleFormat);
			}
			
			path = new TextField();
			with(path){
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				text = "GEXF file path :";
				x = 10;
				y = 325;
				setTextFormat(questionFormat);
			}
			
			pathINPUT = new InputFormatTextField();
			with(pathINPUT){
				x = 10;
				y = 345;
			}
			pathINPUT.setText("C:/test.gexf");
			pathINPUT.actualize();
			
			addChild(plotButton);
			addChild(windowTitle);
			addChild(path);
			addChild(pathINPUT);
			
			pathINPUT.addEventListener(MouseEvent.DOUBLE_CLICK, clearInputField);
		}
	
		public function clearInputField(evt:MouseEvent):void{
			evt.target.text = "";
		}
		
		protected function plot(evt:MouseEvent):void{
			var adresse:String = pathINPUT.inputTextField.text;
			Gexf = new GEXFLoader(adresse);
			parent.addChild(Gexf);
			
			var tempTimer:Timer = new Timer(1000);
			tempTimer.addEventListener(TimerEvent.TIMER, whenGraphIsDrawn);
			tempTimer.start();
		}
		
		protected function whenGraphIsDrawn(evt:TimerEvent){
			evt.target.stop();
			evt.target.removeEventListener(TimerEvent.TIMER, whenGraphIsDrawn);
			var optWin:OptionsWindow = new OptionsWindow(Gexf);
			
			parent.addChild(optWin);
			parent.removeChild(this);
		}
		
	}
}