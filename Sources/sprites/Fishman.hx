package sprites;

import kha.Assets;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Image;
import kha.math.FastMatrix3;
import kha2d.Rectangle;
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
		standLeft = Animation.create(0);
		standRight = Animation.create(9);
		jumpLeft = Animation.create(8);
		jumpRight = Animation.create(17);
		setAnimation(walkLeft);
		collider = new Rectangle(20, 25, (594 * 2 / 9) - 40, ((146 * 2 / 2) - 1) - 25);
		attackImage = Assets.images.fishy_attack;
		IdCard = RandomGuy.monsterId();
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
		attacking = 9;
	}
	
	override public function render(g: Graphics): Void {
		if (attacking > 0) {
			if (attacking > 6 || attacking < 3) {
				if (lookRight) {
					g.drawSubImage(attackImage, x - 66, y - 24, 0, attackImage.height / 2, attackImage.width / 2, attackImage.height / 2);
				}
				else {
					g.drawSubImage(attackImage, x - 66, y - 24, 0, 0, attackImage.width / 2, attackImage.height / 2);
				}
			}
			else {
				if (lookRight) {
					g.drawSubImage(attackImage, x - 36, y - 24, attackImage.width / 2, attackImage.height / 2, attackImage.width / 2, attackImage.height / 2);
				}
				else {
					g.drawSubImage(attackImage, x - 66, y - 24, attackImage.width / 2, 0, attackImage.width / 2, attackImage.height / 2);
				}
			}
			--attacking;
		}
		else {
			if (image != null && visible) {
			g.color = Color.fromFloats(1, 1, 1);
			g.opacity = Math.max(0, Empty.the.fancyMonsterAnimation);
			if (angle != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(x + originX, y + originY)).multmat(FastMatrix3.rotation(angle)).multmat(FastMatrix3.translation(-x - originX, -y - originY)));
			g.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h, Math.round(x - collider.x * scaleX), Math.round(y - collider.y * scaleY), width, height);
			if (angle != 0) g.popTransformation();
			g.opacity = 1;
		}
		}
	}
}
