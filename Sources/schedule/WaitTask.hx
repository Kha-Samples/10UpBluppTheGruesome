package schedule;

import kha.math.Random;
import kha.Scheduler;
import sprites.RandomGuy;

class WaitTask extends Task {
	private var taskScheduled: Bool;
	
	public function new(guy: RandomGuy) {
		super(guy);
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			Scheduler.addTimeTask(function() { done = true; }, Random.getIn(1, 5));
		}
	}
}
