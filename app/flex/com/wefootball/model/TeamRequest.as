package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import com.wefootball.validators.ServerErrors;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;		
	
	[Bindable]
	public class TeamRequest
	{
		public var id:int;
		public var team_id:String;
		public var host_id:String;
		public var message:String;		
		public var apply_date:Date;
		public var is_invitation:Boolean;

		static private var requestListHasLoaded:Boolean = false;		
		static public var requestList:ArrayCollection = new ArrayCollection();
		
		static private const REQUEST_PARSER:Function = parseRequestFromXML;
		static private const REQUEST_LIST_PARSER:Function = parseRequestListFromXML;					
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE_REQUEST:Object = {url:"/team_join_requests.xml"
													 ,method:"POST"};
		static private const REJECT_REQUEST:Object = {url:"/team_join_requests.xml"
													 ,method:"POST"};													 													 
		static private const LIST_REQUEST:Object = {url:"/team_join_requests.xml"
													 ,method:"GET"};												 													
				
		public function TeamRequest()
		{
			super();
		}		

		static public function createRequest(team_id:String,host_id:String,message:String,
												success:Function,error:Function,fault:Function):void{
			Team.proxy.send({
				url:("/teams/"+host_id+"/teams/admin.xml"),
				method:LIST.method,
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