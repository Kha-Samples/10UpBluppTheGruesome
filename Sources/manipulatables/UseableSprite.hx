package manipulatables;

import kha.graphics2.Graphics;
import kha.Image;
import kha2d.Scene;
import kha2d.Sprite;
import manipulatables.ManipulatableSprite.OrderType;

class UseableSprite extends Sprite implements ManipulatableSprite
{
	public var isInInventory(default, null) : Bool = false;
	
	public function new(name: String, image: Image, px : Int, py : Int, width: Int = 0, height: Int = 0, z: Int = 1) {
		super(image, width, height, z);
		x = px;
		y = py;
		accy = 0;
		this.name = name;
	}
	
	private function get_name() : String {
		return name;
	}
	
	public var name(get, null) : String;
	
	public function canBeManipulatedWith(item : UseableSprite) : Bool {
		throw "Not implemented.";
	}
	
	public function getOrder(selectedItem : UseableSprite) : OrderType {
		if (isInInventory)
			return OrderType.WontWork;
		else
			return OrderType.Take;
	}
	
	public function executeOrder(order : OrderType) : Void {
		if (order == OrderType.Take) {
			take();
		} else if (order == OrderType.InventoryItem) {
			Inventory.select(this);
		}
	}
	
	public function take() {
		isInInventory = true;
		Scene.the.removeHero(this);
		Inventory.pick(this);
	}
	
	public function loose(px : Int, py : Int) {
		x = px;
		y = py;
		isInInventory = false;
		Scene.the.addHero(this);
	}
	
	public function renderForInventory(g: Graphics, x : Int, y : Int, drawWidth : Int, drawHeight : Int) {
		if (image != null) {
			g.drawScaledSubImage(image, Std.int(animation.get() * width) % image.width, Math.floor(animation.get() * width / image.width) * height, width, height, x, y, drawWidth, drawHeight);
		}
	}
}
