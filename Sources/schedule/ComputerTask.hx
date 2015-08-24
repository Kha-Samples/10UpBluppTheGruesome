package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Direction;
import kha2d.Sprite;
import sprites.Computer;

class ComputerTask extends Task {
	private var taskScheduled: Bool;
	private var computer: Computer;
	
	public function new(sprite: Sprite, computer: Computer) {
		super(sprite);
		this.computer = computer;
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			computer.useFrom(sprite);
			Scheduler.addTimeTask(function() {
				if (Random.getIn(0, 5) != 0) {
					computer.stopUsing(true);
				}
				done = true;
			}, Random.getIn(5, 15));
		}
	}
	
	override public function doImmediately(): Void {
		computer.useFrom(sprite);
		if (Random.getIn(0, 5) != 0) {
			computer.stopUsing(true);
		} else {
			computer.stopUsing(false);
		}
	}
}
