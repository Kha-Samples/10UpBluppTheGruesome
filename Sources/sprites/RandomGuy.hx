package sprites;

import kha.Loader;
import kha.math.Random;
import kha2d.Animation;
import kha2d.Sprite;
import schedule.CoffeeTask;
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
	
	private var stuff: Array<InteractiveSprite>;
	
	private static var names = ["Augusto", "Ingo", "Christian", "Robert", "Björn", "Johannes", "Rebecca", "Stephen", "Alvar", "Michael", "Linh", "Roger", "Roman", "Max", "Paul", "Tobias", "Henno", "Niko", "Kai", "Julian"];
	private static var allguys = new Array<RandomGuy>();
	
	public function new(stuff: Array<InteractiveSprite>) {
		super(Loader.the.getImage("nullachtsechzehnmann"), Std.int(720 / 9), Std.int(256 / 2));
		standLeft = Animation.create(9);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(10, 17, 4);
		walkRight = Animation.createRange(1, 8, 4);
		lookLeft = false;
		setAnimation(standRight);
		
		this.stuff = [];
		for (thing in stuff) {
			if (Std.is(thing, Computer) || Std.is(thing, Coffee)) {
				this.stuff.push(thing);
			}
		}
		
		var name = names[Random.getUpTo(names.length - 1)];
		names.remove(name);
		IdCard = new IdCard(name);
		
		schedule = new schedule.Schedule();
		
		allguys.push(this);
	}
	
	public static function endDayForEverybody(): Void {
		for (guy in allguys) {
			guy.endDay();
		}
		createAllTasks();
	}
	
	public function endDay(): Void {
		schedule.endDay();
	}
	
	public static function createAllTasks(): Void {
		for (guy in allguys) {
			guy.createTasks();
		}
	}
	
	private function createTasks(): Void {
		while (schedule.length < 20) {
			schedule.add(new WaitTask(this, Random.getUpTo(30)));
			createRandomTask();
		}
	}
	
	private function createRandomTask(): Void {
		var tasktype = Random.getUpTo(9);
		switch (tasktype) {
			case 0:
				schedule.add(new MoveTask(this, Player.current()));
			case 1, 2:
				createMichaelTask();
			case 3, 4, 5, 6, 7, 8, 9:
				createStuffTask();
		}
	}
	
	private function createStuffTask(): Void {
		var value = Random.getUpTo(stuff.length - 1);
		var thing = stuff[value];
		schedule.add(new MoveTask(this, thing));
		if (Std.is(thing, Computer)) {
			schedule.add(new ComputerTask(this, cast thing));
		}
		if (Std.is(thing, Coffee)) {
			schedule.add(new CoffeeTask(this, cast thing));
		}
	}
	
	private function createMichaelTask(): Void {
		var guy: RandomGuy = this;
		while (guy == this) {
			var value = Random.getUpTo(RandomGuy.allguys.length - 1);
			guy = RandomGuy.allguys[value];
		}
		schedule.add(new MoveTask(this, guy));
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
