package;

import kha.math.Random;
import kha.math.Vector2;
import kha.Scheduler;
import kha2d.Scene;
import kha2d.Sprite;
import sprites.ElevatorIndicator;

enum ElevatorState {
	Idle;
	WaitingForEnter;
	MovingTo;
}

class ElevatorManager
{
	public static var the(default, null): ElevatorManager;
	
	public var levels(get_levels, null) : Int;
	public function get_levels() : Int {
		return elevators.length;
	}
	
	private var state : ElevatorState = ElevatorState.Idle;
	private var waitingTaskId : Int = -1;
	private var elevators : Array<Elevator> = new Array<Elevator>();
	private var indicators : Array<ElevatorIndicator> = new Array<ElevatorIndicator>();
	
	private var targetY : Float;
	private var currentY : Float;
	
	private var currentLoad : Sprite;
	private var currentCallback : Void->Void;
	private var currentPosition(default, set_currentPosition) : Int;
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
	
	public function initSprites(positions : Array<Vector2>) : Array<Elevator>
	{
		positions.sort(function(pos1 : Vector2, pos2 : Vector2) { return Std.int(pos2.y - pos1.y); } );
		elevators = new Array<Elevator>();
		for (i in 0...positions.length) {
			var elevator : Elevator = new Elevator(positions[i].x, positions[i].y, i);
			elevators.push(elevator);
			Scene.the.addOther(elevator);
			Empty.the.interactiveSprites.push(elevator);
			
			var indicator : ElevatorIndicator = new ElevatorIndicator(positions[i].x, positions[i].y);
			indicators.push(indicator);
			Scene.the.addOther(indicator);
		}
		
		currentPosition = 4; // Random.getUpTo(positions.length - 1);
		targetY = currentY = elevators[currentPosition].y;
		elevators[currentPosition].open = true;
		
		return elevators;
	}
	
	private var queue : Array<Int> = new Array<Int>();
	public function callTo(toPosition : Int) {
		if (targetY == elevators[toPosition].y) return;
		
		if (state == Idle) {
			if (toPosition == currentPosition) {
				wait();
			}
			else  {
				moveTo(toPosition, null, null);
			}
		}
		else {
			if (queue.indexOf(toPosition) < 0) queue.push(toPosition);
		}
	}
	
	private function moveTo(toPosition : Int, load : Sprite, callback : Void -> Void) {
		Scheduler.removeTimeTask(waitingTaskId);
		
		elevators[currentPosition].open = false;
		
		currentLoad = load;
		currentCallback = callback;
		targetY = elevators[toPosition].y;
		
		state = MovingTo;
	}
	
	public function getIn(sprite : Sprite, atPosition : Int, toPosition : Int, callback : Void -> Void) : Bool {
		if (!elevators[atPosition].open) return false;
		
		sprite.visible = false;
		sprite.collides = false;
		elevators[atPosition].open = false;
		
		moveTo(toPosition, sprite, callback);
		return true;
	}
	
	private function arrive(spriteInside : Sprite, atPosition : Int, callback : Void -> Void) {
		if (spriteInside != null) {
			updateLoadPosition();
			spriteInside.visible = true;
			spriteInside.collides = true;
		}
		
		elevators[atPosition].open = true;
		
		if (queue.indexOf(atPosition) >= 0) {
			wait();
		}
		else {
			onIdle();
		}
		
		if (callback != null) callback();
	}
	
	private function wait() {
		state = WaitingForEnter;
		waitingTaskId = Scheduler.addTimeTask(onIdle, 1);
	}
	
	private function onIdle() {
		if (queue.length > 0) {
			moveTo(queue[0], null, null);
			queue.remove(queue[0]);
		}
		else {
			state = Idle;
		}
	}
	
	public function update(deltaTime : Float) {
		switch (state) {
			case Idle:
			case WaitingForEnter:
			case MovingTo:
				var difference : Float = targetY - currentY;
				var distance : Float = Math.abs(difference);
				if (distance < 1) { 
					arrive(currentLoad, currentPosition, currentCallback);
				}
				else {
					currentY += Math.min(250 * deltaTime, distance) * difference / distance;
					updateLoadPosition();
					updateCurrentPosition();
				}
		}
	}
	
	private function updateCurrentPosition() {
		currentPosition = getLevel(currentY);
		for (indicator in indicators) {
			indicator.setLevel(currentPosition);
		}
	}
	
	private function updateLoadPosition() {
		if (currentLoad != null) {
			currentLoad.x = elevators[currentPosition].x;
			currentLoad.y = currentY + elevators[currentPosition].collisionRect().height - currentLoad.collisionRect().height;
		}
	}
	
	public function getLevel(y : Float): Int {
		for (i in 0...elevators.length) {
			var elevator = elevators[i];
			if (y > elevator.y + elevator.height) {
				return i - 1;
			}
		}
		return elevators.length - 1;
	}
	
	public function getX(level: Int): Float {
		return elevators[level].x + elevators[level].width / 2;
	}
}