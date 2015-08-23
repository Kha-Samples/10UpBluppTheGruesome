package dialogue;

import kha.input.Keyboard;
import kha.Key;
import kha2d.Sprite;

class Bla implements DialogueItem {
	var text : String;
	var speaker : Sprite;
	var persistent: Bool;
	var lastMode : Empty.Mode;
	
	public var finished(default, null) : Bool = false;
	
	public function new (txtKey : String, speaker : Sprite, persistent: Bool) {
		this.text = Localization.getText(txtKey);
		this.speaker = speaker;
		this.persistent =  persistent;
	}
	
	var dlg: Dialogue;
	private function keyUpListener(key:Key, char: String) {
		kha.Scheduler.addTimeTask( function() { 
			BlaBox.boxes.remove(dlg.blaBox);
		}, 1);
	}
	
	@:access(Empty.mode)
	public function execute(dlg: Dialogue) : Void {
		if (dlg.blaBox == null) {
			this.dlg = dlg;
			this.lastMode = Empty.the.mode;
			Empty.the.mode = Empty.Mode.Menu;
			dlg.blaBox = new BlaBox(text, speaker, persistent);
			if (persistent) Keyboard.get().notify(null, keyUpListener);
			BlaBox.boxes.push(dlg.blaBox);
		} else {
			finished = !Lambda.has(BlaBox.boxes, dlg.blaBox);
			Empty.the.mode = lastMode;
		}
	}
	
	public function cancel(dlg: Dialogue) : Void
	{
		BlaBox.boxes.remove(dlg.blaBox);
	}
}
