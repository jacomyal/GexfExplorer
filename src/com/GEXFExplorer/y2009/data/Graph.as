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

package com.GEXFExplorer.y2009.data{
	
	/**
	 * Permet de stocker en mémoire le graphe (contenant donc les noeuds et les arcs).
	 *
	 * @author Alexis Jacomy
	 */
	public class Graph {
		
		public var nodesList:Vector.<Node>;
		public var edgesList:Vector.<Edge>;
		
		public function Graph() {
			nodesList = new Vector.<Node>();
			edgesList = new Vector.<Edge>();
		}
	
		public function getNodes():Vector.<Node> {
			return nodesList;
		}
		public function getNode(tempId:Number):Node{
			for(var i:Number=0; i<nodesList.length;i++){
				if(nodesList[i].idAccess==tempId)
					break;
			}
			return nodesList[i];
		}
		public function getNodeRegularId(tempId:Number):Number{
			for(var i:Number=0; i<nodesList.length;i++){
				if(nodesList[i].idAccess==tempId)
					break;
			}
			return nodesList[i].regularId;
		}
		public function addNode(tempNode:Node):void{
			nodesList.push(tempNode);
		}
	}
	
}