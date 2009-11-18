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
	
	import flash.display.Sprite;
	
	/**
	  * Represents edge from the file in the memory.
	  * 
	  * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	  * @langversion ActionScript 3.0
	  * @playerversion Flash 10
	  * @see Node
	  * @see Graph
	  */
	public class Edge extends Sprite {
		
		private var idSource:Number;
		private var idTarget:Number;
		
		/**
		  * Initializes the edge.
		  * 
		  * @param newIdSource Source node ID
		  * @param newIdTarget Target node ID
		  */
		public function Edge(newIdSource:Number,newIdTarget:Number){
			idSource = newIdSource;
			idTarget = newIdTarget;
			trace("New edge: source: "+idSource+", target: "+idTarget);
		}
		
		/**
		  * Returns the source node ID.
		  * 
		  * @return The source node ID.
		  * @see Node
		  */
		public function get idSourceAccess():Number {
			return idSource;
		}
		
		/**
		  * Returns the target node ID.
		  * 
		  * @return The target node ID.
		  * @see Node
		  */
		public function get idTargetAccess():Number {
			return idTarget;
		}
	}
}