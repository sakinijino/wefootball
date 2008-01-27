package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import com.wefootball.validators.ServerErrors;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
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
		public var created_at:Date;
		public var is_delete_by_sender:Boolean
		public var is_delete_by_receiver:Boolean
		public var is_receiver_read:Boolean
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/messages.xml",method:"POST"};
		static private const DESTORY:Object = {method:"POST"};
		static private const LIST:Object = {url:"/messages.xml",method:"POST"};
		static private const REVEIVER_READ:Object = {method:"POST"};
		static private const DETAIL:Object = {method:"POST"};
		
		static public var sendMessageList:ArrayCollection = new ArrayCollection();
		static public var receiveMessageList:ArrayCollection = new ArrayCollection();
		
		static private const MESSAGE_PARSER:Function = parseMessageFromXML;
		static private const MESSAGE_LIST_PARSER:Function=parseMessageListFromXML
		
		public function Message() {
			super();
		}
		public function canDestroy():Boolean {
			if (User.currentUser.id == this.sender_id) return !this.is_delete_by_sender
			if (User.currentUser.id == this.receiver_id) return !this.is_delete_by_receiver
			return false;
		}
		
		static public function create(receiver_id:String,subject:String,content:String,
									success:Function, errors:Function, fault:Function):void{
			Message.proxy.send({
				url:CREATE.url,
				method:CREATE.method,
				request:{'message[receiver_id]':receiver_id,
						'message[subject]':subject,
						'message[content]':content},
				success:function(event:ResultEvent):void{
					var xml:XML = XML(event.result);
					if (xml.name().localName == "errors") {
						errors(new ServerErrors(xml), event)
					}
					else {
						var m:Message = new Message;
						MESSAGE_PARSER(event.result, m);
						sendMessageList.addItem(m);
						success(m, event);
					}
				},
				fault:fault
			});
		}
		
		static public function list(success:Function,fault:Function):void{
			Message.proxy.send({
				url:LIST.url,
				method:LIST.method,
				success:function(event:ResultEvent):void{
					MESSAGE_LIST_PARSER(event,sendMessageList,receiveMessageList);
					success(event, sendMessageList, receiveMessageList);
				},				
				fault:fault
			});
		}
		
		static public function show(id:String, 
			success:Function, 
			fault:Function):void{
			
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+id+".xml"),
				method:DETAIL.method,
				success: function(event:ResultEvent):void{
					var m:Message = null;
					var i:int = 0;
					for (i=0; i< sendMessageList.length; ++i)
						if (sendMessageList.getItemAt(i).id == id) m = sendMessageList.getItemAt(i);
					for (i=0; i< receiveMessageList.length; ++i)
						if (receiveMessageList.getItemAt(i).id == id) m = receiveMessageList.getItemAt(i);
					if (m == null) m = new Message();
					MESSAGE_PARSER(event.result, m);
					success(m, event);
				},
				fault:fault
			});
		}
		
		static public function destory(data:Message,success:Function,fault:Function):void{
			if (!data.canDestroy()) return;
			//if sender destoried
			Message.proxy.send({
				url:("/messages/"+data.id+".xml"),
				method:DESTORY.method,
				request:{'_method':"DELETE"},
				success: function(event:ResultEvent):void{
	    			var pos:int;  
	    			if(data.sender_id == User.currentUser.id)
	    			{
	    				pos = sendMessageList.getItemIndex(data);
	    				if(pos != -1)
	    					sendMessageList.removeItemAt(pos);
	    			}
	    			else
	    			{
	    				pos = receiveMessageList.getItemIndex(data);
	    				if(pos != -1)    				
	    					receiveMessageList.removeItemAt(pos);    				
	    			}
					success(event);
				},
				fault:fault
			});
		}
		
		static private function parseMessageFromXML(eventXML:XML, m:Message):void
		{
			m.id = eventXML.id;
			m.sender_id = eventXML.sender_id;
			m.sender_nick = eventXML.sender_nick;
			m.receiver_id = eventXML.receiver_id;
			m.receiver_nick = eventXML.receiver_nick;
			m.subject = eventXML.subject;
			m.content = eventXML.content;
			m.created_at = new Date(eventXML.created_at.toString());
			m.is_delete_by_sender = (eventXML.is_delete_by_sender == "true");
			m.is_delete_by_receiver = (eventXML.is_delete_by_receiver == "true");
			m.is_receiver_read = (eventXML.is_receiver_read == "true");
		}
		
		static private function parseMessageListFromXML(event:ResultEvent, sml:ArrayCollection, rml:ArrayCollection):void
		{
			for(var i:int = 0;i < event.result['as_sender']['message'].length();i++)
			{
				var m:Message = new Message();
				parseMessageFromXML(event.result['as_sender']['message'][i],m);
				sml.addItem(m);
			}
			
			for(var j:int = 0;j < event.result['as_receiver']['message'].length();j++)
			{
				var n:Message = new Message();
				parseMessageFromXML(event.result['as_receiver']['message'][j],n);
				rml.addItem(n);
			}			
		}
	}
}