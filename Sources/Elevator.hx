package;

import dialogue.BlaWithChoices;
import dialogue.DialogueItem;
import dialogue.StartDialogue;
import kha.math.Vector2;
import kha2d.Animation;
import kha.audio1.Audio;
import kha2d.Direction;
import kha.Loader;
import kha.Rectangle;
import kha.Sound;
import kha2d.Sprite;
import sprites.IdSystem.IdLoggerSprite;
import sprites.InteractiveSprite;
import sprites.Player;

class Elevator extends IdLoggerSprite {
	var openAnimation : Animation;
	var closedAnimation : Animation;
	public var level : Int;
	public var open(default, set_open) : Bool;
	
	public function new(x : Float, y : Float, level : Int) {
		super(Keys_text.ELEVATOR, Loader.the.getImage("elevator"), 192, 128, 0);
		this.x = x;
		this.y = y;
		this.level = level;
		openAnimation = Animation.create(1);
		closedAnimation = Animation.create(0);
		accy = 0;
		collides = false;
		
		isUseable = true;
	}
	
	public function set_open(value : Bool) : Bool {
		open = value;
		setAnimation(open ? openAnimation : closedAnimation);
		if (!open) {
			if (isCurrentlyUsedFrom == Player.current()) {
				Empty.the.playerDlg.cancel();
			}
		}
		return open;
	}
	
	override public function useFrom(dir:Direction, user:Dynamic):Bool 
	{
		if (!super.useFrom(dir, user)) return false;
		if (open) 
		{
			var text : String = "";
			var choices = new Array<Array<DialogueItem>>();
			for (i in 1...ElevatorManager.the.levels)
			{
				var to = ElevatorManager.the.levels - i;
				choices.push([new StartDialogue(ElevatorManager.the.getIn.bind(user, level, to, null))]);
				text += '$i: ' + Localization.getText(Keys_text.FLOOR) + ' $to\n';
			}
			choices.push([new StartDialogue(ElevatorManager.the.getIn.bind(user, level, 0, null))]);
			text += '${ElevatorManager.the.levels}: ' + Localization.getText(Keys_text.FLOOR_0) + "\n";
			Empty.the.playerDlg.insert([new BlaWithChoices(text, this, choices), new StartDialogue(function() { isCurrentlyUsedFrom = null; })]);
			isCurrentlyUsedFrom = user;
		}
		else
		{
			ElevatorManager.the.callTo(level);
		}
		
		return true;
	}
	
	/*public override function update() {
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
	}*/
}
