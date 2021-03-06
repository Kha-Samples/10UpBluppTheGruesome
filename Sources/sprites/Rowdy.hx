package sprites;

import kha.Assets;
import kha2d.Animation;
import sprites.IdSystem.IdCard;

class Rowdy extends RandomGuy {
	public function new(stuff: Array<InteractiveSprite>, youarethemonster: Bool) {
		super(stuff, youarethemonster, true);
		image = Assets.images.rowdy;
		w = Std.int(410 * 2 / 10);
		h = Std.int(455 * 2 / 7);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		IdCard = new IdCard("Mr U");
	}
}
