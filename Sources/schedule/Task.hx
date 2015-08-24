package schedule;

import sprites.RandomGuy;

class Task {
	private var guy: RandomGuy;
	private var done: Bool;
	
	public function new(guy: RandomGuy) {
		this.guy = guy;
		done = false;
	}
	
	public function update(): Void {
		
	}
	
	public function isDone(): Bool {
		return done;
	}
	
	public function doImmediately(): Void {
		
	}
}
