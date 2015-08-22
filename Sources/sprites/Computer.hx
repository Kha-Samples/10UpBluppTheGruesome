package sprites;

import kha.Loader;
import kha2d.Sprite;

class Computer extends Sprite {
	public function new(x: Float, y: Float ) {
		super(Loader.the.getImage("0"), 46 * 2, 60 * 2, 0);
		this.x = x;
		this.y = y;
	}	
}
