package sprites;

import kha.Assets;
import kha2d.Animation;
import kha2d.Sprite;

class ElevatorIndicator extends Sprite
{
	var floorAnimations : Array<Animation>;
	
	public function new(x : Float, y : Float) {
		super(Assets.images.floorlevel, 32, 32, 0);
		this.x = x + 96 - 32 / 2;
		this.y = y - 32;
		floorAnimations = new Array<Animation>();
		for (i in 0...10) {
			floorAnimations.push(Animation.create(i));
		}
		accy = 0;
		collides = false;
	}
	
	public function setLevel(level : Int) {
		setAnimation(floorAnimations[level]);
	}
}