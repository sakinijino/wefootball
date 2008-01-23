package com.wefootball.proxies
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;
	
	public class HTTPProxy extends Proxy
	{
		public function HTTPProxy()
		{
			super();
		}
		override public	function send(parameters:Object):void
		{
			var service:HTTPService = new HTTPService;
			service.url = parameters.url;
			service.headers['Accept']='application/xml';
			service.resultFormat= parameters.resultFormat==null?"e4x":parameters.resultFormat;
			service.method= parameters.method;
			service.request = parameters.request;			
			service.addEventListener(ResultEvent.RESULT,parameters.success);
			service.addEventListener(FaultEvent.FAULT,parameters.fault);
			service.send();			
		}
	}
}