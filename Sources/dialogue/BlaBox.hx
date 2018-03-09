package dialogue;

import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Loader;
import kha.graphics2.Graphics;
import kha2d.Scene;
import kha2d.Sprite;

import sprites.Player;

class BlaBox {
	static public var boxes(default, null) : Array<BlaBox> = new Array();
	private var padding = 15;
	private var maxWidth = 800;
	private var font: Font;
	private var width : Float;
	private var height : Float;
	private var speaker: Sprite;
	private var text: Array<String> = null;
	public var isThought = false;
	public var persistent : Bool;
	public var isInput : Bool = false;
	
	public function new(text: String, speaker: Sprite = null, persistent: Bool = false) {
		this.speaker = speaker;
		this.persistent = persistent;
		
		setText(text);
		
		if (speaker != null && speaker == Player.current()) {
			//Server.the.sendText(text);
		}
	}
	
	public function pointAt(sprite: Sprite): Void {
		speaker = sprite;
	}
	
	public function setText(text: String, minWidth: Float = -1, minHeight: Float = -1): Void {
		if (text != null) {
			if (font == null) font = Loader.the.loadFont("LiberationSans", FontStyle.Default, 20);
			var maxWidth = this.maxWidth - 2 * padding;
			this.text = new Array();
			width = minWidth < 0 ? 200 : minWidth;
			text = Localization.getText(text);
			var lines = text.split("\n");
			for (line in lines) {
				var tw = font.stringWidth(line);
				if (tw > maxWidth) {
					var words = Lambda.list(line.split(" "));
					while (!words.isEmpty()) {
						line = words.pop();
						tw = font.stringWidth(line);
						width = Math.max(width, tw);
						var nextWord = words.pop();
						while (nextWord != null && (tw = font.stringWidth(line + " " + nextWord)) <= maxWidth) {
							width = Math.max(width, tw);
							line += " " + nextWord;
							nextWord = words.pop();
						}
						this.text.push(line);
						if (nextWord != null) {
							words.push(nextWord);
						}
					}
				} else {
					width = Math.max(width, tw);
					this.text.push(line);
				}
			}
			width += 2 * padding;
			height = Math.max(minHeight, (font.getHeight() * this.text.length) + 2 * padding);
		} else {
			this.text = null;
		}
		
		if (!persistent) {
			if (text == null) {
				boxes.remove(this);
			} else {
				var numWords = 0;
				for (line in this.text) {
					numWords += line.split(" ").length;
				}
				var time : Float = text.length / 7.15673;
				//trace (time);
				time = Math.min(time,  numWords * 0.8);
				//trace(numWords * 0.8);
				//time = 1; // TODO: FIXME!
				kha.Scheduler.addTimeTask( function() { 
					boxes.remove(this); 
				}, Math.max(time, 1));
			}
		}
	}
	
	public function render(g: Graphics, x: Float = -1, y: Float = -1): Void {
		if (text == null) return;
		
		var sx : Float = -1;
		var sy : Float = -1;
		if (speaker != null) {
			sx = speaker.x + (0.5 * speaker.collisionRect().width) - Scene.the.screenOffsetX;
			sy = speaker.y - 15 - Scene.the.screenOffsetY;
		}
		
		if (x < 0) {
			x = (speaker == null) ? (0.5 * (kha.Game.the.width - width)) : sx - 0.3 * width;
			
			if (x + width > kha.Game.the.width) {
				x -= 30 + x + width - kha.Game.the.width;
			}
			if (x < 0) {
				x = 30;
			}
		}
		
		if (y < 0) {
			y = (speaker == null) ? (0.3 * (kha.Game.the.height - height)) : sy - 30 - height;
			if (y < 0) {
				sy += speaker.height + 15;
				y = sy + 30;
			}
		}
		
		g.color = Color.White;
		g.fillRect(x, y, width, height);
		g.color = Color.Black;
		g.drawRect(x, y, width, height, 5);
		g.color = Color.White;
		if (speaker != null) {
			if (sy < y) {
				g.fillTriangle(sx - 10, y + 0.5 * padding, sx + 10, y + 0.5 * padding, sx, sy);
				g.color = Color.Black;
				g.drawLine(sx - 10, y + 0.5 * padding, sx, sy, 3);
				g.drawLine(sx + 10, y + 0.5 * padding, sx, sy, 3);
			} else {
				g.fillTriangle(sx - 10, y + height - 0.5 * padding, sx + 10, y + height - 0.5 * padding, sx, sy);
				g.color = Color.Black;
				g.drawLine(sx - 10, y + height - 0.5 * padding, sx, sy, 3);
				g.drawLine(sx + 10, y + height - 0.5 * padding, sx, sy, 3);
			}
		} else {
			g.color = Color.Black;
		}
		g.font = font;
		
		var tx: Float = x + padding;
		var ty: Float = y + padding;
		
		var lastLine = "";
		for (line in text) {
			lastLine = line;
			g.drawString(line, tx, ty);
			ty += font.getHeight();
		}
		if (isInput) {
			if ((Std.int(kha.Scheduler.time() * 1.67) % 2) == 0) {
				tx += font.stringWidth(lastLine) + 1;
				g.drawLine(tx, ty, tx, ty - font.getHeight(), 2);
			}
		}
	}
}
