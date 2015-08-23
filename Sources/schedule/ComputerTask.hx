package schedule;

import kha2d.Direction;
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
			computer.useFrom(Direction.LEFT, sprite);
			Scheduler.addTimeTask(function() { computer.stopUsing(); done = true; }, time);
		}
	}
}
