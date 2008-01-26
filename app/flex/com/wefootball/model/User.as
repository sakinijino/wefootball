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
		public var height:Number;
		public var weight:Number;
		public var fitfoot:String;
		public var birthday:Date;
		public var summary:String;
		public var positions:ArrayCollection = new ArrayCollection;
		
		static public var currentUser:User = new User();
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
		static private const PARSER:Function = parseFromXML;
				
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
					PARSER(event,User.currentUser);
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
					PARSER(event, u);
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
							PARSER(event, User.users[u.id]);
							success(User.users[u.id], event);
						}
					},
					fault:fault
				}); 		
		}						

		static private function parseFromXML(event:ResultEvent, u:User):void
		{
			u.id = event.result.id;
			u.login = event.result.login;
			u.nickname = event.result.nickname;
			if (event.result.height.@nil!='true') u.height = event.result.height;
			else u.height = 0
			if (event.result.weight.@nil!='true') u.weight = event.result.weight;
			else u.weight = 0
			if (event.result.fitfoot.@nil!='true') u.fitfoot = event.result.fitfoot.toString();
			else u.fitfoot = null
			if (event.result.birthday.@nil!='true') u.birthday = new Date(event.result.birthday.toString());
			else u.birthday = null
			u.summary = event.result.summary;
			u.positions.removeAll()
			for(var i: int = 0; i < event.result..position.length(); i++)
				u.positions.addItem(event.result..position[i].toString());
		}
	}
}