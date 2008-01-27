package com.wefootball.events {
	import com.wefootball.model.Team;
	import flash.events.Event;
	
	public class TeamDetailEvent extends Event {		
		public var team:Team = new Team
		
		public function TeamDetailEvent(
						type:String,
						id:String = "") {
			super(type, true);
			this.team.id = id;
		}
	} 
}