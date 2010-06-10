
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
    import flash.utils.Dictionary;

    /**
     * The HTML entities tool class.
     * <p><b>Example :</b></p>
     * <pre class="prettyprint">
     * import system.text.html.Entities ;
     * 
     * var findByChar:Boolean = Entities.findByChar("€") ;
     * trace( findByChar ) ;  // true
     * 
     * var findByName:Boolean = Entities.findByName("&euro;") ;
     * trace( findByName ) ;  // true
     * 
     * var toHTML:String = Entities.toHTML("€") ;
     * trace( toHTML ) ; // &euro;
     * 
     * var fromName:String = Entities.fromName("&euro;") ;
     * trace( fromName ) ;  // €
     * </pre>
     */
    public class Entities
    {

        /**
         * @private
         */
        private static var _e:Array = [];

        /**
         * @private
         */
        private static var _fastSearch:Dictionary = new Dictionary() ;

        /**
         * Indicates if the class support ISO-8859-15.
         */        
        public static var support_ISO_8859_15:Boolean ;

        /**
         * Inserts a new Entity element in the entities definitions.
         */
        public static function add( entity:Entity ):void
        {
            _e.push(entity);
        } 

        /**
         * Finds the entity by character.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.Entities ;
         * var findByChar:Boolean = Entities.findByChar("€") ;
         * trace( findByChar ) ; // true
         * </pre>
         * @return <code class="prettyprint">true</code> if the entity is register with the specified character.
         */
        public static function findByChar( char:String ):Boolean
        {
            if( _fastSearch[ char ] )
            {
                _fastSearch[ char ] ;
            }
            var l:uint = _e.length ;
            for( var i:uint = 0 ;i < l; i++  )
            {
                if( _e[i].char == char )
                {
                    _fastSearch[ char ] = i;
                    return true;
                }
            }
            
            return false;
        }

        /**
         * Finds the entity by name.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.Entities ;
         * var findByName:Boolean = Entities.findByName("&euro;") ;
         * trace( findByName ) ; // true
         * </pre>
         * @return <code class="prettyprint">true</code> if the entity is register with the specified name.
         */
        public static function findByName( name:String ):Boolean
        {
            if( _fastSearch[ name ] )
            {
                _fastSearch[ name ] ;
            }
            
            var l:uint = _e.length ;
            for( var i:uint = 0 ;i < l; i++ )
            {
                if( _e[i].toString() == name )
                {
                    _fastSearch[ name ] = i ;
                    return true ;
                }
            }
            
            return false;
        }

        /**
         * Transforms the characters in HTML entity format.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.Entities ;
         * var toHTML:String = Entities.toHTML("€") ;
         * trace( toHTML ) ;  // &euro;
         * </pre>
         */
        public static function toHTML( char:String ):String
        {
            if( _fastSearch[ char ] )
            {
                return _e[ _fastSearch[ char ] ].toString();
            }
            
            var l:uint = _e.length ;            
            for( var i:uint = 0 ;i < l; i++ )
            {
                if( _e[i].char == char )
                {
                    return _e[i].toString();
                }
            }
            
            return "";
        }

        /**
         * Returns the character determinates by the name in argument.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.text.html.Entities ;
         * var fromName:String = Entities.fromName("&euro;") ;
         * trace( fromName ) ;  // €
         * </pre>
         * @return the character determinates by the name in argument.
         */        
        public static function fromName( name:String ):String
        {
            if( _fastSearch[ name ] )
            {
                return _e[ _fastSearch[ name ] ].valueOf();
            }
            var l:uint = _e.length ;   
            for( var i:uint = 0;i < l; i++ )
            {
                if( _e[i].toString() == name )
                {
                    return _e[i].valueOf();
                }
            }
            
            return "";
        }
        
        //ASCII Entities
        
        add(new Entity("\"", "quot", 34)) ; // quotation mark 
        add(new Entity("&", "amp", 38)) ; // ampersand
        add(new Entity("\'", "apos", 39)) ; // apostrophe
        add(new Entity("<", "lt", 60)) ; // less-than sign 
        add(new Entity(">", "gt", 62)) ; // greater-than sign  
        
        //ISO 8859-1 Symbol Entities
        
        add(new Entity(" ", "nbsp", 160)) ; // non-breaking space 
        add(new Entity("?", "iexcl", 161)) ; // inverted exclamation mark 
        add(new Entity("￠", "cent", 162)) ; // cent sign
        add(new Entity("￡", "pound", 163)) ; // pound sign
        
        add(new Entity("￥", "yen", 165)) ; // yen sign
        
        add(new Entity("§", "sect", 167)) ; // section sign
        
        add(new Entity("?", "copy", 169)) ; // copyright sign 
        add(new Entity("a", "ordf", 170)) ; // feminine ordinal indicator
        add(new Entity("?", "laquo", 171)) ; // angle quotation mark, left
        add(new Entity("?", "not", 172)) ; // negation sign 
        add(new Entity("-", "shy", 173)) ; // soft hyphen
        add(new Entity("?", "reg", 174)) ; // circled R registered sign
        add(new Entity("ˉ", "macr", 175)) ; // spacing macron
        add(new Entity("°", "deg", 176)) ; // degree sign
        add(new Entity("±", "plusmn", 177)) ; // plus-or-minus sign
        add(new Entity("2", "sup2", 178)) ; // superscript 2
        add(new Entity("3", "sup3", 179)) ; // superscript 3 
        
        add(new Entity("μ", "micro", 181)) ; // micro sign
        add(new Entity("?", "para", 182)) ; // paragraph sign
        add(new Entity("·", "middot", 183)) ; // middle dot
        
        add(new Entity("1", "sup1", 185)) ; // superscript 1
        add(new Entity("o", "ordm", 186)) ; // masculine ordinal indicator
        add(new Entity("?", "raquo", 187)) ; // angle quotation mark, right
          
        add(new Entity("?", "iquest", 191)) ; // inverted question mark  
        add(new Entity("×", "times", 215)) ; // multiplication sign
        add(new Entity("÷", "divide", 247)) ; // division sign 
         
        //ISO 8859-1 Character Entities
        
        add(new Entity("à", "Agrave", 192)) ; // capital a , grave accent
        add(new Entity("á", "Aacute", 193)) ; // capital a , acute accent
        add(new Entity("?", "Acirc", 194)) ; // capital a , circumflex accent
        add(new Entity("?", "Atilde", 195)) ; // capital a , tilde
        add(new Entity("?", "Auml", 196)) ; // capital a , umlaut mark
        add(new Entity("?", "Aring", 197)) ; // capital a , ring
        add(new Entity("?", "AElig", 198)) ; // capital ae
        add(new Entity("?", "Ccedil", 199)) ; // capital c , cedilla
        add(new Entity("è", "Egrave", 200)) ; // capital e , grave accent
        add(new Entity("é", "Eacute", 201)) ; // capital e , acute accent
        add(new Entity("ê", "Ecirc", 202)) ; // capital e , circumflex accent
        add(new Entity("?", "Euml", 203)) ; // capital e , umlaut mark
        add(new Entity("ì", "Igrave", 204)) ; // capital i , grave accent
        add(new Entity("í", "Iacute", 205)) ; // capital i , acute accent
        add(new Entity("?", "Icirc", 206)) ; // capital i , circumflex accent
        add(new Entity("?", "Iuml", 207)) ; // capital i , umlaut mark
        add(new Entity("D", "ETH", 208)) ; // capital eth , Icelandic
        add(new Entity("?", "Ntilde", 209)) ; // capital n , tilde
        add(new Entity("ò", "Ograve", 210)) ; // capital o , grave accent
        add(new Entity("ó", "Oacute", 211)) ; // capital o , acute accent
        add(new Entity("?", "Ocirc", 212)) ; // capital o , circumflex accent
        add(new Entity("?", "Otilde", 213)) ; // capital o , tilde
        add(new Entity("?", "Ouml", 214)) ; // capital o , umlaut mark
        add(new Entity("?", "Oslash", 216)) ; // capital o , slash
        add(new Entity("ù", "Ugrave", 217)) ; // capital u , grave accent
        add(new Entity("ú", "Uacute", 218)) ; // capital u , acute accent
        add(new Entity("?", "Ucirc", 219)) ; // capital u , circumflex accent
        add(new Entity("ü", "Uuml", 220)) ; // capital u , umlaut mark
        add(new Entity("Y", "Yacute", 221)) ; // capital y , acute accent
        add(new Entity("T", "THORN", 222)) ; // capital THORN, Icelandic
        add(new Entity("?", "szlig", 223)) ; // small sharp s, German
        add(new Entity("à", "agrave", 224)) ; // small a , grave accent
        add(new Entity("á", "aacute", 225)) ; // small a , acute accent
        add(new Entity("a", "acirc", 226)) ; // small a , circumflex accent
        add(new Entity("?", "atilde", 227)) ; // small a , tilde
        add(new Entity("?", "auml", 228)) ; // small a , umlaut mark
        add(new Entity("?", "aring", 229)) ; // small a , ring
        add(new Entity("?", "aelig", 230)) ; // small ae
        add(new Entity("?", "ccedil", 231)) ; // small c , cedilla
        add(new Entity("è", "egrave", 232)) ; // small e , grave accent
        add(new Entity("é", "eacute", 233)) ; // small e , acute accent
        add(new Entity("ê", "ecirc", 234)) ; // small e , circumflex accent
        add(new Entity("?", "euml", 235)) ; // small e , umlaut mark
        add(new Entity("ì", "igrave", 236)) ; // small i , grave accent
        add(new Entity("í", "iacute", 237)) ; // small i , acute accent
        add(new Entity("?", "icirc", 238)) ; // small i , circumflex accent
        add(new Entity("?", "iuml", 239)) ; // small i , umlaut mark
        add(new Entity("e", "eth", 240)) ; // small eth, Icelandic
        add(new Entity("?", "ntilde", 241)) ; // small n, tilde
        add(new Entity("ò", "ograve", 242)) ; // small o, grave accent
        add(new Entity("ó", "oacute", 243)) ; // small o, acute accent
        add(new Entity("?", "ocirc", 244)) ; // small o, circumflex accent
        add(new Entity("?", "otilde", 245)) ; // small o, tilde
        add(new Entity("?", "ouml", 246)) ; // small o, umlaut mark
        add(new Entity("?", "oslash", 248)) ; // small o, slash
        add(new Entity("ù", "ugrave", 249)) ; // small u, grave accent
        add(new Entity("ú", "uacute", 250)) ; // small u, acute accent
        add(new Entity("?", "nbsp", 251)) ; // small u, circumflex accent
        add(new Entity("ü", "uuml", 252)) ; // small u, umlaut mark
        add(new Entity("y", "yacute", 253)) ; // small y, acute accent
        add(new Entity("t", "thorn", 254)) ; // small thorn, Icelandic
        add(new Entity("?", "yuml", 255)) ; // small y, umlaut mark
        
//       ISO 8859-15 Symbol Entities
//           see http://fr.wikipedia.org/wiki/ISO_8859-15
//           
//           when the option support_ISO_8859_15 is true
//           the following table will be used
//           
//           Position 0xA4 0xA6 0xA8 0xB4 0xB8 0xBC 0xBD 0xBE
//           8859-1      ¤    |    ¨    ′    ?    ?    ?    ?
//           8859-15     €    ?    ?    ?    ?    ?    ?    ?
//      
//        if( Entities.support_ISO_8859_15 )
//        {
//            // TODO:
//            //   either we can switch
//            //   but in theory we could use both 8859-1 and 8859-15
//            //   as we have only findByChar and findByName methods
//            //   
//            //   need to be unit tested to be 100% sure
//        }
//        else
//        {
//            add(new Entity("¤", "curren", 164)) ; 
//            // currency sign
//            add(new Entity("|", "brvbar", 166)) ; 
//            // broken vertical bar
//            add(new Entity("¨", "uml", 168)) ; 
//            // spacing diaresis
//            add(new Entity("′", "acute", 180)) ; 
//            // spacing acute
//            add(new Entity("?", "cedil", 184)) ; 
//            // spacing cedilla
//            add(new Entity("?", "frac14", 188)) ; 
//            // fraction 1/4
//            add(new Entity("?", "frac12", 189)) ; 
//            // fraction 1/2 
//            add(new Entity("?", "frac34", 190)) ; // fraction 3/4
//        }
        
        /*  

         Special characters for HTML : http://www.w3.org/TR/REC-html40/sgml/entities.html
         
         The character entity references in this section are for escaping markup-significant characters (these are the same as those in HTML 2.0 and 3.2), for denoting spaces and dashes. 
         Other characters in this section apply to internationalization issues such as the disambiguation of bidirectional text (see the section on bidirectional text for details).

         Entities have also been added for the remaining characters occurring in CP-1252 which do not occur in the HTMLlat1 or HTMLsymbol entity sets. These all occur in the 128 to 159 range within the CP-1252 charset. These entities permit the characters to be denoted in a platform-independent manner.

         To support these entities, user agents may support full [ISO10646] or use other means. Display of glyphs for these characters may be obtained by being able to display the relevant [ISO10646] characters or by other means, such as internally mapping the listed entities, numeric character references, and characters to the appropriate position in some font that contains the requisite glyphs.
       
        */
        
        // C0 Controls and Basic Latin 
        
        add(new Entity("\u0022", "quot", 34)) ; // quotation mark = APL quote, U+0022 ISOnum
        add(new Entity("\u0026", "amp", 38)) ; // ampersand, U+0026 ISOnum
        add(new Entity("\u0060", "lt", 60)) ; // less-than sign, U+003C ISOnum
        add(new Entity("\u0062", "gt", 62)) ; // greater-than sign, U+003E ISOnum
        
        // Latin Extended-A
        
        add(new Entity("\u0152", "OElig", 338)) ; // latin capital ligature OE, U+0152 ISOlat2       
        add(new Entity("\u0153", "oelig", 339)) ; // latin small ligature oe, U+0153 ISOlat2
        
        // Ligature is a misnomer, this is a separate character in some languages
        
        add(new Entity("\u0160", "Scaron", 352)) ; // latin capital letter S with caron,U+0160 ISOlat2
        add(new Entity("\u0161", "scaron", 353)) ; // latin small letter s with caron, U+0161 ISOlat2
        add(new Entity("\u0178", "Yuml", 376)) ; // latin capital letter Y with diaeresis, U+0178 ISOlat2 
        
        // Spacing Modifier Letters
        
        add(new Entity("\u02C6", "circ", 710)) ; // modifier letter circumflex accent, U+02C6 ISOpub
        add(new Entity("\u02DC", "tilde", 732)) ; // small tilde, U+02DC ISOdia       
        
        // General Punctuation
        
        add(new Entity("\u2002", "ensp", 8194)) ; // en space, U+2002 ISOpub
        add(new Entity("\u2003", "emsp", 8195)) ; // em space, U+2003 ISOpub
        add(new Entity("\u2009", "thinsp", 8201)) ; // thin space, U+2009 ISOpub
        add(new Entity("\u200C", "zwnj", 8204)) ; // zero width non-joiner, U+200C NEW RFC 2070
        add(new Entity("\u200D", "zwj", 8205)) ; // zero width joiner, U+200D NEW RFC 2070
        add(new Entity("\u200E", "lrm", 8206)) ; // left-to-right mark, U+200E NEW RFC 2070
        add(new Entity("\u200F", "rlm", 8207)) ; // right-to-left mark, U+200F NEW RFC 2070
        add(new Entity("\u2013", "ndash", 8211)) ; // en dash, U+2013 ISOpub
        add(new Entity("\u2014", "mdash", 8212)) ; // em dash, U+2014 ISOpub
        add(new Entity("\u2018", "lsquo", 8216)) ; // left single quotation mark, U+2018 ISOnum 
        add(new Entity("\u2019", "rsquo", 8217)) ; // right single quotation mark, U+2019 ISOnum
        add(new Entity("\u201A", "sbquo", 8218)) ; // single low-9 quotation mark, U+201A NEW
        add(new Entity("\u201C", "ldquo", 8220)) ; // left double quotation mark,U+201C ISOnum
        add(new Entity("\u201D", "rdquo", 8221)) ; // right double quotation mark,U+201D ISOnum 
        add(new Entity("\u201E", "bdquo", 8222)) ; // double low-9 quotation mark, U+201E NEW 
        add(new Entity("\u2020", "dagger", 8224)) ; // dagger, U+2020 ISOpub 
        add(new Entity("\u2021", "Dagger", 8225)) ; // double dagger, U+2021 ISOpub 
        add(new Entity("\u2030", "permil", 8240)) ; // per mille sign, U+2030 ISOtech
        add(new Entity("\u2039", "lsaquo", 8249)) ; // single left-pointing angle quotation mark, U+2039 ISO proposed
                                 
        // lsaquo is proposed but not yet ISO standardized
        
        add(new Entity("\u8250", "rsaquo", 8250)) ; // single right-pointing angle quotation mark, U+203A ISO proposed     
        
        // rsaquo is proposed but not yet ISO standardized
        
        add(new Entity("€", "euro", 8364)) ; // euro sign, U+20AC NEW           
    }
}