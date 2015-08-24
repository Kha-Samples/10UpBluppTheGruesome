package sprites;

import kha.Loader;
import kha2d.Animation;
import sprites.IdSystem.IdCard;

class Professor extends RandomGuy {
	public function new(stuff: Array<InteractiveSprite>, youarethemonster: Bool) {
		super(stuff, youarethemonster, true);
		image = Loader.the.getImage("professor");
		w = Std.int(410 * 2 / 10);
		h = Std.int(455 * 2 / 7);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		IdCard = new IdCard("Doctor");
	}
}
