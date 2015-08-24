package sprites;

import kha.math.Random;
import kha2d.Sprite;
import schedule.MoveTask;

class Michael extends RandomGuy {
	public function new(monster: Sprite, stuff: Array<InteractiveSprite>) {
		super(monster, stuff);
	}
	
	override private function createRandomTask(): Void {
		var guy: RandomGuy = this;
		while (guy == this) {
			var value = Random.getUpTo(RandomGuy.allguys.length - 1);
			guy = RandomGuy.allguys[value - 1];
		}
		schedule.add(new MoveTask(this, guy));
	}
}
