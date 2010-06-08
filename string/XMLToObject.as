 package org.asclub.string  
 {  
	public class XMLToObject  
	{  
   
		public function XMLToObject()  
		{  
		}  
	   
		 static public function to(dp:XML,ignoreNamespace:Boolean=false):Object  
		 {  
			 if(dp)  
			 {  
				 var _obj:Object = {};  
				 dp.ignoreWhitespace = true;  
				 pNode(dp,_obj,ignoreNamespace);  
				 return _obj;  
			 }  
			 return null;  
		 }  
		   
		 static private function pNode(node:XML,obj:Object,ignoreNamespace:Boolean):void  
		 {  
			 //  
			 if(ignoreNamespace) node.setNamespace("");
			 //  
			 var nodeName:String = node.name().toString();  
			 var o:Object = {};  
			 var j:String;  
			 if(node.attributes().length()>0)  
			 {  
				for(j in node.attributes())  
				{  
					o[node.attributes()[j].name().toString()]=node.attributes()[j];  
				}  
				if(node.children().length()<=1&&o["value"]==undefined)  
				{  
					o["value"]=node.toString();  
				}  
			 }  
			 else  
			 {  
				if(node.children().length()<=1&&!node.hasComplexContent())  
				{  
					o=node.toString();  
				}  
			 }  
			 //  
			 if(obj[nodeName] == undefined) obj[nodeName] = o;  
			 else  
			 {  
				if(obj[nodeName] is Array) obj[nodeName].push(o)  
				else obj[nodeName] = [obj[nodeName],o];  
			 }  
			 try{  
				toObj(node,obj[nodeName],ignoreNamespace);  
			 }
			 catch(e:Error){};  
		}  
			   
		static private function toObj(dp:XML,obj:Object,ignoreNamespace:Boolean):void  
		{  
			 var i:int,nl:int;  
			 nl = dp.children().length();  
			 for(i=0;i < nl;i++)
			  {  
				 var node:XML = dp.children()[i];
				 if(obj is Array)  
				 {  
					pNode(node,obj[obj.length-1],ignoreNamespace);  
				 }  
				 else
				 {
					pNode(node,obj,ignoreNamespace);  
				 //  
				 }  
			 }
		 }  
	   
	 }//end of class
 }  