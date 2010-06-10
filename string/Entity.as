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

    /**
     * The Entity class.
     */
    public class Entity
    {

        /**
         * The String char value of the entity.
         */
        public var char:String;

        /**
         * The String name value of the entity.
         */
        public var name:String;

        /**
         * The Number value of the entity.
         */
        public var number:int;

        /**
         * Creates a new Entity instance.
         * @param char The entity character value.
         * @param name The entity name of the specified character.
         * @param number The entity number representation of the specified character.
         */
        public function Entity( char:String, name:String, number:int )
        {
            this.char = char   ;
            this.name = name   ;
            this.number = number ;
        }

        /**
         * Returns the 'entity number' string representation of the entity.
         * @return the 'entity number' string representation of the entity.
         */
        public function toNumber():String
        {
            return "&#" + number + ";" ;
        }

        /**
         * Returns the 'entity string' representation of the entity.
         * @return the 'entity string' representation of the entity.
         */
        public function toString():String
        {
            return "&" + name + ";" ;
        }

        /**
         * Returns the character value of the entity.
         * @return the character value of the entity.
         */
        public function valueOf():String
        {
            return char ;
        }
    }
}

