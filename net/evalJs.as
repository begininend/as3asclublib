package {

	//用于air中执行js
  import flash.html.HTMLLoader;
  import flash.events.HTMLUncaughtScriptExceptionEvent;
  import flash.events.Event;
  public function evalJs(
    jsCode:String,
    env:* = null,
    resultHandler:Function = null,
    errorHandler:Function = null
  ):void {
    var htmlLoader:HTMLLoader = new HTMLLoader()
    htmlLoader.window.env = env;
    htmlLoader.window.jsCode = jsCode;
    htmlLoader.loadString(
      '\
        <html>\
          <head>\
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>\
          </head>\
          <body>\
            <script>\
              if(env) {\
                with(env) {\
                    window.result = eval(jsCode);\
                }\
              } else {\
                window.result = eval(jsCode);\
              }\
            </script>\
          </body>\
        </html>\
      '
    );
    if(resultHandler != null) {
      htmlLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
        resultHandler(htmlLoader.window.result);
      });
    }
    if(errorHandler != null) {
      htmlLoader.addEventListener(
        HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION,
        function(event:HTMLUncaughtScriptExceptionEvent):void {
          errorHandler(event.exceptionValue, event.stackTrace);
        }
      );
    }
  }
}