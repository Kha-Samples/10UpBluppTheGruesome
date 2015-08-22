package sprites;

import kha.Loader;
import kha.Rectangle;
import kha2d.Animation;
import kha2d.Direction;

class Agent extends Player {
	
	public function new(x: Float, y: Float) {
		super(1, x, y, "agent", 16 * 4, 16 * 4, 0);
		standing = false;
		walkLeft = new Animation([2, 3, 4, 3], 6);
		walkRight = new Animation([7, 8, 9, 8], 6);
		standLeft = Animation.create(5);
		standRight = Animation.create(6);
		jumpLeft = Animation.create(1);
		jumpRight = Animation.create(10);
		setAnimation(jumpRight);
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
