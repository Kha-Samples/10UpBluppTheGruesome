package schedule;

import kha.math.Random;
import kha2d.Sprite;
import sprites.IdSystem;
import sprites.RandomGuy;

class MoveTask extends Task {
	private var target: Sprite;
	private var targetLevel: Int;
	private var step: Int;
	private var inElevator: Bool;
	private var waitOnOpen: Int;
	private var offset: Int;
	private var hurry: Bool;
	
	public function new(guy: RandomGuy, target: Sprite, hurry: Bool = false, randomoffset: Int = 0) {
		super(guy);
		this.target = target;
		this.hurry = hurry;
		offset = 0;
		if (randomoffset > 0) {
			var value = Random.getIn(Std.int(randomoffset / 2), randomoffset);
			if (Random.getIn(0, 1) == 0) value = -value;
			offset = value;
		}
		step = 0;
		waitOnOpen = 0;
		inElevator = false;
	}
	
	private function speed(): Float {
		return hurry ? 4 : 2;
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
						guy.speedx = speed();
					}
					else if (guy.x + guy.width / 2 > elevatorX + 10) {
						guy.speedx = -speed();
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
						waitOnOpen = 30;
					}
				}
			case 2:
				targetLevel = ElevatorManager.the.getLevel(target.y);
				if (targetLevel != ElevatorManager.the.getLevel(guy.y)) {
					step -= 2;
				}
				else {
					if (guy.x + guy.width / 2 < target.x + target.width / 2 - 10 + offset) {
						guy.speedx = speed();
					}
					else if (guy.x + guy.width / 2 > target.x + target.width / 2 + 10 + offset) {
						guy.speedx = -speed();
					}
					else {
						guy.speedx = 0;
						done = true;
						if (offset != 0) {
							if (target.x + target.width / 2 < guy.x + guy.width / 2) {
								guy.lookLeft = true;
							}
							else {
								guy.lookLeft = false;
							}
						}
					}
				}
		}
	}
	
	override public function getDescription(): String {
		var to: String;
		var floor: String = Std.string(ElevatorManager.the.getLevel(target.y));
		if (Std.is(target, IdCardOwner))
		{
			to = (cast target : IdCardOwner).IdCard.Name;
		}
		else if (Std.is(target, IdLoggerSprite))
		{
			to = (cast target : IdLoggerSprite).idLogger.txtKey;
		}
		else
		{
			to = Keys_text.TASK_SOMETHING;
		}
		return Localization.getText(Keys_text.TASK_MOVE, [to, floor]);
	}
}
