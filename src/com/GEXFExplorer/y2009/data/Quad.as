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
	  * Represents leaf nodes of the quadtree.
	  * Each quad corresponds to coordinates in the tree as well as to a rectangle on screen.
	  * This rectangle is proportional to the screen, with pow(2,-quadtree.depth) as ratio.
	  * Each node contains graphically some nodes, to simplify Flash graphic elements management.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  * @see com.GEXFExplorer.y2009.visualization.Quadtree
	  */
	public class Quad {
		
		private var position:Array;
		private var nodesArray:Array;
		
		public var edgesContainer:Sprite;
		public var nodesContainer:Sprite;
		public var textsContainer:Sprite;
		public var hitAreasContainer:Sprite;
	
		/**
		  * Represents each node from the file in the memory.
		  * 
		  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
		  * @see com.GEXFExplorer.y2009.data.Edge
		  * @see com.GEXFExplorer.y2009.data.Graph
		  */
		public function Quad(newPosition:Array) {
			position = newPosition;
			nodesArray = new Array();
			
			edgesContainer = new Sprite();
			nodesContainer = new Sprite();
			textsContainer = new Sprite();
			hitAreasContainer = new Sprite();
		}
		
		/**
		  * Returns this quad position in the quadtree.
		  * 
		  * @return nodesList
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function get positionAccess(){
			return position;
		}
		
		/**
		  * Returns nodes list from this quad.
		  * 
		  * @return nodesArray
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function get nodesArrayAccess(){
			return nodesArray;
		}
		
		/**
		  * Pushes a node (parameter) in nodesArray.
		  * 
		  * @param tempNode Node to push in the array.
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function push(tempNode:Node){
			nodesArray.push(tempNode);
		}
	}
	
}