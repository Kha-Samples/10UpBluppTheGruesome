package dialogue;

import kha.input.Keyboard;
import kha.input.KeyCode;
import kha2d.Sprite;

using StringTools;

class Bla implements DialogueItem {
	var text : String;
	var speaker : Sprite;
	var persistent: Bool;
	
	public var finished(default, null) : Bool = false;
	
	public function new (txtKey : String, speaker : Sprite, persistent: Bool) {
		this.text = Localization.getText(txtKey);
		this.speaker = speaker;
		this.persistent =  persistent;
	}
	
	var dlg: Dialogue;
	private function keyPressListener(char: String) {
		trace ('KEY UP: $char');
		Keyboard.get().remove(null, null, keyPressListener);
		kha.Scheduler.addTimeTask( function() { 
			finished = true;
		}, 0.5);
	}
	
	public function execute(dlg: Dialogue) : Void {
		if (dlg.blaBox == null) {
			this.dlg = dlg;
			dlg.blaBox = new BlaBox(text, speaker, persistent);
			if (persistent)
			{
				Keyboard.get().notify(null, null, keyPressListener);
			}
			BlaBox.boxes.push(dlg.blaBox);
		} else {
			finished = !Lambda.has(BlaBox.boxes, dlg.blaBox);
		}
	}
	
	public function cancel(dlg: Dialogue) : Void
	{
		Keyboard.get().remove(null, null, keyPressListener);
		BlaBox.boxes.remove(dlg.blaBox);
		dlg.blaBox = null;
	}
	
	function toString(): String { return 'Bla<${text.replace("\n", "|").replace("\r","|")}>'; }
}
