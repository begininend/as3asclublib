/*
  Version: MPL 1.1/GPL 2.0/LGPL 2.1
 
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.
  
  The Original Code is [maashaack framework].
  
  The Initial Developers of the Original Code are
  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.
  Portions created by the Initial Developers are Copyright (C) 2006-2009
  the Initial Developers. All Rights Reserved.
  
  Contributor(s):
  
  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the LGPL or the GPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.
*/

package org.asclub.string
{
    //import system.text.html.Entities;

    /**
     * The HTML tool class.
     */
    public class HTML
    {

        /**
         * @private
         */        
        private var _data:String;

        /**
         * Creates a new HTML instance.
         * @param text The HTML text value of the object.
         * @param convert The convert flag who indicates if the html text must be encoded.
         */
        public function HTML( text:String = "", convert:Boolean = true )
        {
            if( convert )
            {
                text = HTML.encode( text );
            }
            _data = text;
        }

        /**
         * Appends the specified text in the HTML string.
         * @param text The text to append.
         * @param convert Indicates if the text is encoded. 
         */
        public function append( text:String, convert:Boolean = true ):void
        {
            if( convert )
            {
                text = HTML.encode( text );
            }
            _data += text;
        }        

        /**
         * Encodes the specified text passed in argument.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.HTML  ;
         * trace( HTML.encode("<b>hello world</b>" ) ) ; // &lt;b&gt;hello world&lt;/b&gt;
         * </pre>
         * @return a string encode text.
         */
        public static function encode( text:String ):String
        {
            var html:String = "";
            var c:String;
            var last:String;
            
            var l:uint = text.length ;
            for( var i:uint = 0; i < l ; i++ )
            {
                c = text.charAt( i );
                
                if( (c == " ") && (last != " ") )
                {
                    html += c;
                    last = c;
                    continue;
                }
                
                if( Entities.findByChar( c ) )
                {
                    html += Entities.toHTML( c );
                } 
                else
                {
                    html += c;
                }
                
                last = c;
            }
            
            return html;
        }

        /**
         * Decodes the specified string.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.HTML  ;
         * trace( HTML.decode("&lt;b&gt;hello world&lt;/b&gt;" ) ) ; // <b>hello world</b>
         * </pre>
         * @return the decode string.
         */  
        public static function decode( html:String ):String
        {
            var text:String = "";
            var c:String;
            var ent:String;
            var l:uint = html.length ;
            for( var i:uint = 0 ; i < l ; i++ )
            {
                c = html.charAt( i );
                
                if( c == "&" )
                {
                    ent = c;
                    i++;
                    
                    while( c != ";" )
                    {
                        c = html.charAt( i );
                        ent += c;
                        i++;
                    }
                    
                    text += Entities.fromName( ent );
                    i--;
                    continue;
                }
                
                text += c;
            }
            
            return text;
        }

        /**
         * Returns the String representation of the object.
         * @return the String representation of the object.
         */
        public function toString():String
        {
            return _data;
        }
        
        /* TODO:
           - method toXML or toXMLString
           - method valueOf ? doing an HTML decode to obtain the raw string ? or toHTMLString method
           - static methods to handle HTML tags as bold, paragraph, font, etc. (or a Tag class, BoldTag class, FontTag class, etc...)
        */
    }
}

