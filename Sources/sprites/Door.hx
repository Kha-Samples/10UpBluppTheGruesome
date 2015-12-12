package sprites;

import dialogue.BlaWithChoices;
import dialogue.StartDialogue;
import kha.Assets;
import kha2d.Rectangle;
import kha.Scheduler;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Scene;
import kha2d.Sprite;
import sprites.IdSystem.IdCardOwner;
import sprites.IdSystem.IdLogger;

class Door extends DestructibleSprite {
	public var opened(default,set) = false;
	private var openAnim: Animation;
	private var closedAnim: Animation;
	private var crackedAnim: Animation;
	private var destroyedAnim: Animation;
	public var idLogger: IdLogger;
	
	public function new(x: Int, y: Int) {
		super(100, Assets.images.door, 32 * 2, 64 * 2, 0);
		this.x = x;
		this.y = y;
		accy = 0;
		closedAnim = Animation.create(0);
		openAnim = Animation.create(1);
		crackedAnim = Animation.create(2);
		destroyedAnim = Animation.create(3);
		setAnimation(closedAnim);
		isStucture = true;
		isRepairable = true;
		collides = true;
		idLogger = new IdLogger(Keys_text.SECURITY_DOOR);
		isUseable = true;
	}
	
	private function set_opened(value : Bool) : Bool {
		if (opened == value) {
			return opened;
		}
		//Server.the.changeDoorOpened(id, value);
		if ( opened = value ) {
			setAnimation(openAnim);
		} else {
			if ( health <= 0 ) {
				setAnimation(destroyedAnim);
			} else if ( health < 75 ) {
				setAnimation(crackedAnim);
			}
			else {
				setAnimation(closedAnim);
			}
		}
		return opened;
	}
	
	override private function set_health(value:Int):Int {
		//if (value != _health) Server.the.changeDoorHealth(id, value);
		if (opened) return _health;
		
		if ( value <= 0 ) {
			setAnimation(destroyedAnim);
		} else if ( value < _health ) {
			// TODO: pain cry
			if (value < 75) {
				setAnimation(crackedAnim);
			}
		} else if ( value > _health ) {
			if (value < 75) {
				setAnimation(crackedAnim);
			} else {
				setAnimation(closedAnim);
			}
		}
		return super.set_health(value);
	}
	
	var nextCloseTime: Float;
	public override function hit(sprite: Sprite) {
		super.hit(sprite);
		if (opened) {
			nextCloseTime = Scheduler.time() + 1.0;
			return;
		}
		if (health <= 0) return;
		
		if (Std.is(sprite, IdCardOwner))
		{
			var owner : IdCardOwner = cast sprite;
			idLogger.useID(owner.IdCard);
			opened = true;
			nextCloseTime = Scheduler.time() + 1.0;
		}
		else
		{
			if (sprite.x < x) {
				sprite.x = x - sprite.tempcollider.width - 1;
			} else {
				if (sprite.x < x + 0.5 * tempcollider.width) sprite.x = x + 0.5 * tempcollider.width;
			}
		}
	}
	
	override public function update():Void 
	{
		super.update();
		if (Scheduler.time() >= nextCloseTime) {
			nextCloseTime = Math.NaN;
			opened = false;
		}
	}
	
	override public function isUsableFrom(user:Dynamic):Bool 
	{
		return health > 0 && Std.is(user, Agent) && Player.current() == user;
	}
	override public function useFrom(user: Dynamic): Bool
	{
		if (isUsableFrom(user))
		{
			isCurrentlyUsedFrom = user; 
			Empty.the.playerDlg.set([ idLogger.displayUsers(this), new StartDialogue(stopUsing.bind(true)) ]);
			
			return true;
		}
		return false;
	}
}
