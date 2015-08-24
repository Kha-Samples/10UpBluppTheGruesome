package sprites;

import kha.math.Random;
import kha2d.Sprite;
import schedule.MoveTask;
import sprites.IdSystem.IdCard;

class Michael extends RandomGuy {
	public function new(stuff: Array<InteractiveSprite>) {
		super(stuff, false);
		IdCard = new IdCard("Michael");
	}
	
	override private function createRandomTask(): Void {
		createMichaelTask();
	}
}
