package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Direction;
import kha2d.Sprite;
import sprites.Coffee;

class CoffeeTask extends Task {
	private var taskScheduled: Bool;
	
	public function new(sprite: Sprite, coffee: Coffee) {
		super(sprite);
		this.sprite = sprite;
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			Scheduler.addTimeTask(function() { done = true; }, Random.getIn(5, 15));
		}
	}
}
