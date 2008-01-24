package com.wefootball.events {
	import flash.events.Event;
	
	public class AccountCreateEvent extends Event {
		public static const ACCOUNT_CREATE:String ="accountCreate";
		public var login:String;
		
		public function AccountCreateEvent(login:String) {
			super(ACCOUNT_CREATE, true);
			this.login = login;
		}
	}
}