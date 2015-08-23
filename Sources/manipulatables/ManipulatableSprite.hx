package manipulatables;
import dialogue.Action.ActionType;

enum OrderType {
	Nothing;
	MoveTo;
	Take;
	InventoryItem;
	Enter;
	WontWork;
	Eat;
	Slay;
	Extinguish;
	Apply;
	ToolTip;
	Bla;
}

interface ManipulatableSprite {
	public var name(get, null): String;
	
	public function getOrder(selectedItem : UseableSprite) : OrderType;
	
	public function executeOrder(order : OrderType) : Void;
}