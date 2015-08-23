package;

import kha.math.Random;
import kha.math.Vector2;
import kha.Scheduler;
import kha2d.Sprite;

class ElevatorManager
{
	private var sprites : Array<Elevator> = new Array<Elevator>();

	public static var the(default, null): ElevatorManager;
	
	public function new() { }
	
	public static function init(instance: ElevatorManager) {
		the = instance;
	}
	
	public function setPositions(positions : Array<Vector2>) : Array<Elevator>
	{
		sprites = new Array<Elevator>();
		for (i in 0...positions.length) {
			sprites.push(new Elevator(positions[i].x, positions[i].y));
		}
		sprites[Random.getUpTo(positions.length - 1)].open = true;
		
		return sprites;
	}
	
	public function getLevel(sprite: Sprite): Int {
		var i = sprites.length - 1;
		while (i >= 0) {
			var elevator = sprites[i];
			if (sprite.y > elevator.y + elevator.height) {
				return i - 1;
			}
			--i;
		}
		return 0;
	}
	
	public function getX(level: Int): Float {
		return sprites[level].x + sprites[level].width / 2;
	}
	
	public function getIn(sprite : Sprite, atPosition : Int, toPosition : Int, callback : Void -> Void) : Bool {
		if (!sprites[atPosition].open) return false;
		
		sprite.visible = false;
		sprite.collides = false;
		sprites[atPosition].open = false;
		Scheduler.addTimeTask(getOut.bind(sprite, toPosition, callback), Math.abs(atPosition - toPosition) * 3 + 1);
		return true;
	}
	
	private function getOut(sprite : Sprite, atPosition : Int, callback : Void -> Void) {
		sprite.visible = true;
		sprite.collides = true;
		sprites[atPosition].open = true;
		callback();
	}
}