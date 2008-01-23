package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
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
		static private const CREATE:Object = {url:"/users.xml",method:"POST"};
		static private const LOGIN:Object = {url:"/sessions.xml",method:"POST"};
		static private const UPDATE:Object = {method:"POST"};
		static private const PARSER:Function = parseFromXML;
				
		public function User()
		{
			super();
		}
		
 		static public function logon(login:String,password:String,success:Function,fault:Function):void
		{
			User.proxy.send({
				url:LOGIN.url,
				method:LOGIN.method,
				request:{'login':login,'password':password},
				success: function(event:ResultEvent):void{
					PARSER(event,User.currentUser);
					User.users[User.currentUser.id] = User.currentUser
					success(event);
				},
				fault:fault
			});		
		} 		
		
		static public function create(login:String,password:String,confirmPassword:String, 
											 success:Function,fault:Function):void
		{
			User.proxy.send({
				url:CREATE.url,
				method:CREATE.method,
				request:{'user[login]':login,'user[password]':password,'user[password_confirmation]':confirmPassword},
				success:success,
				fault:fault
			});
					
		}
		
		static public function update(u:Object,success:Function,fault:Function):void
		{				
 			User.proxy.send({
 				url:("/users/"+u.id+".xml"),
				method:UPDATE.method, 
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
						if (result.name().localName != "errors") {
							PARSER(event, User.users[u.id]);
						}
						success(event);
					},
					fault:fault
				}); 		
		}						

		static private function parseFromXML(event:ResultEvent, u:User):void
		{
			u.id = event.result.id;
			u.login = event.result.login;
			u.nickname = event.result.nickname;
			u.height = event.result.height;
			u.weight = event.result.weight;
			u.fitfoot = event.result.fitfoot;
			u.birthday = new Date(event.result.birthday.toString());
			u.summary = event.result.summary;
			for(var i: int = 0; i < event.result..position.length(); i++)
			{
				u.positions.addItem(event.result..position[i].toString());
			}
		}
	}
}