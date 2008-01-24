package com.wefootball.events {
	import flash.events.Event;
	
	public class MessageDisplayEvent extends Event {
		public static const MESSAGEDISPLAY:String ="messageDisplay";
		public var message_id:String;
		
		public function MessageDisplayEvent(message_id:String) {
			super(MESSAGEDISPLAY, true);
			this.message_id = message_id;
		}
	}
}