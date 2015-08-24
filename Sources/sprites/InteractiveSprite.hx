package sprites;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Rectangle;
import kha.Rotation;
import kha.math.Vector2;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Scene;
import kha2d.Sprite;

import dialogue.Dialogue;

class InteractiveSprite extends Sprite {
	public var isUseable(default, null) : Bool = false;
	public var isLiftable(default, null) : Bool = false;
	public var playerCanUseIt(default, null) : Bool = false;
	public var isCurrentlyUsedFrom(default, null): Dynamic = null;
	
	public function new(image:Image, width:Int=0, height:Int=0, z:Int=1) {
		super(image, width, height, z);
	}
	
	public var center(get, never) : Vector2;
	@:noCompletion private inline function get_center() : Vector2 {
		return new Vector2(Math.round(x - collider.x) + 0.5 * width, Math.round(y - collider.y) + 0.5 * height);
	}
	
	public function isUsableFrom( user: Dynamic ): Bool { return false; }
	public function useFrom( user: Dynamic ): Bool
	{
		if (isUsableFrom(user)) {
			isCurrentlyUsedFrom = user;
			return true;
		}
		return false;
	}
	public function stopUsing(clean: Bool): Void { isCurrentlyUsedFrom = null; }
	
	override public function update():Void 
	{
		super.update();
		
		if (playerCanUseItClear) playerCanUseIt = false;
		else playerCanUseItClear = true;
	}
	
	var playerCanUseItClear = true;
	override public function hit(sprite:Sprite):Void 
	{
		if (isUseable && isCurrentlyUsedFrom == null && sprite == Player.current() && isUsableFrom(sprite) ) {
			playerCanUseIt = true;
			playerCanUseItClear = false;
			// TODO: inform HUMAN about the possibility to USE this
		}
	}
}