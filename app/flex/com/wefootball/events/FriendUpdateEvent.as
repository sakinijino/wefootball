package com.wefootball.events
{
	import flash.events.Event;
	
	public class FriendUpdateEvent extends Event
	{
		public static const FRIEND_UPDATE:String ="friendUpdate";		
		public function FriendUpdateEvent()
		{
			super(FRIEND_UPDATE,true);
		}
	}
}