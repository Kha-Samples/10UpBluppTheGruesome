package sprites;

import kha.Loader;
import kha.Rectangle;
import kha2d.Animation;
import kha2d.Direction;
import localization.Keys_text;
import sprites.IdSystem.IdCard;
import sprites.IdSystem.IdCardOwner;

class Agent extends Player implements IdCardOwner {
	public var IdCard(default, null): IdCard;
	
	public function new(x: Float, y: Float) {
		super(1, x, y, "agent", Std.int(410 / 10) * 2, Std.int(455 / 7) * 2, 0);
		standing = false;
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(31);
		jumpRight = Animation.create(30);
		setAnimation(jumpRight);
		collider = new Rectangle(20, 30, 41 * 2 - 40, (65 - 1) * 2 - 30);
		
		IdCard = new IdCard(Keys_text.AGENT);
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
