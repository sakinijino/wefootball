package com.wefootball.events {
	import flash.events.Event;
	
	public class MessageEvent extends Event {
		public static const MESSAGE:String = "sendMessageComplete";
		public var message:XML;
		
		public function MessageEvent(message:XML) {
			super(MESSAGE, true);
			this.message = message;
		}
	}
}