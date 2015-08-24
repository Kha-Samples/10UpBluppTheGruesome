package sprites;

import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.FastMatrix3;
import kha.math.Random;
import kha.math.Vector2;
import kha2d.Animation;
import kha2d.Sprite;
import schedule.CoffeeTask;
import schedule.ComputerTask;
import schedule.MoveTask;
import schedule.Schedule;
import schedule.SleepTask;
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
	
	public var youarethemonster: Bool;
	
	public var sleeping: Bool;
	
	private static var names = ["Augusto", "Ingo", "Christian", "Robert", "Björn", "Johannes", "Rebecca", "Stephen", "Alvar", "Michael", "Linh", "Roger", "Roman", "Max", "Paul", "Tobias", "Henno", "Niko", "Kai", "Julian"];
	public static var allguys = new Array<RandomGuy>();
	
	public function new(stuff: Array<InteractiveSprite>, youarethemonster: Bool) {
		super(Loader.the.getImage("nullachtsechzehnmann"), Std.int(720 / 9), Std.int(256 / 2));
		this.youarethemonster = youarethemonster;
		standLeft = Animation.create(9);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(10, 17, 4);
		walkRight = Animation.createRange(1, 8, 4);
		lookLeft = false;
		sleeping = false;
		setAnimation(standRight);
		
		this.stuff = [];
		for (thing in stuff) {
			if (thing.isUseable && thing.isUsableFrom(this) && (Std.is(thing, Computer) || Std.is(thing, Coffee))) {
				this.stuff.push(thing);
			}
		}
		
		var name = names[Random.getUpTo(names.length - 1)];
		names.remove(name);
		IdCard = new IdCard(name);
		
		schedule = new schedule.Schedule();
		
		allguys.push(this);
	}
	
	public static function monsterPosition(): Vector2 {
		for (guy in allguys) {
			if (guy.youarethemonster) {
				return new Vector2(guy.x, guy.y);
			}
		}
		return new Vector2();
	}
	
	public static function monsterName(): String {
		for (guy in allguys) {
			if (guy.youarethemonster) {
				return guy.IdCard.Name;
			}
		}
		return "Blubb der Schreckliche";
	}
	
	public static function endDayForEverybody(): Void {
		for (guy in allguys) {
			guy.end();
		}
		for (guy in allguys) {
			guy.visible = false;
		}
		var sleeperCount = Random.getIn(1, 3);
		var guys = allguys.copy();
		for (i in 0...sleeperCount) {
			var guy = guys[Random.getUpTo(guys.length - 1)];
			guys.remove(guy);
			guy.visible = true;
			guy.schedule.add(new SleepTask(guy));
		}
		createAllTasks();
	}
	
	public static function endNightForEverybody(): Void {
		for (guy in allguys) {
			guy.end();
		}
		for (guy in allguys) {
			guy.visible = true;
		}
		createAllTasks();
	}
	
	public function end(): Void {
		schedule.end();
	}
	
	public static function createAllTasks(): Void {
		for (guy in allguys) {
			guy.createTasks();
		}
	}
	
	private function createTasks(): Void {
		if (!visible) return;
		while (schedule.length < 20) {
			schedule.add(new WaitTask(this));
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
	
	override public function render(g: Graphics): Void {
		if (sleeping) {
			if (image != null && visible) {
				g.color = Color.White;
				var angle = Math.PI / 2;
				var x = this.x + 40;
				var y = this.y + 80;
				lookLeft = true;
				if (angle != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(x + originX, y + originY)).multmat(FastMatrix3.rotation(angle)).multmat(FastMatrix3.translation(-x - originX, -y - originY)));
				g.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h, Math.round(x - collider.x * scaleX), Math.round(y - collider.y * scaleY), width, height);
				if (angle != 0) g.popTransformation();
			}
		}
		else {
			super.render(g);
		}
	}
}
