package schedule;

import kha.Scheduler;
import kha2d.Sprite;

class WaitTask extends Task {
	private var taskScheduled: Bool;
	
	public function new(sprite: Sprite, time: Float) {
		super(sprite);
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			Scheduler.addTimeTask(function() { done = true; }, 5);
		}
	}
}
