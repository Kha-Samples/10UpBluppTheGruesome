package;

import kha.math.Random;
import kha.math.Vector2;
import kha.Scheduler;
import kha2d.Scene;
import kha2d.Sprite;
import sprites.ElevatorIndicator;

class ElevatorManager
{
	public static var the(default, null): ElevatorManager;
	
	public var levels(get_levels, null) : Int;
	public function get_levels() : Int {
		return sprites.length;
	}
	
	private var idle : Bool = true;
	private var sprites : Array<Elevator> = new Array<Elevator>();
	private var indicators : Array<ElevatorIndicator> = new Array<ElevatorIndicator>();
	private var currentPosition(default, set_currentPosition) : Int = -1;
	private var idleTaskId : Int = -1;
	
	private function set_currentPosition(value : Int) : Int {
		currentPosition = value;
		
		for (indicator in indicators) {
			indicator.setLevel(currentPosition);
		}
		
		return currentPosition;
	}
	
	public function new() { }
	
	public static function init(instance: ElevatorManager) {
		the = instance;
	}
	
	public function setPositions(positions : Array<Vector2>) : Array<Elevator>
	{
		positions.sort(function(pos1 : Vector2, pos2 : Vector2) { return Std.int(pos2.y - pos1.y); } );
		sprites = new Array<Elevator>();
		for (i in 0...positions.length) {
			sprites.push(new Elevator(positions[i].x, positions[i].y, i));
			var indicator : ElevatorIndicator = new ElevatorIndicator(positions[i].x, positions[i].y);
			indicators.push(indicator);
			Scene.the.addOther(indicator);
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
		for (i in 0...sprites.length) {
			var elevator = sprites[i];
			if (sprite.y > elevator.y + elevator.height) {
				return i - 1;
			}
		}
		return sprites.length - 1;
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
		
		// TODO: Movement
		Scheduler.addTimeTask(arrive.bind(sprite, toPosition, callback), Math.abs(atPosition - toPosition) * 3 + 1);
		return true;
	}
	
	private function arrive(spriteInside : Sprite, atPosition : Int, callback : Void -> Void) {
		if (spriteInside != null) {
			spriteInside.visible = true;
			spriteInside.collides = true;
			spriteInside.x = sprites[atPosition].x;
			spriteInside.y = sprites[atPosition].y + sprites[atPosition].collisionRect().height - spriteInside.collisionRect().height;
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