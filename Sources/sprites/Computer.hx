package sprites;

import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.DialogueItem;
import dialogue.StartDialogue;
import kha.Loader;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Sprite;

import sprites.IdSystem;

class Computer extends IdLoggerSprite {
	var currentUser: IdCardOwner;
	var onAnimation: Animation;
	var offAnimation: Animation;
	var missingAnimation: Animation;
	
		super(Keys_text.COMPUTER, Loader.the.getImage("computer"), 46 * 2, 60 * 2, 0);
	
	public function new(x: Float, y: Float, active: Bool) {
		super(Keys_text.COMPUTER, Loader.the.getImage("computer"), 192, 128, 0);
		this.x = x;
		this.y = y;
		
		offAnimation = Animation.create(0);
		onAnimation = Animation.create(1);
		missingAnimation = Animation.create(2);
		if (active) {
			this.isUseable = true;
		} else {
			setAnimation(missingAnimation);
		}
	}
	
	function searchCriticalFiles(): Void {
		// TODO: implement
	}
	function useDialogue(): Void {
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
