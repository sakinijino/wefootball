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
		import mx.controls.Alert;
		
		static public var currentTeam:Team = new Team();
		static private var teamInvitationListHasLoaded:Boolean = false;
		static private var teamListHasLoaded:Boolean = false;		
		static public var teamList:ArrayCollection = new ArrayCollection();
		static public var teamInviteList:ArrayCollection = new ArrayCollection();
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/teams.xml",method:"POST"};
		static private const LIST:Object = {method:"POST"};
		static private const DETAIL:Object = {method:"POST"};
		static private const UPDATE:Function = function(id:String):Object {
			return {url:"/teams/"+id+".xml",method:"POST"};
		}
		static private const SEARCH:Object = {url:"/teams/search.xml",method:"GET"};
		static private const ADD_MEMBER:Object = {url:"/team_joins.xml",method:"POST"};
		
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
					TEAM_PARSER(XML(event.result), t);
					teamList.addItem(t); 
					success(event);
				}, 
				//success:success,
				fault:fault
			});
		} 
		
		static public function createMember(team_invitation_id:String,success:Function,fault:Function):void
		{
			Team.proxy.send({
				url:ADD_MEMBER.url,
				method:ADD_MEMBER.method,
				request:{'id':team_invitation_id},
				success:function(event:ResultEvent):void
				{
					for (var i:int=0; i< TeamInvitation.invitationList.length; ++i)
					{
						if (TeamInvitation.invitationList.getItemAt(i).id == team_invitation_id)
							TeamInvitation.invitationList.removeItemAt(i);
					}
					if(teamListHasLoaded == true)
					{
						var t:Team = new Team;
						TEAM_PARSER(XML(event.result),t);
						teamList.addItem(t);
					}
					success(event);					
				},	
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
						TEAM_PARSER(XML(event.result), newT);
						success(newT, event);
					},
					fault:fault
				}); 		
		}	
		
 		static public function list(uid:String,success:Function,fault:Function):void{
 			
 			if((uid==User.currentUser.id) && (teamListHasLoaded == true))
     			success((new ResultEvent(ResultEvent.RESULT)),teamList);
     		else
     		{
				Team.proxy.send({
					url:("/users/"+uid+"/teams.xml"),
					method:LIST.method,
					success:function(event:ResultEvent):void{
						var tl:ArrayCollection = new ArrayCollection;
						TEAM_LIST_PARSER(event.result,tl);
						if(uid == User.currentUser.id)
						{
							teamList = tl;
							teamListHasLoaded = true;
							success(event, teamList);
						}						
						success(event, tl);
					},				
					fault:fault
				});
     		}
		} 
		
 		static public function show(id:String, 
			success:Function, 
			fault:Function):void{
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
					TEAM_PARSER(XML(event.result), t);
					success(t, event);
				},
				fault:fault
			});
		}
		
		static public function getManagedTeams(user_id:String,success:Function,fault:Function):void{
			Team.proxy.send({
				url:("/users/"+user_id+"/teams/admin.xml"),
				method:LIST.method,
				success: function(event:ResultEvent):void{
					var tl:ArrayCollection = new ArrayCollection;
					TEAM_LIST_PARSER(XML(event.result), tl);
					success(event,tl);
				},
				fault:fault
			});			
		} 		
		
		static public function search( query:String,
										success:Function,
										fault:Function):void
		{	
			Team.proxy.send({
				url:SEARCH.url,
				method:SEARCH.method,				
				request:{'query':query},				
				success:function(event:ResultEvent):void{
					var ul:ArrayCollection = new ArrayCollection;
					TEAM_LIST_PARSER(XML(event.result),ul);
					success(event,ul);
				},	
				fault:fault})
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
		
 		static private function parseTeamListFromXML(eventXML:XML, tml:ArrayCollection):void
		{
			for(var i:int = 0;i < eventXML['team'].length();i++)
			{
				var t:Team = new Team();
				parseTeamFromXML(eventXML['team'][i],t);
				tml.addItem(t);
			}			
		} 
	}
}
