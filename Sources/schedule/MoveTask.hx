package schedule;

import kha2d.Sprite;

class MoveTask extends Task {
	private var target: Sprite;
	private var targetLevel: Int;
	private var elevatorX: Float;
	private var step: Int;
	private static inline var speed: Float = 2;
	
	public function new(sprite: Sprite, target: Sprite) {
		super(sprite);
		this.target = target;
		step = 0;
	}
	
	private static function getLevel(sprite: Sprite): Int {
		return Std.int(sprite.y / 10);
	}
	
	override public function update(): Void {
		switch (step) {
			case 0:
				targetLevel = getLevel(target);
				if (targetLevel == getLevel(sprite)) {
					step += 2;
				}
				else {
					if (sprite.x < elevatorX - 10) {
						sprite.speedx = speed;
					}
					else if (sprite.x > elevatorX + 10) {
						sprite.speedx = -speed;
					}
					else {
						sprite.speedx = 0;
						++step;
					}
				}
			case 1:
				// use elevator
				++step;
			case 2:
				if (sprite.x < target.x - 10) {
					sprite.speedx = speed;
				}
				else if (sprite.x > target.x + 10) {
					sprite.speedx = -speed;
				}
				else {
					sprite.speedx = 0;
					done = true;
				}
		}
	}
}
