package sprites;

import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.DialogueItem;
import dialogue.StartDialogue;
import kha.Loader;
import kha2d.Animation;
import kha2d.Direction;
import kha2d.Sprite;
import manipulatables.UseableSprite;

import sprites.IdSystem;

class Bookshelf extends InteractiveSprite {
	
	var defaultAnimation : Animation;
	var destroyedAnimation : Animation;
	var destroyed : Bool = false;
	var part : Int = -1;
	
	public function new(x: Float, y: Float, part: Int) {
		super(Loader.the.getImage("bookshelf"), 96, 128, 0);
		this.x = x;
		this.y = y;
		this.part = part;
		
		this.isUseable = true;
		defaultAnimation = Animation.create(0);
		destroyedAnimation = Animation.create(1);
		setAnimation(defaultAnimation);
	}
	
	function search(): Void {
		if (part > -1) {
			var fk : UseableSprite;
			switch (part) {
				case 0:
					fk = new UseableSprite(Localization.getText(Keys_text.TC1), Loader.the.getImage("tc-1"), 0, 0, 46, 12, 0);
					Empty.the.gotTC1 = true;
				case 1:
					fk = new UseableSprite(Localization.getText(Keys_text.TC2), Loader.the.getImage("tc-2"), 0, 0, 16, 22, 0);
					Empty.the.gotTC2 = true;
				case 2:
					fk = new UseableSprite(Localization.getText(Keys_text.TC3), Loader.the.getImage("tc-3"), 0, 0, 42, 18, 0);
					Empty.the.gotTC3 = true;
				case 3:
					fk = new UseableSprite(Localization.getText(Keys_text.TC4), Loader.the.getImage("tc-4"), 0, 0, 40, 22, 0);
					Empty.the.gotTC4 = true;
				default:
					trace("invalid time cannon part");
					return;
			}
			Inventory.pick(fk);
			setAnimation(destroyedAnimation);
			part = -1;
			
			var text = Localization.getText(Keys_text.ITEMFOUND, [ fk.name ]);
			Empty.the.playerDlg.insert([new Bla(text, this, true)]);
			Empty.the.checkGameEnding();
		}
	}
	
	function useDialogue(): Void {
		var choices = new Array<Array<DialogueItem>>();
		var text = Localization.getText(Keys_text.BOOKSHELF_ACTIONS);
		choices.push([new StartDialogue(search)]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.BOOKSHELF_SEARCH);
		choices.push([new StartDialogue(stopUsing.bind(true))]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.BOOKSHELF_LEAVE);
		Empty.the.playerDlg.insert([new BlaWithChoices( text, this, choices)]);
	}
	
	override public function isUsableFrom(user:Dynamic):Bool 
	{
		return super.isUsableFrom(user) && !destroyed && user == Player.current() && Std.is(user, Fishman);
	}
	override public function useFrom(user:Dynamic): Bool 
	{
		if (super.useFrom(user))
		{
			useDialogue();
			return true;
		}
		return false;
	}
}
