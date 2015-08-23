package schedule;

import kha2d.Sprite;

class MoveTask extends Task {
	private var target: Sprite;
	private var targetLevel: Int;
	private var step: Int;
	private var buttonPushed: Bool;
	private var inElevator: Bool;
	private static inline var speed: Float = 2;
	
	public function new(sprite: Sprite, target: Sprite) {
		super(sprite);
		this.target = target;
		step = 0;
		buttonPushed = false;
		inElevator = false;
	}
	
	override public function update(): Void {
		switch (step) {
			case 0:
				targetLevel = ElevatorManager.the.getLevel(target.y);
				if (targetLevel == ElevatorManager.the.getLevel(sprite.y)) {
					step += 2;
				}
				else {
					var elevatorX = ElevatorManager.the.getX(ElevatorManager.the.getLevel(sprite.y));
					if (sprite.x + sprite.width / 2 < elevatorX - 10) {
						sprite.speedx = speed;
					}
					else if (sprite.x + sprite.width / 2 > elevatorX + 10) {
						sprite.speedx = -speed;
					}
					else {
						sprite.speedx = 0;
						++step;
					}
				}
			case 1:
				if (!inElevator) {
					if (!buttonPushed) {
						buttonPushed = true;
						ElevatorManager.the.callTo(ElevatorManager.the.getLevel(sprite.y));
					}
					inElevator = ElevatorManager.the.getIn(sprite, ElevatorManager.the.getLevel(sprite.y), ElevatorManager.the.getLevel(target.y), function () {
						++step;
						inElevator = false;
						buttonPushed = false;
					});
				}
			case 2:
				targetLevel = ElevatorManager.the.getLevel(target.y);
				if (targetLevel != ElevatorManager.the.getLevel(sprite.y)) {
					step -= 2;
				}
				else {
					if (sprite.x + sprite.width / 2 < target.x + target.width / 2 - 10) {
						sprite.speedx = speed;
					}
					else if (sprite.x + sprite.width / 2 > target.x + target.width / 2 + 10) {
						sprite.speedx = -speed;
					}
					else {
						sprite.speedx = 0;
						done = true;
					}
				}
		}
	}
}
