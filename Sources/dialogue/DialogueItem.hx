package dialogue;

import dialogue.Dialogue;

interface DialogueItem {
	public function execute(dlg: Dialogue) : Void;
	public var finished(default, null) : Bool;
}