package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Direction;
import sprites.Coffee;
import sprites.RandomGuy;

class CoffeeTask extends Task {
	private var taskScheduled: Bool;
	
	public function new(sprite: RandomGuy, coffee: Coffee) {
		super(guy);
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			Scheduler.addTimeTask(function() { done = true; }, Random.getIn(5, 15));
		}
	}
}
