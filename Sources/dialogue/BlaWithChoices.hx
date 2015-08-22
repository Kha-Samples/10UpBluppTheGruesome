package dialogue;

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
	var txtKey : String;
	var choices : Array<Array<DialogueItem>>;
	var status : BlaWithChoicesStatus = BlaWithChoicesStatus.BLA;
	var lastMode : TenUp5.Mode;
	
	public function new (txtKey : String, speaker : Sprite, choices: Array<Array<DialogueItem>>) {
		super(txtKey, speaker);
		this.txtKey = txtKey;
		this.choices = choices;
		
		this.finished = false;
		this.persistent = true;
	}
	
	var dlg: Dialogue;
	@:access(Dialogues.dlgChoices)
	@:access(TenUp5.mode)
	private function keyUpListener(key:Key, char: String) {
		var choice = char.fastCodeAt(0) - '1'.fastCodeAt(0);
		if (choice >= 0 && choice < choices.length) {
			Keyboard.get().remove(null, keyUpListener);
			this.finished = true;
			/*BlaBox.boxes.remove(dlg.blaBox);
			dlg.blaBox = null;*/
			TenUp5.the.mode = lastMode;
			dlg.insert(choices[choice]);
			dlg.next();
		}
	}
	
	@:access(TenUp5.mode)
	override public function execute(dlg: Dialogue) : Void {
		switch (status) {
			case BlaWithChoicesStatus.BLA:
				this.lastMode = TenUp5.the.mode;
				TenUp5.the.mode = TenUp5.Mode.Menu;
				this.dlg = dlg;
				super.execute(dlg);
				Keyboard.get().notify(null, keyUpListener);
				status = BlaWithChoicesStatus.CHOICE;
			case BlaWithChoicesStatus.CHOICE:
				// just wait for input
		}
	}
}
