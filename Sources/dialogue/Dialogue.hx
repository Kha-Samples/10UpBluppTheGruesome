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
		trace('DLG cancel!');
		if (items != null)
		{
			if (index > 0) items.splice(0, index);
			for (item in items) item.cancel(this);
			items = null;
		}
		index = -1;
		BlaBox.boxes.remove(blaBox);
		blaBox = null;
	}
	
	public function set(newItems: Array<DialogueItem>): Void {
		if (items != null && items.length > 0) throw "Not supported!";
		items = newItems;
		index = -1;
		if (items != null) for (i in 0...items.length) trace ('DLG added ${items[i]} at $i');
		update();
	}
	
	public function insert(insert: Array<DialogueItem>, toFront = false) {
		if (items == null) items = new Array();
		if (index < 0) {
			trace('DLG insert($toFront): index: $index, #items: ${items.length}');
			if (toFront)
			{
				for (i in 0...insert.length)
				{
					trace ('DLG added ${insert[i]} at $i');
				}
				for (item in items) {
					trace ('DLG moved $item to ${insert.length}');
					insert.push(item);
				}
				items = insert;
			}
			else
			{
				for (item in insert) {
					trace ('DLG added $item at ${items.length}');
					items.push(item);
				}
			}
		} else {
			trace('DLG insert($toFront): index: $index, #items: ${items.length}');
			var newItems = new Array<DialogueItem>();
			var newIndex = toFront ? -1 : 0;
			if (index < items.length && items[index].finished)
			{
				newIndex = -1;
				++index;
			}
			if (!toFront) {
				while (index < items.length) {
					newItems.push(items[index]);
					++index;
				}
			}
			for (item in insert) {
				trace ('DLG added $item at ${newItems.length}');
				newItems.push(item);
			}
			while (index < items.length) {
				trace ('DLG moved ${items[index]} to ${newItems.length}');
				newItems.push(items[index]);
				++index;
			}
			items = newItems;
			index = newIndex;
		}
		update();
	}
	
	public function update(): Void {
		if (items == null) return;
		
		if (index >= 0 && !items[index].finished) {
			//trace ('DLG index: $index, executing: ${items[index]}');
			items[index].execute(this);
			return;
		}
		
		++index;
		if (blaBox != null) {
			BlaBox.boxes.remove(blaBox);
			blaBox = null;
		}
		
		if (index >= items.length) {
			trace ('DLG empty!');
			items = null;
			index = -1;
		}
		else {
			trace ('DLG index: $index, executing: ${items[index]}');
			items[index].execute(this);
		}
	}
}
