package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	
	[Bindable]
	public class Message
	{
		public var id:String;
		public var sender_id:String
		public var sender_nick:String
		public var receiver_id:String
		public var receiver_nick:String
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
		static private const PARSER:Function = parseFromXML;
		
		public function Message()
			{
			super();
		}
		
		static public function create(receiver_id:String,subject:String,content:String,
									success:Function,fault:Function):void{
			Message.proxy.send({
				url:CREATE.url,
				method:CREATE.method,
				request:{'message[receiver_id]':receiver_id,
						'message[subject]':subject,
						'message[content]':content},
				success:function(event:ResultEvent):void{
					var m:Message = new Message;
					PARSER(event, m);
					success(m, event);
				},
				fault:fault
			});
		}
		
		static public function list(success:Function,fault:Function):void{
			Message.proxy.send({
				url:LIST.url,
				method:LIST.method,
				success:function(event:ResultEvent):void{
					success(event);
				},
				fault:fault
			});
		}
		
		static public function show(dataID:String, 
			success:Function, 
			fault:Function):void{
			
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:DETAIL.method,
				success: function(event:ResultEvent):void{
					var m:Message = new Message;
					PARSER(event, m);
					success(m, event);
				},
				fault:fault
			});
		}
		
		static public function destory(dataID:String,success:Function,fault:Function):void{
			
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+dataID+".xml"),
				method:DESTORY.method,
				request:{'_method':"DELETE"},
				success:success,
				fault:fault
			});
		}
		
		static private function parseFromXML(event:ResultEvent, m:Message):void
		{
			m.id = event.result.id;
			m.sender_id = event.result.sender_id;
			m.sender_nick = event.result.sender_nick;
			m.receiver_id = event.result.receiver_id;
			m.receiver_nick = event.result.receiver_nick;
			m.subject = event.result.subject;
			m.content = event.result.content;
			m.is_delete_by_sender = event.result.is_delete_by_sender;
			m.is_delete_by_receiver = event.result.is_delete_by_receiver;
			m.is_receiver_read = event.result.is_receiver_read;
		}
	}
}