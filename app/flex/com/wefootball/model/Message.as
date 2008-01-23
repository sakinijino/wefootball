package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	
	public class Message
	{
		public var sender_id:int
		public var senderNick:String
		public var receiver_id:int
		public var receiverNick:String
		public var subject:String
		public var content:String
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/messages.xml",method:"POST"};
		//static private const DETAIL:Object = {url:"/messages.xml",method:"POST"};
		static private const DESTORY:Object = {method:"POST"};
		static private const LIST:Object = {url:"/messages.xml",method:"POST"};
		
		public function Message()
			{
			super();
		}
		
		static public function create(sender_id:String,receiver_id:String,subject:String,content:String,
									success:Function,fault:Function):void{
			Message.proxy.send({
				url:CREATE.url,
				method:CREATE.method,
				request:{'message[sender_id]':sender_id,
						'message[receiver_id]':receiver_id,
						'message[subject]':subject,
						'message[content]':content},
				success:success,
				fault:fault
			});
		}
		
		static public function list(success:Function,fault:Function):void{
			Message.proxy.send({
				url:LIST.url,
				method:LIST.method,
				success:success,
				fault:fault
			});
		}
		
		static public function destory(dataID:int,success:Function,fault:Function):void{
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:DESTORY.method,
				request:{'_method':"DELETE"},
				success:success,
				fault:fault
			});
		}
	}
}