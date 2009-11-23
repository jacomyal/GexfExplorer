 /*
 Copyright (c) 2006 - 2008  Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is 
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in 
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
 THE SOFTWARE.

 @internal
 */

package com.GEXFExplorer.y2009.data {
	
    import flash.utils.Dictionary;
    
    /**
     *
     * IMap implementation which dynamically creates a HashMap
     * of key / value pairs and provides a standard API for
     * working with the map
     *
     * @example The following example demonstrates a typical 
     * use-case in a <code>Hashmap</code> instance has keys 
     * and values added and retrieved.
     * 
     * <listing version="3.0">
     *
     * import com.ericfeminella.collections.HashMap;
     * import com.ericfeminella.collections.IMap;
     *
     * private function init() : void
     * {
     *     var map:IMap = new HashMap();
     *     map.put("a", "value A");
     *     map.put("b", "value B");
     *     map.put("c", "value C");
     *     map.put("x", "value X");
     *     map.put("y", "value Y");
     *     map.put("z", "value Z");
     *
     *     trace( map.getKeys() );
     *     trace( map.getValues() );
     *     trace( map.size() );
     *
     *     // outputs the following:
     *     // b,x,z,a,c,y
     *     // value B,value X,value Z,value A,value C,value Y
     *     // 6
     * }
     *
     * </listing>
     *
     * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/Dictionary.html
     * @see com.ericfeminella.collections.IMap
     *
     */
    public class HashMap
    {
        /**
         * 
         * Defines the underlying object which contains the key / value 
         * mappings of an <code>IMap</code> implementation.
         * 
         * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/Dictionary.html
         * 
         */
        protected var map:Dictionary;
        
        /**
         *
         * Creates a new HashMap instance. By default, weak key
         * references are used in order to ensure that objects are
         * eligible for Garbage Collection iimmediatly after they
         * are no longer being referenced, if the only reference to
         * an object is in the specified HashMap object, the key is
         * eligible for garbage collection and is removed from the
         * table when the object is collected
         *
         * @example
         * 
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.HashMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new HashMap( false );
         *
         * </listing>
         *
         * @param specifies if weak key references should be used
         *
         */
        public function HashMap(useWeakReferences:Boolean = true)
        {
            map = new Dictionary( useWeakReferences );
        }

        /**
         *
         * Adds a key and value to the HashMap instance
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.HashMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new HashMap();
         * map.put( "user", userVO );
         *
         * </listing>
         *
         * @param the key to add to the map
         * @param the value of the specified key
         *
         */
        public function put(key:*, value:*) : void
        {
            map[key] = value;
        }

        /**
         *
         * Returns the value of the specified key from the HashMap 
         * instance.
         * 
         * <p>
         * If multiple keys exists in the map with the same value,
         * the first key located which is mapped to the specified
         * value will be returned.
         * </p>
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.HashMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new HashMap();
         * map.put( "admin", adminVO );
         *
         * trace( map.getKey( adminVO ) ); //admin
         *
         * </listing>
         *
         * @param  the key in which to retrieve the value of
         * @return the value of the specified key
         *
         */
        public function getKey(value:*) : *
        {
            var id:String = null;

            for ( var key:* in map )
            {
                if ( map[key] == value )
                {
                    id = key;
                    break;
                }
            }
            return id;
        }

        /**
         *
         * Retrieves the value of the specified key from the HashMap instance
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.HashMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new HashMap();
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getValue( "editor" ) ); //[object, editorVO]
         *
         * </listing>
         *
         * @param  the key in which to retrieve the value of
         * @return the value of the specified key, otherwise returns undefined
         *
         */
        public function getValue(key:*) : *
        {
            return map[key];
        }

        /**
         *
         * Retrieves each value assigned to each key in the HashMap instance
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.HashMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new HashMap();
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getValues() ); //[object, adminVO],[object, editorVO]
         *
         * </listing>
         *
         * @return Array of values assigned for all keys in the map
         *
         */
        public function getValues() : Array
        {
            var values:Array = [];

            for (var key:* in map)
            {
                values.push( map[key] );
            }
            return values;
        }

        /**
         *
         * Retrieves the while map.
         *
         * @return the whole dictionnary
         */
        public function getMap() : Dictionary
        {
            return (map);
        }
    }
}