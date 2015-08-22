package schedule;

import kha.Scheduler;
import kha2d.Sprite;

class WaitTask {
	public function new(sprite: Sprite, time: Float) {
		Scheduler.addTimeTask(function() { done = true; }, time);
	}
}
