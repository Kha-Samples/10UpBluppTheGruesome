package sprites;

import kha.Loader;
import kha2d.Direction;
import kha2d.Sprite;
import localization.Keys_text;

import sprites.IdSystem;

class Computer extends InteractiveSprite {
	var idLogger: IdLogger = new IdLogger(Keys_text.COMPUTER);
	
	public function new(x: Float, y: Float ) {
		super(Loader.the.getImage("computer"), 46 * 2, 60 * 2, 0);
		this.x = x;
		this.y = y - 90;
		
		this.isUseable = true;
	}
	
	override public function useFrom(dir:Direction, user:Dynamic) 
	{
		if (Std.is(user, sprites.IdCardOwner))
		{
			var owner: IdCardOwner = cast user;
			
			idLogger.useID(owner.IdCard);
		}
	}
}
