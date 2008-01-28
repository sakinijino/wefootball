package com.wefootball.events {
	import flash.events.Event;
	
	public class UserEvent extends Event {
		public var user_id:String;
		
		public function UserEvent(type:String, user_id:String) {
			super(type, true);
			this.user_id = user_id;
		}
	}
}