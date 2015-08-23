package schedule;

import kha.Scheduler;
import kha2d.Sprite;

class WaitTask extends Task {
	public function new(sprite: Sprite, time: Float) {
		super(sprite);
		Scheduler.addTimeTask(function() { done = true; }, time);
	}
}
