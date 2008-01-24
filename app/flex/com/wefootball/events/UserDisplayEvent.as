package com.wefootball.events {
	import flash.events.Event;
	
	public class UserDisplayEvent extends Event {
		public static const USER_DISPLAY:String = "userDisplay";
		public var user_id:int;
		
		public function UserDisplayEvent(user_id:int) {
			super(USER_DISPLAY, true);
			this.user_id = user_id;
		}
	}
}