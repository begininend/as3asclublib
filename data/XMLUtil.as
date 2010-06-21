package org.asclub.data
{
	import flash.xml.XMLDocument;
	public class XMLUtil
	{
		/**
		 * Constant representing a text node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static const TEXT:String = "text";
		
		/**
		 * Constant representing a comment node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const COMMENT:String = "comment";
		
		/**
		 * Constant representing a processing instruction type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const PROCESSING_INSTRUCTION:String = "processing-instruction";
		
		/**
		 * Constant representing an attribute type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ATTRIBUTE:String = "attribute";
		
		/**
		 * Constant representing a element type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ELEMENT:String = "element";
		
		/**
		 * Checks whether the specified string is valid and well formed XML.(ǷΪЧxml)
		 * (检查是否是有效的xml)
		 * @param data The string that is being checked to see if it is valid XML.
		 * 
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function isValidXML(data:String):Boolean
		{
			var xml:XML;
			
			try
			{
				xml = new XML(data);
			}
			catch(e:Error)
			{
				return false;
			}
			
			if(xml.nodeKind() != XMLUtil.ELEMENT)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Returns the next sibling of the specified node relative to the node's parent.
		 * 
		 * @param x The node whose next sibling will be returned.
		 * 
		 * @return The next sibling of the node. null if the node does not have 
		 * a sibling after it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static function getNextSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, 1);
		}
		
		/**
		 * Returns the sibling before the specified node relative to the node's parent.
		 * 
		 * @param x The node whose sibling before it will be returned.
		 * 
		 * @return The sibling before the node. null if the node does not have 
		 * a sibling before it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */			
		public static function getPreviousSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, -1);
		}		
		
		protected static function getSiblingByIndex(x:XML, count:int):XML	
		{
			var out:XML;
			
			try
			{
				out = x.parent().children()[x.childIndex() + count];	
			} 		
			catch(e:Error)
			{
				return null;
			}
			
			return out;			
		}
		
		/**
		 * 创建XML文档(XMLDocument 类表示 ActionScript 2.0 中存在的旧 XML 对象)
		 * @param	str
		 * @return
		 */
		public static function createXMLDocument(str:String):XMLDocument
		{
			var xml:XMLDocument = new XMLDocument();
			xml.ignoreWhite = true;
			xml.parseXML(str);
			return xml;
		}
		
		public static function createFrom(source:*):XML
		{
			if (source is Class)
				source = new source();
			
			if (source is ByteArray)
			{
				try
				{
					(source as ByteArray).uncompress();
				}
				catch (e:Error)
				{}
				source = source.toString();
			}
			
			if (source is String)
			{
				while (source.substr(0,1) != "<") //去掉额外的文件首字符
					source = source.substr(1);
				return new XML(source);
			}
			else
				trace("不支持的类型");
			return null;
		}
		
		public static function attributesToObject(xml:XML,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			
			for each (var xml:XML in xml.attributes())
				result[xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function objectToAttributes(obj:Object,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for (var key:String in obj)
				result["@"+key] = obj[key];
			
			return result;
		}
		
		public static function childrenToAttributes(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.children())
				result["@" + xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function attributesToChildren(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.attributes())
			{
				var child:XML = <xml/>
				child.setName(xml.name());
				child.appendChild(xml.toString());
				result.appendChild(child);
			}
			return result;
		}
    
    
	}
}