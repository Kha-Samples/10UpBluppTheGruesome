package dialogue;

import dialogue.Dialogue;
import Dialogues;
import kha.input.Keyboard;
import kha.input.KeyCode;
import kha2d.Sprite;

using StringTools;

enum BlaWithChoicesStatus {
	BLA;
	CHOICE;
}

class BlaWithChoices extends Bla {
	var choices : Array<Array<DialogueItem>>;
	var status : BlaWithChoicesStatus = BlaWithChoicesStatus.BLA;
	
	public function new (txtKey : String, speaker : Sprite, choices: Array<Array<DialogueItem>>) {
		super(txtKey, speaker, true);
		this.choices = choices;
		
		this.finished = false;
	}
	
	override function keyPressListener(char: String) {
		trace ('KEY UP: $char');
		var choice = char.fastCodeAt(0) - '1'.fastCodeAt(0);
		if (choice >= 0 && choice < choices.length) {
			Keyboard.get().remove(null, null, keyPressListener);
			finished = true;
			dlg.insert(choices[choice], true);
		}
	}
	
	@:access(Empty.mode)
	override public function execute(dlg: Dialogue) : Void {
		switch (status) {
			case BlaWithChoicesStatus.BLA:
				super.execute(dlg);
				status = BlaWithChoicesStatus.CHOICE;
			case BlaWithChoicesStatus.CHOICE:
				// just wait for input
		}
	}
	
	@:access(Empty.mode)
	override public function cancel(dlg:Dialogue):Void 
	{
		super.cancel(dlg);
		if (choices != null && choices.length > 0) for (item in choices[0]) item.cancel(dlg);
	}
	
	override function toString(): String { return 'BlaWithChoices<${text.replace("\n", "|").replace("\r", "|")}>'; }
}
