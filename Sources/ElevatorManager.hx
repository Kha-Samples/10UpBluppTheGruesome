package;

import kha.math.Random;
import kha.math.Vector2;
import kha.Scheduler;
import kha2d.Sprite;

class ElevatorManager
{
	public static var the(default, null): ElevatorManager;
	
	public var levels(get_levels, null) : Int;
	public function get_levels() : Int {
		return sprites.length;
	}
	
	private var idle : Bool = true;
	private var sprites : Array<Elevator> = new Array<Elevator>();
	private var currentPosition : Int = -1;
	private var idleTaskId : Int = -1;
	
	public function new() { }
	
	public static function init(instance: ElevatorManager) {
		the = instance;
	}
	
	@:access(Empty.interactiveSprites)
	public function setPositions(positions : Array<Vector2>) : Array<Elevator>
	{
		positions.sort(function(pos1 : Vector2, pos2 : Vector2) { return Std.int(pos1.y - pos2.y); } );
		sprites = new Array<Elevator>();
		for (i in 0...positions.length) {
			var elevator = new Elevator(positions[i].x, positions[i].y, i);
			sprites.push(elevator);
			Empty.the.interactiveSprites.push(elevator);
		}
		currentPosition = Random.getUpTo(positions.length - 1);
		sprites[currentPosition].open = true;
		
		return sprites;
	}
	
	private var queue : Array<Int> = new Array<Int>();
	public function callTo(toPosition : Int) {
		if (idle) {
			moveTo(toPosition);
		}
		else {
			if (queue.indexOf(toPosition) < 0) queue.push(toPosition);
		}
	}
	
	private function moveTo(toPosition : Int) {
		sprites[currentPosition].open = false;
		Scheduler.addTimeTask(arrive.bind(null, toPosition, null), Math.abs(currentPosition - toPosition) * 3 + 1);
	}
	
	public function getLevel(sprite: Sprite): Int {
		var i = sprites.length - 1;
		while (i >= 0) {
			var elevator = sprites[i];
			if (sprite.y > elevator.y + elevator.height) {
				return i + 1;
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
		idle = false;
		
		Scheduler.removeTimeTask(idleTaskId);
		Scheduler.addTimeTask(arrive.bind(sprite, toPosition, callback), Math.abs(atPosition - toPosition) * 3 + 1);
		return true;
	}
	
	private function arrive(spriteInside : Sprite, atPosition : Int, callback : Void -> Void) {
		if (spriteInside != null) {
			spriteInside.visible = true;
			spriteInside.collides = true;
			spriteInside.x = sprites[atPosition].x;
			spriteInside.y = sprites[atPosition].y;
		}
		currentPosition = atPosition;
		sprites[atPosition].open = true;
		idle = true;
		
		if (callback != null) callback();
		idleTaskId = Scheduler.addTimeTask(onIdle, 1);
	}
	
	private function onIdle() {
		if (queue.length > 0) {
			moveTo(queue[0]);
			queue.remove(queue[0]);
		}
	}
}