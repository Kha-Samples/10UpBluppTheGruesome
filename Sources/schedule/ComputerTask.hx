package schedule;

import kha.math.Random;
import kha.Scheduler;
import kha2d.Direction;
import sprites.Computer;
import sprites.RandomGuy;

class ComputerTask extends Task {
	private var taskScheduled: Bool;
	private var computer: Computer;
	
	public function new(guy: RandomGuy, computer: Computer) {
		super(guy);
		this.computer = computer;
		taskScheduled = false;
	}
	
	override public function update(): Void {
		if (!taskScheduled) {
			taskScheduled = true;
			computer.useFrom(guy);
			Scheduler.addTimeTask(function() {
				if (Random.getIn(0, 5) != 0) {
					computer.stopUsing(true);
				}
				done = true;
			}, Random.getIn(5, 15));
		}
	}
	
	override public function doImmediately(): Void {
		computer.useFrom(guy);
		if (Random.getIn(0, 5) != 0) {
			computer.stopUsing(true);
		} else {
			computer.stopUsing(false);
		}
	}
	
	override public function getDescription(): String {
		return Localization.getText(Keys_text.TASK_COMPUTER, [Std.string(ElevatorManager.the.getLevel(computer.y))]);
	}
}
