package com.wefootball.events {
	import flash.events.Event;
	
	public class RegisterEvent extends Event {
		public static const ACCOUNT_CREATE:String ="register";
		public var login:String;
		
		public function RegisterEvent(login:String) {
			super(ACCOUNT_CREATE, true);
			this.login = login;
		}
	}
}