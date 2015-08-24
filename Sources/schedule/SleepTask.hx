package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Sprite;
import sprites.RandomGuy;

class SleepTask extends Task {
	private var taskScheduled: Bool;
	
	public function new(guy: RandomGuy) {
		super(guy);
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			guy.sleeping = true;
			Scheduler.addTimeTask(function() { guy.sleeping = false; done = true; }, Random.getIn(15, 30));
		}
	}
	
	override public function getDescription(): String {
		return Localization.getText(Keys_text.TASK_SLEEP);
	}
}
