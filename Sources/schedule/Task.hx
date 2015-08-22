package schedule;

import kha2d.Sprite;

class Task {
	private var sprite: Sprite;
	private var done: Bool;
	
	public function new(sprite: Sprite) {
		this.sprite = sprite;
		done = false;
	}
	
	public function update(): Void {
		
	}
	
	public function isDone(): Bool {
		return done;
	}
}
