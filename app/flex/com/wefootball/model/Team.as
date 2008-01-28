package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	[Bindable]
	public class Team
	{
		public var id:String;
		public var name:String;
		public var shortname:String
		public var summary:String
		public var found_time:Date
		public var style:String
		
		static public var currentTeam:Team = new Team();
		static public var teamList:ArrayCollection = new ArrayCollection();
		static public var teamInviteList:ArrayCollection = new ArrayCollection();
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/teams.xml",method:"POST"};
		static private const LIST:Object = {method:"POST"};
		static private const DETAIL:Object = {method:"POST"};
		static private const UPDATE:Function = function(id:String):Object {
			return {url:"/teams/"+id+".xml",method:"POST"};
		}
		
		static public const TEAM_PARSER:Function = parseTeamFromXML;
		static public const TEAM_LIST_PARSER:Function=parseTeamListFromXML;
		
		public function Team() {
			super();
		}
		
 		static public function create(team:Team,success:Function, fault:Function):void{
			Team.proxy.send({
				url:CREATE.url,
				method:CREATE.method,
				request:{'team[name]':team.name,
						'team[shortname]':team.shortname,
						'team[summary]':team.summary,
						'team[found_time]':team.found_time,
						'team[style]':team.style},
 				success:function(event:ResultEvent):void{
 					var xml:XML = XML(event.result);
					var t:Team = new Team;
					TEAM_PARSER(event.result, t);
					teamList.addItem(t); 
					success(event);
				}, 
				//success:success,
				fault:fault
			});
		} 
		
		static public function update(t:Object,success:Function,fault:Function):void
		{				
 			var req:Object = UPDATE(t.id);
			Team.proxy.send({
				url:req.url,
				method:req.method,
				request:{
					'_method':"PUT",
					'team[name]':t.name,
					'team[shortname]':t.shortname,
					'team[summary]':t.summary,
					'team[found_time]':t.found_time,
					'team[style]':t.style},
					success:function(event:ResultEvent):void {
						var newT:Team = null;
						var i:int = 0;
						for (i=0; i< teamList.length; ++i)
							if (teamList.getItemAt(i).id == t.id) 
							{
								newT = teamList.getItemAt(i);
							}
						if (newT == null) newT = new Team();
						TEAM_PARSER(event.result, newT);
						//TEAM_PARSER(event.result, currentTeam);
						success(newT, event);
					},
					fault:fault
				}); 		
		}	
		
 		static public function list(success:Function,fault:Function):void{
			Team.proxy.send({
				url:("/users/"+User.currentUser.id+"/teams.xml"),
				method:LIST.method,
				success:function(event:ResultEvent):void{
					TEAM_LIST_PARSER(event,teamList);
					success(event, teamList);
				},				
				fault:fault
			});
		} 
		
 		static public function show(id:String, 
			success:Function, 
			fault:Function):void{
			
			//if sender destoried
			Team.proxy.send({
				url:("/teams/"+id+".xml"),
				method:DETAIL.method,
				success: function(event:ResultEvent):void{
					var t:Team = null;
					var i:int = 0;
					for (i=0; i< teamList.length; ++i)
						if (teamList.getItemAt(i).id == id) 
						{
							t = teamList.getItemAt(i);
						}
					if (t == null) t = new Team();
					TEAM_PARSER(event.result, t);
					//TEAM_PARSER(event.result, currentTeam);
					success(t, event);
				},
				fault:fault
			});
		} 
		
		static private function parseTeamFromXML(eventXML:XML, t:Team):void
		{
			t.id = eventXML.id;
			t.name = eventXML.name;
			t.shortname = eventXML.shortname;
			t.summary = eventXML.summary;
			t.found_time = new Date(eventXML.found_time.toString());
			t.style = eventXML.style;
		}
		
 		static private function parseTeamListFromXML(event:ResultEvent, tml:ArrayCollection):void
		{
			for(var i:int = 0;i < event.result['team'].length();i++)
			{
				var t:Team = new Team();
				parseTeamFromXML(event.result['team'][i],t);
				tml.addItem(t);
			}			
		} 
	}
}