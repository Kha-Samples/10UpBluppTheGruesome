package sprites;

import kha.Loader;
import kha.Rectangle;
import kha2d.Animation;
import kha2d.Direction;

class Fishman extends Player {
	
	public function new(x: Float, y: Float) {
		super(0, x, y, 'fishy', Std.int(594 * 2 / 9), Std.int(146 * 2 / 2));
		this.x = x;
		this.y = y;
		speedx = -3;
		walkLeft = Animation.createRange(1, 8, 4);
		walkRight = Animation.createRange(10, 17, 4);
		setAnimation(walkLeft);
		collider = new Rectangle(16, 32, 32, 32);
	}
	
	override public function hitFrom(dir: Direction): Void {
		super.hitFrom(dir);
		if (dir == Direction.RIGHT) {
			speedx = 3;
			setAnimation(walkRight);
		}
		else if (dir == Direction.LEFT) {
			speedx = -3;
			setAnimation(walkLeft);
		}
	}
}
