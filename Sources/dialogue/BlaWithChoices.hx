package dialogue;

import dialogue.Dialogue;
import Dialogues;
import kha.input.Keyboard;
import kha.Key;
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
	
	@:access(Dialogues.dlgChoices)
	@:access(Empty.mode)
	override function keyUpListener(key:Key, char: String) {
		var choice = char.fastCodeAt(0) - '1'.fastCodeAt(0);
		if (choice >= 0 && choice < choices.length) {
			Keyboard.get().remove(null, keyUpListener);
			this.finished = true;
			/*BlaBox.boxes.remove(dlg.blaBox);
			dlg.blaBox = null;*/
			Empty.the.mode = lastMode;
			dlg.insert(choices[choice]);
			dlg.next();
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
		dlg.insert(choices[0]);
		if (lastMode != null) Empty.the.mode = lastMode;
	}
}
