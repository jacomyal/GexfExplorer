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
	  * Groups all the datas relative to a graph.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  * @see com.GEXFExplorer.y2009.data.Edge
	  * @see com.GEXFExplorer.y2009.data.Node
	  */
	public class Graph {
		
		private var nodesList:Vector.<Node>;
		private var edgesList:Vector.<Edge>;
		private var labelIndex:Array;
		private var attributes:HashMap;
		private var nodesIDTab:HashMap;
		
		private var mapTitle:String;
		private var mapCreator:String;
		
		public function Graph() {
			nodesList = new Vector.<Node>();
			edgesList = new Vector.<Edge>();
			labelIndex = new Array();
			attributes = new HashMap();
			nodesIDTab = new HashMap();
			mapTitle = null;
			mapCreator = null;
		}
		
		/**
		  * Returns nodes list from the graph.
		  * 
		  * @return nodesList
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function get getNodes():Vector.<Node> {
			return nodesList;
		}
		
		/**
		  * Returns graph title.
		  * 
		  * @return mapTitle
		  */
		public function get getTitle():String{
			return mapTitle;
		}
		
		/**
		  * Returns graph creator.
		  * 
		  * @return mapCreator
		  */
		public function get getCreator():String{
			return mapCreator;
		}
		
		/**
		  * Returns node labels list from the graph.
		  * 
		  * @return labelIndex
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function get getLabels():Array {
			return labelIndex;
		}
		
		/**
		  * Returns edges list length.
		  * 
		  * @return edgesList.length
		  * @see com.GEXFExplorer.y2009.data.Edge
		  */
		public function get getEdgesLength():Number {
			return edgesList.length;
		}
		
		/**
		  * Returns ID of parameter attribute.
		  * 
		  * @param s A string ID
		  * @return An attribute ID
		  */
		public function getAttribute(s:String):String {
			return attributes.getValue(s);
		}
		
		/**
		  * Returns artificial ID corresponding to original paramater string ID.
		  * 
		  * @param s A string ID
		  * @return The new good ID or null
		  */
		public function getArtificialID(s:String):int {
			return nodesIDTab.getValue(s);
		}
		
		/**
		  * Returns ID of parameter attribute.
		  * 
		  * @param s A string ID
		  * @return An attribute ID
		  */
		public function cleanHash():void{
			nodesIDTab = null;
		}
		
		/**
		  * Returns node which ID is parameter ID.
		  * 
		  * @param i The node ID
		  * @return The good node or null.
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function getNode(i:Number):Node{
			return nodesList[i];
		}
		
		/**
		  * Returns node which string ID is parameter original ID.
		  * 
		  * @param s The original ID
		  * @return The good node or null.
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function getNodeByOriginalID(s:String):Node{
			return nodesList[nodesIDTab.getValue(s)];
		}
		
		/**
		  * Returns a strings array of each node label containing the string s (parameter).
		  * 
		  * @param s String to test in each label.
		  * @return Array of node labels containing s parameter.
		  */
		public function getLabelContaining(s:String):Array{
			var res:Array = new Array();
			for each(var n:Node in nodesList){
				if(n.labelAccess.toLowerCase().indexOf(s.toLowerCase())>-1){
					res.push(n.idAccess);
				}
			}
			
			return res;
		}
		
		/**
		  * Sets a new connection between an original string node ID and a new int ID.
		  * 
		  * @param originalID The original string ID.
		  * @param newID The new int ID.
		  */
		public function setIDConnection(originalID:String,newID:int):void{
			nodesIDTab.put(originalID,newID);
		}
		
		/**
		  * Sets an attribute.
		  * 
		  * @param attributeID The ID of this attribute.
		  * @param attributeName The name of the attribute.
		  */
		public function setAttribute(attributeID:String,attributeName:String):void{
			attributes.put(attributeID,attributeName);
		}
		
		/**
		  * Sets this graph title.
		  * 
		  * @param t New map title.
		  */
		public function setTitle(t:String):void{
			mapTitle = t;
		}
		
		/**
		  * Sets this graph creator.
		  * 
		  * @param t New map creator.
		  */
		public function setCreator(c:String):void{
			mapCreator = c;
		}
		
		/**
		  * Returns the list of the labels of the neighbours from the node which has the parameter label.
		  * Returns null if there is no corresponding node or no neighbours.
		  * 
		  * @param nodeLabel The label to test.
		  * @return An array of labels.
		  * @see com.GEXFExplorer.y2009.data.Node
		  */
		public function getNeighbours(nodeId:String):Array{
			var target:Node = nodesList[nodeId];
			var s:String;
			var res:Array = null;
			var e:Edge;
			if(target!=null){
				res = new Array();
				
				for each(e in target.getEdgesFrom()){
					s = getNode(e.idTargetAccess).labelAccess;
					if(res.indexOf(s)==-1) res.push(s);
				}
				
				for each(e in target.getEdgesTo()){
					s = getNode(e.idSourceAccess).labelAccess;
					if(res.indexOf(s)==-1) res.push(s);
				}
			}
			
			return(res.sort(compareString));
		}
		
		/**
		  * Pushes a new label into labelIndex.
		  * 
		  * @param newLabel Label to push.
		  */
		public function pushLabel(newLabel:String):void{
			labelIndex.push(newLabel);
		}
		
		/**
		  * Pushes a new node into nodesList.
		  * 
		  * @param tempNode Node to push.
		  */
		public function addNode(tempNode:Node):void{
			nodesList.push(tempNode);
		}
		
		/**
		  * Pushes a new edge into edgesList.
		  * 
		  * @param tempEdge Edge to push.
		  */
		public function addEdge(tempEdge:Edge):void{
			edgesList.push(tempEdge);
		}
		
		/**
		  * Sorts labelIndex.
		  */
		public function sortLabelIndex():void{
			labelIndex.sort(compareString);
		}
		
		/**
		  * Compares two strings in alphabetical order (case unsensitive).
		  * 
		  * @param S1 First string
		  * @param S2 Second string
		  * @return int value: 0 if S1==S2, a positive value if S1<S2, and a negative value if S2<S1.
		  */
		protected function compareString(S1:String, S2:String):int{
			var s1:String = S1.toLowerCase();
			var s2:String = S2.toLowerCase();
			
			return(s1.localeCompare(s2));
		}
		
	}
}