package;

import kha.math.Vector2;
import kha2d.Animation;
import kha.audio1.Audio;
import kha2d.Direction;
import kha.Loader;
import kha.Rectangle;
import kha.Sound;
import kha2d.Sprite;

class Elevator extends Sprite {
	public var left : Bool;
	public var right : Bool;
	public var up : Bool;
	public var down : Bool;
	var lookRight : Bool;
	var standing : Bool;
	var killed : Bool;
	var jumpcount : Int;
	var lastupcount : Int;
	var walkLeft : Animation;
	var walkRight : Animation;
	var standLeft : Animation;
	var standRight : Animation;
	var jumpLeft : Animation;
	var jumpRight : Animation;
	
	public var canMove : Bool = true;
	var firstFloor : Bool = true;
	var lastFloor : Bool = false;
	var playerIsIn : Bool = false;
	
	//IN ORDER FOR THE ELEVATOR TO WORK, THE FLOOR COORDINATE DIFFERENCES HAVE TO BE A MULTIPLE OF THE SPEED (f.e. if speed is 5, coordinates must end in 0 or 5)
	var elevatorx : Int = 250;
	var floor1 : Int = 512;
	var floor2 : Int = 462;
	var floor3 : Int = 412;
	var floor4 : Int = 362;
	var elevatorSpeed : Float = 5.0;
	
	public function new() {
		super(Loader.the.getImage("nullachtsechzehnmann"), 16 * 4, 16 * 4, 0);
		x = elevatorx;
		y = floor1;
		standing = false;
		walkLeft = new Animation([2, 3, 4, 3], 6);
		walkRight = new Animation([7, 8, 9, 8], 6);
		standLeft = Animation.create(5);
		standRight = Animation.create(6);
		jumpLeft = Animation.create(1);
		jumpRight = Animation.create(10);
		setAnimation(standRight);
		collider = new Rectangle(16, 32, 32, 32);
		up = false;
		right = false;
		left = false;
		down = false;
		lookRight = true;
		killed = false;
		jumpcount = 0;
		accy = 0;
		canMove = true;
		firstFloor = true;
		lastFloor = false;
		this.collides = false;
	}
	
	public override function update() {
		if (lastupcount > 0) --lastupcount;	
		
		if (y == floor1) {
			firstFloor = true;
			if (!canMove) {
			speedy = 0.0;
			canMove = true;
			}
		}
		if (y == floor2) {
			firstFloor = false;
			if (!canMove) {
			speedy = 0.0;
			canMove = true;
			}
		}
		if (y == floor3) {
			lastFloor = false;
			if (!canMove) {
			speedy = 0.0;
			canMove = true;
			}
		}
		if (y == floor4) {
			lastFloor = true;
			if (!canMove) {
			speedy = 0.0;
			canMove = true;
			}
		}		
		super.update();
	}
	
	public function goup() {
		if (canMove) {
			if (!lastFloor) {
				speedy = -elevatorSpeed;
				canMove = false;
				}
		}
	}
	
	public function godown() {
		if (canMove) {
		if (!firstFloor) {
				speedy = elevatorSpeed;
				canMove = false;
				}
	}
	}
	
	public function setUp() {
		up = false;
		lastupcount = 8;
	}
	
	public function addPositions(positions : Array<Vector2>) 
	{
		// TODO: Elevater should stop at this positions, select a random one as the starting position
	}
	
}
