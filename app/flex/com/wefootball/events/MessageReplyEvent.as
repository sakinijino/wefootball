package com.wefootball.events {
	import flash.events.Event;
	
	public class MessageReplyEvent extends Event {
		public static const MESSAGE_REPLY:String ="messageReply";
		
		public function MessageReplyEvent() {
			super(MESSAGE_REPLY, true);
		}
	}
}