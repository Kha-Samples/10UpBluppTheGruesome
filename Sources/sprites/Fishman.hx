package sprites;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;
import kha.Rectangle;
import kha2d.Animation;
import kha2d.Direction;
import sprites.IdSystem.IdCard;
import sprites.IdSystem.IdCardOwner;

class Fishman extends Player implements IdCardOwner {
	private var attackImage: Image;
	private var attacking: Int;
	public var IdCard(default, null): IdCard;
	
	public function new(x: Float, y: Float) {
		super(0, x, y, 'fishy', Std.int(594 * 2 / 9), Std.int(146 * 2 / 2));
		this.x = x;
		this.y = y;
		speedx = -3;
		walkLeft = Animation.createRange(1, 8, 4);
		walkRight = Animation.createRange(10, 17, 4);
		setAnimation(walkLeft);
		collider = new Rectangle(20, 5, (594 * 2 / 9) - 40, ((146 * 2 / 2) - 1) - 5);
		attackImage = Loader.the.getImage("fishy_attack");
		IdCard = new IdCard(Keys_text.FISCHMENSCH);
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
	
	override public function attack(): Void {
		attacking = 30;
	}
	
	override public function render(g: Graphics): Void {
		if (attacking > 0) {
			if (attacking > 15) {
				if (lookRight) {
					g.drawSubImage(attackImage, x - 66, y - 4, 0, attackImage.height / 2, attackImage.width / 2, attackImage.height / 2);
				}
				else {
					g.drawSubImage(attackImage, x - 66, y - 4, 0, 0, attackImage.width / 2, attackImage.height / 2);
				}
			}
			else {
				if (lookRight) {
					g.drawSubImage(attackImage, x - 66, y - 4, attackImage.width / 2, attackImage.height / 2, attackImage.width / 2, attackImage.height / 2);
				}
				else {
					g.drawSubImage(attackImage, x - 66, y - 4, attackImage.width / 2, 0, attackImage.width / 2, attackImage.height / 2);
				}
			}
			--attacking;
		}
		else {
			super.render(g);
		}
	}
}
