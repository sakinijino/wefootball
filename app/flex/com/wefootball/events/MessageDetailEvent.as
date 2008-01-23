package com.wefootball.events {
	import flash.events.Event;
	
	public class MessageDetailEvent extends Event {
		public static const MESSAGE_DETAIL:String ="messageDetail";
		
		public function MessageDetailEvent() {
			super(MESSAGE_DETAIL, true);
		}
	}
}