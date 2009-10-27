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

package com.GEXFExplorer.y2009.data {
	
	import flash.display.Sprite;
	
	/**
	* Classe qui modifie les coordonnées dans le QuadTree en carré graphique.
	* 
	* Chaque carré (QuadtreeSquare) contient graphiquement tous les noeuds qui sont
	* situés dessus.
	* 
	* @author Alexis Jacomy
	*/
	public class Quad {
		
		public var quadPosition:Array;
		public var nodesArray:Array;
		
		public var edgesContainer:Sprite;
		public var nodesContainer:Sprite;
		public var textsContainer:Sprite;
		public var hitAreasContainer:Sprite;
		
		public function Quad(newQuadPosition:Array) {
			trace("QuadtreeSquare:QuadtreeSquare()");
			
			quadPosition = newQuadPosition;
			nodesArray = new Array();
			
			edgesContainer = new Sprite();
			nodesContainer = new Sprite();
			textsContainer = new Sprite();
			hitAreasContainer = new Sprite();
		}
		
		public function push(tempNode:Node){
			nodesArray.push(tempNode);
		}
	}
	
}