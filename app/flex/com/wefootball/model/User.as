package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import com.wefootball.validators.ServerErrors;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;	
	
	[Bindable]
	public class User
	{
		public var id:String;
		public var login:String;
		public var nickname:String;
		public var img:String = "/images/defaultUserPic.jpg";
		public var height:Number;
		public var weight:Number;
		public var fitfoot:String;
		public var birthday:Date;
		public var summary:String;
		public var ismyfriend:Boolean = false;
		public var positions:ArrayCollection = new ArrayCollection;
		
		static public var currentUser:User = new User();
		static private var friendListHasLoaded:Boolean = false;
		static public var currentUserFriendList:ArrayCollection = new ArrayCollection;
		static public var users:Object = {};
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const SHOW:Function = function(id:String):Object {
			return {url:"/users/"+id+".xml", method:"GET"}
		};
		static private const CREATE:Function = function():Object {
			return {url:"/users.xml",method:"POST"};
		}
		static private const LOGIN:Function = function():Object {
			return {url:"/sessions.xml",method:"POST"};
		}
		static private const UPDATE:Function = function(id:String):Object {
			return {url:"/users/"+id+".xml",method:"POST"};
		}
		static private const CREATE_FRIEND:Object = {url:"/friend_relations.xml"
													 ,method:"POST"};
		static private const REJECT_FRIEND:Object = {url:"/friend_relations.xml"
													 ,method:"POST"};
		static private const LIST_FRIEND:Object = {url:"/friend_relations.xml"
													 ,method:"GET"};													 		
		
		static private const USER_PARSER:Function = parseUserFromXML;
		static private const FRIEND_PARSER:Function = parseFriendFromXML;
		static private const FRIEND_LIST_PARSER:Function = parseFriendListFromXML;				
				
		public function User()
		{
			super();
		}
		
 		static public function logon(login:String,password:String,success:Function,fault:Function):void
		{
			var req:Object = LOGIN();
			User.proxy.send({
				url:req.url,
				method:req.method,
				request:{'login':login,'password':password},
				success: function(event:ResultEvent):void{
					USER_PARSER(XML(event.result),User.currentUser);
					User.users[User.currentUser.id] = User.currentUser
					success(event);
				},
				fault:fault
			});		
		} 		
		
		static public function show(id:String,success:Function,fault:Function):void
		{
			var req:Object = SHOW(id);
			User.proxy.send({
				url:req.url,
				method:req.method,
				success: function(event:ResultEvent):void{
					var u:User = new User;
					USER_PARSER(XML(event.result), u);
					success(u, event);
				},
				fault:fault
			});		
		} 		
		
		
		static public function create(u:Object, success:Function,fault:Function):void
		{
			var req:Object = CREATE();
			User.proxy.send({
				url:req.url,
				method:req.method,
				request:{
					'user[login]':u['login'],
					'user[password]':u['password'], 
					'user[password_confirmation]':u['confirmPassword']
				},
				success:function(event:ResultEvent):void {
					var result:XML = XML(event.result);
					if (result.name().localName == "errors") {
						u['createerrors'](new ServerErrors(result), event)
					}
					else {
						success(event);
					}
				},
				fault:fault
			});			
		}
		
		static public function update(u:Object,success:Function,fault:Function):void
		{				
 			var req:Object = UPDATE(u.id);
			User.proxy.send({
				url:req.url,
				method:req.method,
				request:{
					'_method':"PUT",
					'user[nickname]':u.nickname,
					'user[height]':u.height,
					'user[weight]':u.weight,
					'user[birthday]':u.birthday,
					'user[fitfoot]':u.fitfoot,
					'positions[]':u.positions,
					'user[summary]':u.summary},
					success:function(event:ResultEvent):void {
						var result:XML = XML(event.result);
						if (result.name().localName == "errors") {
							u['updateerrors'](new ServerErrors(result), event)
						}
						else {
							USER_PARSER(XML(event.result), User.users[u.id]);
							success(User.users[u.id], event);
						}
					},
					fault:fault
				}); 		
		}
		
		public function createFriend(request_id:String,
									success:Function,
									fault:Function):void
		{
			User.proxy.send({
				url:CREATE_FRIEND.url,
				method:CREATE_FRIEND.method,
				request:{'request_id':request_id},
				success:function(event:ResultEvent):void{
					for (var i:int=0; i< Request.requestList.length; ++i)
					{
						if (Request.requestList.getItemAt(i).id == request_id)
							Request.requestList.removeItemAt(i);
					}
					if(friendListHasLoaded == true)
					{
						var f:User = new User;
						FRIEND_PARSER(event.result,f);
						currentUserFriendList.addItem(f);
					}
					success(event);					
				},	
				fault:fault
			});
					
		}
		
		static public function listFriends( user_id:String,
											success:Function,
											fault:Function):void
		{
     		if((user_id == currentUser.id) && (friendListHasLoaded == true))
     			success((new ResultEvent(ResultEvent.RESULT)),currentUserFriendList);
     		else
     		{		
				User.proxy.send({
					url:LIST_FRIEND.url,
					method:LIST_FRIEND.method,				
					request:{'user_id':user_id},				
					success:function(event:ResultEvent):void{
						var fl:ArrayCollection = new ArrayCollection;
						FRIEND_LIST_PARSER(event.result,fl);
						if(user_id == currentUser.id)
						{
							friendListHasLoaded = true;
							currentUserFriendList = fl;
						}											
						success(event,fl);
					},	
					fault:fault})
			};
		}					
							
		static private function parseUserFromXML(eventXML:XML, u:User):void
		{
			u.id = eventXML.id;
			u.login = eventXML.login;
			u.nickname = eventXML.nickname;
			if (eventXML.height.@nil!='true') u.height = eventXML.height;
			else u.height = 0
			if (eventXML.weight.@nil!='true') u.weight = eventXML.weight;
			else u.weight = 0
			if (eventXML.fitfoot.@nil!='true') u.fitfoot = eventXML.fitfoot.toString();
			else u.fitfoot = null
			if (eventXML.birthday.@nil!='true') u.birthday = new Date(eventXML.birthday.toString());
			else u.birthday = null
			u.summary = eventXML.summary;
			u.ismyfriend = (eventXML.is_my_friend.toString() == 'true');
			u.positions.removeAll()
			for(var i: int = 0; i < eventXML..position.length(); i++)
				u.positions.addItem(eventXML..position[i].toString());
		}
		static private function parseFriendFromXML(eventXML:XML,u:User):void
		{
 			u.id = eventXML.id;
			u.nickname = eventXML.nickname;
		}
		static private function parseFriendListFromXML(eventXML:XML, fl:ArrayCollection):void
		{ 
 			for(var i:int = 0;i < eventXML['friend'].length();i++)
			{
				var u:User = new User();
				parseFriendFromXML(eventXML['friend'][i],u);
				fl.addItem(u);
			} 
		}				
	}
}