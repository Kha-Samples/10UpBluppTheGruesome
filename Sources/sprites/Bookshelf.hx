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
	var important : Bool = false;
	
	public function new(x: Float, y: Float, important: Bool) {
		super(Loader.the.getImage("bookshelf"), 96, 128, 0);
		this.x = x;
		this.y = y;
		this.important = important;
		
		this.isUseable = true;
		defaultAnimation = Animation.create(0);
		destroyedAnimation = Animation.create(1);
		setAnimation(defaultAnimation);
	}
	
	function search(): Void {
		if (important) {
			// TODO: Fix item pickup
			var fk : UseableSprite = new UseableSprite(Localization.getText(Keys_text.FLUXCOMPENSATOR), Loader.the.getImage("broetchen1"), 0, 0, 39, 39, 0);
			Inventory.pick(fk);
			setAnimation(destroyedAnimation);
			destroyed = true;
			
			var text = Localization.getText(Keys_text.ITEMFOUND, [ fk.name ]);
			dlg.insert([new Bla(text, this)]);
		}
	}
	
	function useComputerDialogue(): Void {
		var choices = new Array<Array<DialogueItem>>();
		var text = Localization.getText(Keys_text.BOOKSHELF_ACTIONS);
		choices.push([new StartDialogue(search)]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.BOOKSHELF_SEARCH);
		choices.push([]);
		text += '\n${choices.length}: ' + Localization.getText(Keys_text.BOOKSHELF_LEAVE);
		dlg.insert([new BlaWithChoices( text, this, choices)]);
	}
	
	override public function useFrom(dir:Direction, user:Dynamic): Bool 
	{
		if (destroyed) return false;
		
		if (user == Player.current() && Std.is(user, Fishman))
		{
			useComputerDialogue();
		}
		return true;
	}
}
