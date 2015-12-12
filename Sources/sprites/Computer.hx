package sprites;

import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.DialogueItem;
import dialogue.StartDialogue;
import kha.Assets;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Sprite;
import manipulatables.UseableSprite;

import sprites.IdSystem;

class Computer extends IdLoggerSprite {
	var currentUser: IdCardOwner;
	var onAnimation: Animation;
	var offAnimation: Animation;
	var missingAnimation: Animation;
	var plan : Int = -1;
	
	public function new(x: Float, y: Float, active: Bool, plan : Int) {
		super(Keys_text.COMPUTER, Assets.images.computer, 192, 128, 0);
		this.x = x;
		this.y = y;
		this.plan = plan;
		
		this.isUseable = active;
		offAnimation = Animation.create(0);
		onAnimation = Animation.create(1);
		missingAnimation = Animation.create(2);
		if (!active) setAnimation(missingAnimation);
	}
	
	function searchCriticalFiles(): Void {
		
		if (plan > -1) {
			var part : UseableSprite;
			switch (plan) {
				case 0:
					part = new UseableSprite(Localization.getText(Keys_text.PLAN1), Assets.images.pl, 0, 0, 60, 60, 0);
					Empty.the.gotPl1 = true;
				case 1:
					part = new UseableSprite(Localization.getText(Keys_text.PLAN2), Assets.images.an, 0, 0, 60, 60, 0);
					Empty.the.gotan2 = true;
				default:
					trace("invalid plan part");
					return;
			}
			if (Player.current() == Empty.the.monsterPlayer) {
				Inventory.pick(part);
				plan = -1;
				
				var text = Localization.getText(Keys_text.ITEMFOUND, [ part.name ]);
				Empty.the.playerDlg.insert([new Bla(text, this, true)]);
				Empty.the.checkGameEnding();
			}
			else {
				var text = Localization.getText(Keys_text.ITEMFOUND, [ part.name ]);
				Empty.the.playerDlg.insert([new Bla(text, this, true)]);
			}
		}
		else {
			var text = Localization.getText(Keys_text.NOTHINGFOUND);
			Empty.the.playerDlg.insert([new Bla(text, this, true)]);		
		}
	}
	
	function useDialogue(): Void {
		if (currentUser == null) return;
		var choices = new Array<Array<DialogueItem>>();
		var text = Localization.getText(Keys_text.COMPUTER_HELLO, [currentUser.IdCard.Name]);
		choices.push([new StartDialogue(searchCriticalFiles), new StartDialogue(useDialogue)]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_SEARCH);
		if (Std.is(currentUser, Agent))
		{
			choices.push([idLogger.displayUsers(this), new StartDialogue(useDialogue)]);
			text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_SHOW_USERS);
		}
		choices.push([new StartDialogue(stopUsing.bind(true))]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_LOGOUT);
		choices.push([new StartDialogue(stopUsing.bind(false))]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_JUST_LEAVE);
		Empty.the.playerDlg.insert([new BlaWithChoices( text, this, choices)]);
	}
	
	override public function isUsableFrom(user:Dynamic):Bool 
	{
		return currentUser != null || super.isUsableFrom(user);
	}
	override public function useFrom(user:Dynamic): Bool 
	{
		if (super.useFrom(user))
		{
			if (currentUser == null) currentUser = cast user;
			
			setAnimation(onAnimation);
			
			if (user == Player.current())
			{
				useDialogue();
			}
			
			return true;
		}
		return false;
	}
	override public function stopUsing(clean: Bool):Void 
	{
		super.stopUsing(clean);
		if (clean)
		{
			currentUser = null;
			setAnimation(offAnimation);
		}
	}
}
