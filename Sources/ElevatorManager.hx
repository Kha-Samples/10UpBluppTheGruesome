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