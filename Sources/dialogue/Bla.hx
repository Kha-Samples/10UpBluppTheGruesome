package dialogue;

import kha.input.Keyboard;
import kha.Key;
import kha2d.Sprite;

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
	private function keyUpListener(key:Key, char: String) {
		trace ('KEY UP: $char');
		Keyboard.get().remove(null, keyUpListener);
		kha.Scheduler.addTimeTask( function() { 
			finished = true;
		}, 0.5);
	}
	
	@:access(Empty.mode)
	public function execute(dlg: Dialogue) : Void {
		if (dlg.blaBox == null) {
			this.dlg = dlg;
			dlg.blaBox = new BlaBox(text, speaker, persistent);
			if (persistent)
			{
				Keyboard.get().notify(null, keyUpListener);
			}
			BlaBox.boxes.push(dlg.blaBox);
		} else {
			finished = !Lambda.has(BlaBox.boxes, dlg.blaBox);
		}
	}
	
	public function cancel(dlg: Dialogue) : Void
	{
		Keyboard.get().remove(null, keyUpListener);
		BlaBox.boxes.remove(dlg.blaBox);
		dlg.blaBox = null;
	}
	
	function toString(): String { return 'Bla<${StringTools.replace(text, "\n", "\\n")}>'; }
}
