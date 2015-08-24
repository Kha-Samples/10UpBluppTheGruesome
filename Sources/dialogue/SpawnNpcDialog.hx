package dialogue;

import kha2d.Sprite;

class SpawnNpcDialog implements DialogueItem
{
	var npcDlg: Dialogue;
	var items: Array<DialogueItem>;
	
	public function new(items: Array<DialogueItem>) 
	{
		this.items = items;
		this.npcDlg = new Dialogue();
	}
	
	public var finished(default, null) : Bool = true;
	
	public function execute(dlg: Dialogue): Void {
		npcDlg.insert(items);
		Empty.the.npcDlgs.push(npcDlg);
	}
	
	public function cancel(dlg: Dialogue) : Void
	{
		for (item in items) item.cancel(npcDlg);
	}
	
	function toString(): String { return 'SpawnNPC DLG'; }
}