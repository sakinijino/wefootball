package com.wefootball.events {
	import flash.events.Event;
	
	public class UserDisplayEvent extends Event {
		public static const USERDISPLAY:String = "userDisplay";
		public var user_id:String;
		
		public function UserDisplayEvent(user_id:String) {
			super(USERDISPLAY, true);
			this.user_id = user_id;
		}
	}
}