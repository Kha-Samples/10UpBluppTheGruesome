package sprites;

import kha.Loader;
import kha.math.Random;
import kha2d.Animation;
import kha2d.Sprite;
import schedule.ComputerTask;
import schedule.MoveTask;
import schedule.Schedule;
import schedule.Task;
import schedule.WaitTask;
import sprites.IdSystem.IdCard;
import sprites.IdSystem.IdCardOwner;

class RandomGuy extends Sprite implements IdCardOwner {
	public var IdCard(default, null): IdCard;
	
	private var schedule: Schedule;
	
	private var standLeft: Animation;
	private var standRight: Animation;
	private var walkLeft: Animation;
	private var walkRight: Animation;
	private var lookLeft: Bool;
	
	private var monster: Sprite;
	private var stuff: Array<InteractiveSprite>;
	
	public function new(monster: Sprite, stuff: Array<InteractiveSprite>) {
		super(Loader.the.getImage("nullachtsechzehnmann"), Std.int(720 / 9), Std.int(256 / 2));
		standLeft = Animation.create(9);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(10, 17, 4);
		walkRight = Animation.createRange(1, 8, 4);
		lookLeft = false;
		setAnimation(standRight);
		
		this.monster = monster;
		this.stuff = stuff;
		
		IdCard = new IdCard("TODO: pick random name");
		
		schedule = new schedule.Schedule();
		while (schedule.length < 20) {
			schedule.add(new WaitTask(this, Random.getUpTo(30)));
			createRandomTask();
		}
	}
	
	private function createRandomTask(): Void {
		var value = Random.getUpTo(stuff.length);
		if (value == 0) schedule.add(new MoveTask(this, monster));
		else {
			var thing = stuff[value - 1];
			schedule.add(new MoveTask(this, thing));
			if (Std.is(thing, Computer)) {
				schedule.add(new ComputerTask(this, cast thing));
			}
		}
	}
	
	override public function update(): Void {
		super.update();
		schedule.update();
		if (speedx > 0) {
			setAnimation(walkRight);
			lookLeft = false;
		}
		else if (speedx < 0) {
			setAnimation(walkLeft);
			lookLeft = true;
		}
		else {
			if (lookLeft) {
				setAnimation(standLeft);
			}
			else {
				setAnimation(standRight);
			}
		}
	}
}
