package sprites;

import kha.math.Random;
import kha2d.Sprite;
import schedule.MoveTask;

class Michael extends RandomGuy {
	public function new(monster: Sprite, stuff: Array<InteractiveSprite>) {
		super(monster, stuff);
	}
	
	override private function createRandomTask(): Void {
		createMichaelTask();
	}
}
