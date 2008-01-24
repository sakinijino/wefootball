package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import mx.rpc.events.ResultEvent;
	
	public class Message
	{
		public var sender_id:int
		public var senderNick:String
		public var receiver_id:int
		public var receiverNick:String
		public var subject:String
		public var content:String
		public var is_delete_by_sender:Boolean
		public var is_delete_by_receiver:Boolean
		public var is_receiver_read:Boolean
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/messages.xml",method:"POST"};
		static private const DESTORY:Object = {method:"POST"};
		static private const LIST:Object = {url:"/messages.xml",method:"POST"};
		static private const REVEIVER_READ:Object = {method:"POST"};
		static private const DETAIL:Object = {method:"POST"};
		
		static public var currentMessage:Message = new Message();
		
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
						'message[content]':content,
						'message[is_delete_by_sender]':"false",
						'message[is_delete_by_receiver]':"false",
						'message[is_receiver_read]':"false"},
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
		
		static public function detail(dataID:int,success:Function,fault:Function):void{
			
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:DETAIL.method,
				success:success,
				fault:fault
			});
		}
		
		static public function destory(dataID:int,success:Function,fault:Function):void{
			
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:DESTORY.method,
				request:{'_method':"DELETE"},
				success:success,
				fault:fault
			});
		}
		
		static public function receiverRead(dataID:int,success:Function,fault:Function):void{
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:REVEIVER_READ.method,
				request:{					
					'_method':"PUT",
					'message[is_receiver_read]':"true"},
				success:success,
				fault:fault
			});
		}
	}
}