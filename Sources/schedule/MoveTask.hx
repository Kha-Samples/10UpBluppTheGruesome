package schedule;

import kha2d.Sprite;
import sprites.RandomGuy;

class MoveTask extends Task {
	private var target: Sprite;
	private var targetLevel: Int;
	private var step: Int;
	private var inElevator: Bool;
	private static inline var speed: Float = 2;
	private var waitOnOpen: Int;
	
	public function new(guy: RandomGuy, target: Sprite) {
		super(guy);
		this.target = target;
		step = 0;
		waitOnOpen = 0;
		inElevator = false;
	}
	
	override public function update(): Void {
		switch (step) {
			case 0:
				targetLevel = ElevatorManager.the.getLevel(target.y);
				if (targetLevel == ElevatorManager.the.getLevel(guy.y)) {
					step += 2;
				}
				else {
					var elevatorX = ElevatorManager.the.getX(ElevatorManager.the.getLevel(guy.y));
					if (guy.x + guy.width / 2 < elevatorX - 10) {
						guy.speedx = speed;
					}
					else if (guy.x + guy.width / 2 > elevatorX + 10) {
						guy.speedx = -speed;
					}
					else {
						guy.speedx = 0;
						++step;
					}
				}
			case 1:
				if (!inElevator) {
					if (ElevatorManager.the.doorIsOpen(ElevatorManager.the.getLevel(guy.y))) {
						if (waitOnOpen > 0) {
							--waitOnOpen;
						}
						else {
							inElevator = ElevatorManager.the.getIn(guy, ElevatorManager.the.getLevel(guy.y), ElevatorManager.the.getLevel(target.y), function () {
								++step;
								inElevator = false;
							});
						}
					}
					else {
						ElevatorManager.the.callTo(ElevatorManager.the.getLevel(guy.y));
						waitOnOpen = 60;
					}
				}
			case 2:
				targetLevel = ElevatorManager.the.getLevel(target.y);
				if (targetLevel != ElevatorManager.the.getLevel(guy.y)) {
					step -= 2;
				}
				else {
					if (guy.x + guy.width / 2 < target.x + target.width / 2 - 10) {
						guy.speedx = speed;
					}
					else if (guy.x + guy.width / 2 > target.x + target.width / 2 + 10) {
						guy.speedx = -speed;
					}
					else {
						guy.speedx = 0;
						done = true;
					}
				}
		}
	}
}
