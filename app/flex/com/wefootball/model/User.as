package com.wefootball.model
{
	import com.wefootball.events.*;
	import com.wefootball.proxies.*;
	import mx.rpc.events.ResultEvent;
	
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
		public var position:Array;		
		
		static public var currentUser:User;		
		
		static private var proxy:Proxy = new HTTPProxy;
		static private const CREATE:Object = {url:"/users.xml",method:"POST"};
		static private const LOGIN:Object = {url:"/sessions.xml",method:"POST"};
		static private const UPDATE:Object = {method:"POST"};
		static private const PARSER:Function = parseFromXML;
				
		public function User()
		{
			super();
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
		
		static public function update(nickname:String,
									height:String,
									weight:String, 
									//birthday:Date,
									fitfoot:String,
									position:Array,
									summary:String,
									success:Function,
									fault:Function):void
		{	
 			User.proxy.send({
 				url:("/users/"+currentUser.id+".xml"),
				method:UPDATE.method, 
				request:{
					'user[nickname]':nickname,
					'user[height]':height,
					'user[weight]':weight,
					//'user[birthday]':birthday,
					'user[fitfoot]':fitfoot,
					'position[]':position,
					'user[summary]':summary},
				success:success,
				fault:fault
			}); 		
		}		
		
 		static public function login(login:String,password:String,success:Function,fault:Function):void
		{
			User.proxy.send({
				url:LOGIN.url,
				method:LOGIN.method,
				request:{'login':login,'password':password},
				success:function(event:ResultEvent):void {PARSER(event); success(event);},
				fault:fault
			});		
		} 

		static private function parseFromXML(event:ResultEvent):void
		{
			currentUser = new User();
			currentUser.id = event.result.id;
			currentUser.login = event.result.login;
			currentUser.nickname = event.result.nickname;
			currentUser.height = event.result.height;
			currentUser.weight = event.result.weight;
			currentUser.fitfoot = event.result.fitfoot;
			//currentUser.birthday = event.result.birthday;
			currentUser.summary = event.result.summary;
			for(var i: int = 0; i < event.result.position.length(); i++)
			{
				currentUser.position.push(event.result.position[i]);
			}
		}
	}
}