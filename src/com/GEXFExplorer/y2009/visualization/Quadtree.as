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

package com.GEXFExplorer.y2009.visualization{
	
	import com.GEXFExplorer.y2009.data.Node;
	import com.GEXFExplorer.y2009.data.Quad;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	* Classe Quadtree de base. Elle permet de mettre en place le Quadtree.
	* 
	* Pour manipuler les coordonnées dans l'arbre, j'utilise un array qui
	* contient un array des positions consécutives du point dans l'arbre
	* suivant x, puis le même pour y.
	* En particulier, elle contient la liste de toutes les zones non vides
	* à la profondeur depth.
	* 
	* @author Alexis Jacomy
	*/
	public class Quadtree{
		
		public var plotGraph:PlotGraph;
		public var nodesVector:Vector.<Node>;
		public var fullAreasArray:Array;
		public var quadtreeViz:Sprite;
		
		private var depth:int;
	
		
		/**
		 * Crée une instance de Quadtree, et initialise les variables.
		 * 
		 * @param newDepth Profondeur de l'arbre
		 * @param newDegreeX Numbre de fils sur x par père
		 * @param newDegreeY Numbre de fils sur y par père
		 */		
		public function Quadtree(newDepth:int,pGraph:PlotGraph){
			depth = newDepth;
			plotGraph = pGraph;
			quadtreeViz = new Sprite();
			plotGraph.addChild(quadtreeViz);
			fullAreasArray = new Array();
		}
	
		/**
		 * Actualise les EventListeners.
		 */
		public function actualize(){
			trace("Quadtree:actualize()");
			
			nodesVector = plotGraph.globalGraph.getNodes();
			setFullAreasArray();
		}
	
		/**
		 * Renvoie les coordonnées dans le Quadtree du point en (xVar,yVar), sous la forme:
		 * ((liste des positions à chaque étage de l'arbre suivant x),(pareil en y))
		 * 
		 * @param xVar Position du point paramètre en x
		 * @param yVar Position du point paramètre en y
		 */		
		public function getArrayCoordinates(xVar:Number,yVar:Number):Array{
			trace("Quadtree:getArrayCoordinates("+xVar+","+yVar+"):");
			
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempPowIx:Number;
			var tempPowIy:Number;
			var tempArrayX:Array = new Array();
			var tempArrayY:Array = new Array();
			var tempWidth:Number = plotGraph.stage.stageWidth;
			var tempHeight:Number = plotGraph.stage.stageHeight;
			
			var goodXVar:Number = (xVar+plotGraph.x)*plotGraph.ratio;
			var goodYVar:Number = (yVar+plotGraph.y)*plotGraph.ratio;
			trace("\tGood coordinates: x: "+goodXVar+", y: "+goodYVar);
			
			var tempXCase:Number;
			var tempYCase:Number;
			
			var xArray:Array = new Array();
			var yArray:Array = new Array();
			
			var resultArray:Array = new Array();
			
			for (i=0;i<depth;i++){
				tempPowIx = tempWidth/Math.pow(2,i+1);
				tempPowIy = tempHeight/Math.pow(2,i+1);
				
				tempXCase = Math.floor((goodXVar-tempTopLeft_x)/tempPowIx);
				tempYCase = Math.floor((goodYVar-tempTopLeft_y)/tempPowIy);
				
				tempTopLeft_x += tempPowIx*tempXCase;
				tempTopLeft_y += tempPowIy*tempYCase;
				
				xArray.push(tempXCase);
				yArray.push(tempYCase);
			}
			
			resultArray.push(xArray);
			resultArray.push(yArray);
			
			trace(resultArray);
			return(resultArray);
			
			tempSprite.graphics.endFill();
		}
	
		/**
		 * Renvoie une valeur booléenne qui indique si le noeud de l'arbre
		 * passé en paramètre est à l'écran ou pas.
		 * 
		 * @param arrayVar Liste des positions consécutives dans l'arbre
		 */		
		public function isOnScreen(arrayVar:Array):Boolean{
			
			var resultBool:Boolean = true;
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempWidth:Number = plotGraph.width;
			var tempHeight:Number = plotGraph.height;
			var tempScreenWidth:Number = plotGraph.stage.stageWidth;
			var tempScreenHeight:Number = plotGraph.stage.stageHeight;
			var tempPowIx:Number = tempWidth;
			var tempPowIy:Number = tempHeight;
			
			while((resultBool==true)&&(i<depth)){
				
				tempPowIx = tempPowIx/2;
				tempPowIy = tempPowIy/2;
				
				tempTopLeft_x += tempPowIx*arrayVar[0][i];
				tempTopLeft_y += tempPowIy*arrayVar[1][i];
				
				if(((tempTopLeft_x-plotGraph.x)/plotGraph.scaleX>=plotGraph.x+tempScreenWidth)||
				   ((tempTopLeft_x+tempPowIx-plotGraph.x)/plotGraph.scaleX<=plotGraph.x)||
				   ((tempTopLeft_y-plotGraph.y)/plotGraph.scaleY>=plotGraph.y+tempScreenHeight)||
				   ((tempTopLeft_y+tempPowIy-plotGraph.y)/plotGraph.scaleY<=plotGraph.y))
				{
					resultBool = false;
					return(resultBool);
				}
				i++;
			}
			
			trace("QuadTree:isOnScreen:");
			trace("\tSquare in.");
			return(resultBool);
		}
	
		/**
		 * Détermine les zones de la scène non vides.
		 */		
		public function setFullAreasArray():void{
			trace("Quadtree:setFullAreasArray()");
			var tempIndex:Number;
			var tempNode:Node;
			var tempCoordinatesArray:Array;
			var tempArray:Array;
			
			var tempQuadArray:Array = new Array();
			
			for each(tempNode in nodesVector){
				trace("Node n°"+tempNode.id);
				tempCoordinatesArray = getArrayCoordinates(tempNode.x,tempNode.y);
				tempIndex = index(tempCoordinatesArray,tempQuadArray);
				if(tempIndex==-1){
					tempQuadArray.push(tempCoordinatesArray);
					fullAreasArray.push(new Quad(tempCoordinatesArray));
					fullAreasArray[fullAreasArray.length-1].push(tempNode);
				}else{
					fullAreasArray[tempIndex].push(tempNode);
				}
			}
			
			//traceAreas();
		}
	
		/**
		 * Permet de tracer l'arborescence d'un noeud (chaque fils est tracé sous la forme
		 * de son carré). La transparence permet d'interpréter le dessin des carrés comme une
		 * sorte de densité en sommet (du graphe) du plan.
		 * 
		 * @param arrayVar Position dans l'arbre du noeud à afficher
		 */		
		public function drawQuadFromArray(arrayVar:Array):void{
			var i:Number = 0;
			var tempTopLeft_x:Number = 0;
			var tempTopLeft_y:Number = 0;
			var tempPowIx:Number;
			var tempPowIy:Number;
			var tempAlpha:Number = 0.01;
			var tempArrayX:Array = new Array([]);
			var tempArrayY:Array = new Array([]);
			var tempWidth:Number = quadtreeViz.stage.stageWidth;
			var tempHeight:Number = quadtreeViz.stage.stageHeight;
			
			for (i=0;i<depth;i++){
				tempPowIx = tempWidth/Math.pow(2,i+1);
				tempPowIy = tempHeight/Math.pow(2,i+1);
				
				tempTopLeft_x += tempPowIx*arrayVar[0][i];
				tempTopLeft_y += tempPowIy*arrayVar[1][i];
				
				quadtreeViz.graphics.beginFill(0xFFFFFF,0);
				quadtreeViz.graphics.lineStyle(1,0xAAAAAA,0.5);
				quadtreeViz.graphics.drawRect(tempTopLeft_x,tempTopLeft_y,tempPowIx,tempPowIy);
				quadtreeViz.graphics.endFill();
				
				tempAlpha = (5*tempAlpha + 1)/6;
			}
		}
	
		/**
		 * Permet de trouver dans un array mutlidimmensionnel la position
		 * d'un aure array, passé en premier paramètre.
		 * 
		 * @param array Tableau à comparer aux autres tableaux
		 * @param arrayContainer Tableau contenant les autres tableaux
		 */		
		public function index(array:Array,arrayContainer:Array):Number{
			
			var a1:Array = new Array();
			var a2:Array = new Array();
			var i:Number;
			var j:Number;
			
			for(i=0;i<array.length;i++){
				a1.push(array[i]);
			}
			
			for(i=0;i<arrayContainer.length;i++){
				a2.push(new Array());
				for(j=0;j<arrayContainer[i].length;j++){
					a2[i].push(arrayContainer[i][j]);
				}
			}
			
			var s1:String = a1.sort().toString();
			var s2:String;
			
			for(i=0;i<a2.length;i++){
				s2=a2[i].sort().toString();
				if(s2==s1){
					return(i);
				}
			}
			
			return(-1);
		}
	
		/**
		 * Affiche en console la position de chaque zone et les ID de tous
		 * les noeuds pour chacune des zones.
		 */		
		public function traceAreas():void{
			var tempQuad:Quad;
			var tempNode:Node;
			var i:Number = 0;
			
			for each(tempQuad in fullAreasArray){
				trace("Area n°"+i+":\n\tPosition in the tree:\n\t\ton x:("+tempQuad.quadPosition[0]+")\n\t\ton y:("+tempQuad.quadPosition[1]+")");
				for each(tempNode in tempQuad.nodesArray){
					trace("\tNode n°"+tempNode.id+", x: "+tempNode.x+", y: "+tempNode.y);
				}
				
				drawQuadFromArray(tempQuad.quadPosition);
				
				i++;
			}
		}
	}
	
}