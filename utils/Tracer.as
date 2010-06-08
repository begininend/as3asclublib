/** 
* ... 
* @author Kinglong 
* @version 1.2 
*/  
  
package org.asclub.utils {  
      
    import flash.events.EventDispatcher;  
    import flash.events.StatusEvent;  
    import flash.net.LocalConnection;  
    import flash.utils.*;  
      
    import org.asclub.events.TracerEvent;  
      
    public class Tracer extends EventDispatcher{      
        private static var _tracer:Tracer;  
        private var _conn:LocalConnection;  
        private var _console:Boolean;  
        private var _name:String = "debugConnection";         
          
        public function Tracer(console:Boolean=true){  
            _conn = new LocalConnection();  
            _conn.allowDomain('*');  
            _console = console;  
            if(isConsole()){  
                _conn.client = this;  
                try {  
                    _conn.connect(_name);  
                } catch (error:ArgumentError) {  
                    output("连接错误:调试连接已经被打开!");  
                }  
            }else{  
                _conn.addEventListener(StatusEvent.STATUS, statusHandler);  
            }  
        }  
          
        public function isConsole():Boolean{  
            return _console;  
        }  
          
        private function statusHandler(event:StatusEvent):void{  
            if (event.level == "error") {                  
                trace("发送失败:可能调试控制台没有打开");                  
            }  
        }  
          
        private function output(msg:String):void{  
            dispatchEvent(new TracerEvent(TracerEvent.DATA,msg+"\n"));  
        }  
          
        private function send(object:*):void{  
            if(isConsole()){  
                return;  
            }  
            var msg:String = "";  
            if(object == null){  
                msg = "null";  
            }else if(object == undefined){  
                msg = "undefined";  
            }else if(object is String || object is Number || object is int || object is uint || object is Boolean){  
                msg = object.toString();  
            }else if(object is Array || object is Date){  
                msg = "["+getQualifiedClassName(object)+"] "+object.toString();  
            }else if(getQualifiedClassName(object) == "Object"){  
                msg = "[Object] {";  
                var count:uint = 0;  
                for(var key:String in object){  
                    var value:* = object[key];  
                    if(count++ > 0){  
                        msg += ",";  
                    }  
                    msg += key+":";  
                    if(value == null){  
                        msg += "null";  
                    }else if(value == undefined){  
                        msg += "undefined";  
                    }else if(value is String){  
                        msg += "\""+value+"\"";  
                    }else{  
                        msg += value.toString();  
                    }  
                }  
                msg += "}";  
            }else if(typeof object == "function"){  
                msg = "[Function]";  
            }else{  
                msg = "["+getQualifiedClassName(object)+"]";  
            }  
            _conn.send(_name,"receive",msg);  
        }  
          
        public function receive(msg:String):void{  
            if(isConsole()){  
                output(msg);  
            }  
        }  
          
        public static function debug(object:*):void{  
            if(_tracer== null){  
                _tracer = new Tracer(false);  
            }  
            _tracer.send(object);  
        }  
    }  
      
}  
