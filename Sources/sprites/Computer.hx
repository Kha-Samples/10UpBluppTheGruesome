package sprites;

import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.DialogueItem;
import dialogue.StartDialogue;
import kha.Loader;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Sprite;
import localization.Keys_text;

import sprites.IdSystem;

class Computer extends IdLoggerSprite {
	var currentUser: IdCardOwner;
	var onAnimation: Animation;
	var offAnimation: Animation;
	
	public function new(x: Float, y: Float ) {
		super(Keys_text.COMPUTER, Loader.the.getImage("computer"), 46 * 2, 60 * 2, 0);
		this.x = x;
		this.y = y - 90;
		
		this.isUseable = true;
		offAnimation = Animation.create(0);
		onAnimation = Animation.create(1);
	}
	
	function searchCriticalFiles(): Void {
		
	}
	function useComputerDialogue(): Void {
		var choices = new Array<Array<DialogueItem>>();
		var text = Localization.getText(Keys_text.COMPUTER_HELLO, [currentUser.IdCard.Name]);
		choices.push([new StartDialogue(searchCriticalFiles), new StartDialogue(useComputerDialogue)]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_SEARCH);
		if (Std.is(currentUser, Agent))
		{
			choices.push([new Bla(idLogger.displayUsers(), this), new StartDialogue(useComputerDialogue)]);
			text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_SHOW_USERS);
		}
		choices.push([new StartDialogue(stopUsing)]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_LOGOUT);
		choices.push([]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.COMPUTER_JUST_LEAVE);
		Empty.the.dlg.insert([new BlaWithChoices( text, this, choices)]);
	}
	override public function useFrom(dir:Direction, user:Dynamic): Bool 
	{
		if (currentUser != null || super.useFrom(dir, user))
		{
			if (currentUser == null) currentUser = cast user;
			
			setAnimation(onAnimation);
			
			if (user == Player.current())
			{
				useComputerDialogue();
			}
			
			return true;
		}
		return false;
	}
	override public function stopUsing():Void 
	{
		currentUser = null;
		setAnimation(offAnimation);
	}
}
