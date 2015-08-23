package sprites;

import kha.Loader;
import kha2d.Animation;
import kha2d.Sprite;
import schedule.MoveTask;
import schedule.Schedule;
import schedule.WaitTask;

class RandomGuy extends Sprite {
	private var schedule: Schedule;
	
	private var standLeft: Animation;
	private var standRight: Animation;
	private var walkLeft: Animation;
	private var walkRight: Animation;
	private var lookLeft: Bool;
	
	public function new(monster: Sprite) {
		super(Loader.the.getImage("nullachtsechzehnmann"), Std.int(720 / 9), Std.int(256 / 2));
		standLeft = Animation.create(9);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(10, 17, 4);
		walkRight = Animation.createRange(1, 8, 4);
		lookLeft = false;
		setAnimation(standRight);
		
		schedule = new schedule.Schedule();
		schedule.add(new WaitTask(this, 2));
		schedule.add(new MoveTask(this, monster));
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
