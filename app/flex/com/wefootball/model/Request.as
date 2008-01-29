package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	import com.wefootball.validators.ServerErrors;		
	
	[Bindable]
	public class Request
	{
		public var id:int;
		public var applier_id:int;
		public var applier_name:String;
		public var host_id:int;
		public var message:String;		
		public var apply_date:Date;

		static private var requestListHasLoaded:Boolean = false;		
		static public var requestList:ArrayCollection = new ArrayCollection();
		
		static private const REQUEST_PARSER:Function = parseRequestFromXML;
		static private const REQUEST_LIST_PARSER:Function = parseRequestListFromXML;					
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE_REQUEST:Object = {url:"/pre_friend_relations.xml"
													 ,method:"POST"};
		static private const REJECT_REQUEST:Object = {url:"/pre_friend_relations.xml"
													 ,method:"POST"};													 													 
		static private const LIST_REQUEST:Object = {url:"/pre_friend_relations.xml"
													 ,method:"GET"};												 													
				
		public function Request()
		{
			super();
		}		
		
		static public function createRequest(host_id:String,
											 message:String,
											 success:Function,
											 error:Function, 
											 fault:Function):void
		{
			Request.proxy.send({
				url:CREATE_REQUEST.url,
				method:CREATE_REQUEST.method,
				request:{'pre_friend_relation[host_id]':host_id,
						 'pre_friend_relation[message]':message
						},
				success:function(event:ResultEvent):void{
					var xml:XML = XML(event.result);
					if (xml.name().localName == "errors")
					{
						error(new ServerErrors(xml), event)
					}
					else 
					{					
						success(event); 
					}						
				},
				fault:fault
			});
					
		}
		
		static public function listRequests(success:Function,
												  fault:Function):void
		{
     		if(requestListHasLoaded == true)
     			success((new ResultEvent(ResultEvent.RESULT)),requestList);
     		else
     		{
				Request.proxy.send({
					url:LIST_REQUEST.url,
					method:LIST_REQUEST.method,				
					success:function(event:ResultEvent):void{
						requestListHasLoaded = true;
						REQUEST_LIST_PARSER(event.result,requestList);
						success(event,requestList);
					},				
					fault:fault
				});
     		}
		}
		
		static public function rejectRequest(request_id:String,
											success:Function,
											fault:Function):void
		{
			Request.proxy.send({
				url:("/pre_friend_relations/"+request_id+".xml"),
				method:REJECT_REQUEST.method,
				request:{'_method':"DELETE"},				
				success:function(event:ResultEvent):void{
					for (var i:int=0; i< requestList.length; ++i)
					{
						if (requestList.getItemAt(i).id == request_id)
							requestList.removeItemAt(i);
					}
					success(event);								
				},
				fault:fault
			});
					
		}		
		
		static public function countRequests():int
		{
			return requestList.length; 	
		}
		
		static private function parseRequestFromXML(eventXML:XML, q:Request):void
		{
			q.id = eventXML.id;
			q.applier_id = eventXML.applier_id;
			q.applier_name = eventXML.applier_name;
			q.host_id = eventXML.host_id;
			q.message = eventXML.message;
			q.apply_date = new Date(eventXML.apply_date.toString());
		}
		
		static private function parseRequestListFromXML(eventXML:XML, requestList:ArrayCollection):void
		{
			for(var i:int = 0;i < eventXML['pre_friend_relation'].length();i++)
			{
				var q:Request = new Request();
				parseRequestFromXML(eventXML['pre_friend_relation'][i],q);
				requestList.addItem(q);
			}		
		}							
	}
}