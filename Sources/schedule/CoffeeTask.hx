package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Direction;
import sprites.Coffee;
import sprites.RandomGuy;

class CoffeeTask extends Task {
	private var taskScheduled: Bool;
	var coffee: Coffee;
	
	public function new(guy: RandomGuy, coffee: Coffee) {
		super(guy);
		this.coffee = coffee;
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			Scheduler.addTimeTask(function() { done = true; }, Random.getIn(5, 15));
		}
	}
	
	override public function getDescription(): String {
		return Localization.getText(Keys_text.TASK_COFFEE, [Std.string(ElevatorManager.the.getLevel(coffee.y))]);
	}
}
