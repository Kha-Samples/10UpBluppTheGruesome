package dialogue;

interface Branch extends DialogueItem {
	
}

class IntBranch implements Branch {
	var condFunc : Void -> Int;
	var branches : Array<Array<DialogueItem>>;
	
	public function new (condFunc: Void -> Int, branches: Array<Array<DialogueItem>>) {
		this.condFunc = condFunc;
		this.branches = branches;
	}
	
	public var finished(default, null) : Bool = true;
	
	public function execute(dlg: Dialogue) : Void {
		var r = condFunc();
		if (r < 0) {
			r = branches.length - r;
		}
		dlg.insert(branches[r]);
		dlg.next();
	}
}

class BooleanBranch implements Branch {
	var condFunc : Void -> Bool;
	var onTrue : Array<DialogueItem>;
	var onFalse : Array<DialogueItem>;
	
	public function new (condFunc: Void -> Bool, onTrue: Array<DialogueItem>, onFalse: Array<DialogueItem>) {
		this.condFunc = condFunc;
		this.onTrue = onTrue;
		this.onFalse = onFalse;
	}
	
	public var finished(default, null) : Bool = true;
	
	public function execute(dlg: Dialogue) : Void {
		if (condFunc()) {
			dlg.insert(onTrue);
		} else {
			dlg.insert(onFalse);
		}
		dlg.next();
	}
}