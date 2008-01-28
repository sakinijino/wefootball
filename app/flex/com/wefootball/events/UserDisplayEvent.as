package com.wefootball.events {
	import flash.events.Event;
	
	public class UserDisplayEvent extends Event {
		public var user_id:String;
		
		public function UserDisplayEvent(type:String, user_id:String) {
			super(type, true);
			this.user_id = user_id;
		}
	}
}