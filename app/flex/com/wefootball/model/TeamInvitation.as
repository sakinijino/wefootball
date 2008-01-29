package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import com.wefootball.validators.ServerErrors;
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;		
	
	[Bindable]
	public class TeamInvitation
	{
		public var id:int;
		public var team_id:String;
		public var host_id:String;
		public var message:String;		
		public var apply_date:Date;
		public var is_invitation:Boolean;
		public var team_shortname:String;
		

		static private var invitationListHasLoaded:Boolean = false;		
		static public var invitationList:ArrayCollection = new ArrayCollection();
		
		static private const INVITATION_PARSER:Function = parseInvitationFromXML;
		static private const INVITATION_LIST_PARSER:Function = parseInvitationListFromXML;					
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE_INVITATION:Object = {url:"/team_join_invitations.xml"
													 ,method:"POST"};
		static private const REJECT_INVITATION:Object = {url:"/team_join_invitations.xml"
													 ,method:"POST"};													 													 
		static private const LIST_INVITATION:Object = {method:"GET"};												 													
				
		public function TeamInvitation()
		{
			super();
		}		

		static public function createInvitation(team_id:String,host_id:String,message:String,
												success:Function,error:Function,fault:Function):void{
			TeamInvitation.proxy.send({
				url:CREATE_INVITATION.url,
				method:CREATE_INVITATION.method,
				request:{'team_join_request[team_id]':team_id,
						 'team_join_request[user_id]':host_id,
						 'team_join_request[message]':message
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
		
		static public function listTeamInvitations(success:Function,fault:Function):void
		{
			TeamInvitation.proxy.send({
				url:("/users/"+User.currentUser.id+"/team_join_invitations.xml"),
				method:LIST_INVITATION.method,				
				success:function(event:ResultEvent):void{
					INVITATION_LIST_PARSER(event.result,invitationList);
					success(event,invitationList);
				},				
				fault:fault
			});
		}
		
		static public function rejectTeamInvitation(team_invitation_id:String,success:Function,fault:Function):void
		{
			TeamInvitation.proxy.send({
				url:("/team_join_invitations/"+team_invitation_id+".xml"),
				method:REJECT_INVITATION.method,
				request:{'_method':"DELETE"},				
				success:function(event:ResultEvent):void{
					for (var i:int=0; i< invitationList.length; ++i)
					{
						if (invitationList.getItemAt(i).id == team_invitation_id)
							invitationList.removeItemAt(i);
					}
					success(event);								
				},
				fault:fault
			});
					
		}	
		
		static private function parseInvitationFromXML(eventXML:XML, ti:TeamInvitation):void
		{
			ti.id = eventXML.id;
			ti.message = eventXML.message;
			ti.apply_date = new Date(eventXML.apply_date.toString());
			ti.team_id = eventXML.team.id;
			ti.team_shortname = eventXML.team.shortname
			ti.host_id = eventXML.host_id;
			ti.is_invitation = true;
		}
		
		static private function parseInvitationListFromXML(eventXML:XML, invitationList:ArrayCollection):void
		{
			for(var i:int = 0;i < eventXML['request'].length();i++)
			{
				var ti:TeamInvitation = new TeamInvitation();
				parseInvitationFromXML(eventXML['request'][i],ti);
				invitationList.addItem(ti);
			}		
		}							
	}
}