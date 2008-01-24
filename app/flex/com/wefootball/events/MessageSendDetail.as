package com.wefootball.events {
	import flash.events.Event;
	
	public class MessageSendDetailEvent extends Event {
		public static const MESSAGE_SEND_DETAIL:String ="messageSendDetail";
		
		public function MessageSendDetailEvent() {
			super(MESSAGE_SEND_DETAIL, true);
		}
	}
}