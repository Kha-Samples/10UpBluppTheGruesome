package dialogue;

import Empty.Mode;
import kha2d.Scene;


class Dialogue {
	private var items: Array<DialogueItem>;
	private var index: Int = -1;
	public var blaBox: BlaBox;
	
	public function new() { }

	public function isEmpty(): Bool { return items == null || items.length == 0; }
	
	public function cancel()
	{
		if (items != null)
		{
			if (index > 0) items.splice(0, index);
			for (item in items) item.cancel(this);
			items = null;
		}
		index = -1;
	}
	
	public function set(newItems: Array<DialogueItem>): Void {
		cancel();
		items = newItems;
		index = -1;
	}
	
	public function insert(insert: Array<DialogueItem>, toFront = false) {
		if (items == null) {
			set(insert);
		} else if (index < 0) {
			for (item in items) {
				insert.push(item);
			}
			items = insert;
		} else {
			var newItems = new Array<DialogueItem>();
			if (!toFront) {
				newItems.push(items[index]);
			}
			for (item in insert) {
				newItems.push(item);
			}
			if (!toFront) {
				++index;
			}
			while (index < items.length) {
				newItems.push(items[index]);
				++index;
			}
			index = 0;
			items = newItems;
		}
	}
	
	public function update() : Void {
		if (index >= 0 && !items[index].finished) {
			items[index].execute(this);
		} else {
			next();
		}
	}
	
	public function next(): Void {
		if (items == null) return;
		
		if (index >= 0 && !items[index].finished) {
			items[index].execute(this);
			return;
		}
		
		++index;
		if (blaBox != null) {
			BlaBox.boxes.remove(blaBox);
			blaBox = null;
		}
		
		if (index >= items.length) {
			items = null;
			index = -1;
			return;
		}
		
		items[index].execute(this);
	}
}
