package com.wefootball.events
{
	import flash.events.Event;
	
	public class TeamJoinUpdateEvent extends Event
	{
		public static const TEAM_JOIN_UPDATE:String ="TeamJoinUpdate";		
		public function TeamJoinUpdateEvent()
		{
			super(TEAM_JOIN_UPDATE,true);
		}
	}
}