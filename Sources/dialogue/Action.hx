package dialogue;

import kha.Color;
import kha.math.Vector2;
import kha2d.Scene;
import kha.Scheduler;
import kha2d.Sprite;

import sprites.Player;


class Action implements DialogueItem {
	var autoAdvance : Bool = true;
	var started : Bool = false;
	var sprites : Array<Sprite>;
	var type : ActionType;
	var counter : Int = 0;
	public var finished(default, null) : Bool = false;
	public function new(sprites: Array<Sprite>, type: ActionType) {
		this.sprites = sprites;
		this.type = type;
	}
	
	static public var finishThrow = false;
	
	@:access(dialogues.Dialogue.isActionActive) 
	public function execute(dlg: Dialogue) : Void {
		if (!started) {
			started = true;
			counter = 0;
			switch(type) {
				case ActionType.FADE_TO_BLACK:
					counter = Empty.the.overlayColor.Ab;
				case ActionType.FADE_FROM_BLACK:
					counter = Empty.the.overlayColor.Ab;
				case ActionType.PAUSE:
					counter = 0;
				case ActionType.AWAKE:
					cast(sprites[0], Player).unsleep();
			}
			return;
		} else {
			switch(type) {
				case ActionType.FADE_TO_BLACK:
					counter += 4;
					if (!Empty.the.renderOverlay || counter >= 256) {
						actionFinished(dlg);
					} else {
						Empty.the.overlayColor.Ab = counter;
					}
				case ActionType.FADE_FROM_BLACK:
					counter -= 4;
					if (!Empty.the.renderOverlay || counter <= 0) {
						Empty.the.renderOverlay = false;
						actionFinished(dlg);
					} else {
						Empty.the.overlayColor.Ab = counter;
					}
				case ActionType.PAUSE:
					++counter;
					if (counter == 60) {
						actionFinished(dlg);
					}
				case ActionType.AWAKE:
					actionFinished(dlg);
			}
		}
	}
	
	public function cancel(dlg: Dialogue) {
		switch(type) {
		case ActionType.FADE_TO_BLACK:
			Empty.the.overlayColor.Ab = 256;
		case ActionType.FADE_FROM_BLACK:
			Empty.the.overlayColor.Ab = 0;
		case ActionType.PAUSE:
		case ActionType.AWAKE:
		}
	}
	
	function actionFinished(dlg: Dialogue) {
		finished = true;
		if (autoAdvance) {
			dlg.next();
		}
	}
}
