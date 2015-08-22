package;

import haxe.io.Bytes;
import haxe.Utf8;
import kha.audio1.Audio;
import kha.audio1.MusicChannel;
import kha.Button;
import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.Game;
import kha.graphics4.TextureFormat;
import kha.HighscoreList;
import kha.Image;
import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.Key;
import kha.Loader;
import kha.LoadingScreen;
import kha.math.Matrix3;
import kha.math.Random;
import kha.math.Vector2;
import kha.Music;
import kha.Scaler;
import kha.Scheduler;
import kha.ScreenCanvas;
import kha2d.Scene;
import kha.Score;
import kha.Configuration;
import kha.ScreenRotation;
import kha.Storage;
import kha2d.Tile;
import kha2d.Tilemap;
import sprites.Computer;

class Empty extends Game {
	private var tileColissions: Array<Tile>;
	private var map : Array<Array<Int>>;
	private var originalmap : Array<Array<Int>>;
	private var font: Font;
	private var backbuffer: Image;
	private var player: Player;
	
	public function new() {
		super("10Up");
	}
	
	public override function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Random.init(Std.int(kha.Sys.getTime() * 100));
		Loader.the.loadRoom("testlevel", initLevel);
	}

	public function initLevel(): Void {
		backbuffer = Image.createRenderTarget(1024, 768);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		tileColissions = new Array<Tile>();
		for (i in 0...512) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob("testlevel.map");
		var levelWidth: Int = blob.readS32BE();
		var levelHeight: Int = blob.readS32BE();
		originalmap = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			originalmap.push(new Array<Int>());
			for (y in 0...levelHeight) {
				originalmap[x].push(blob.readS32BE());
			}
		}
		map = new Array<Array<Int>>();
		for (x in 0...originalmap.length) {
			map.push(new Array<Int>());
			for (y in 0...originalmap[0].length) {
				map[x].push(0);
			}
		}
		var spriteCount = blob.readS32BE();
		var sprites = new Array<Int>();
		for (i in 0...spriteCount) {
			sprites.push(blob.readS32BE());
			sprites.push(blob.readS32BE());
			sprites.push(blob.readS32BE());
		}
		player = new Player();
		startGame(spriteCount, sprites);
	}
	
	public function startGame(spriteCount: Int, sprites: Array<Int>) {
		Scene.the.clear();
		Scene.the.setBackgroundColor(Color.fromBytes(255, 255, 255));
		var tilemap = new Tilemap("tileset", 32, 32, map, tileColissions);
		Scene.the.setColissionMap(tilemap);
		Scene.the.addBackgroundTilemap(tilemap, 1);
		var TILE_WIDTH: Int = 32;
		var TILE_HEIGHT: Int = 32;
		for (x in 0...originalmap.length) {
			for (y in 0...originalmap[0].length) {
				switch (originalmap[x][y]) {
				/*case 15:
					map[x][y] = 0;
					Scene.the.addEnemy(new Gumba(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 16:
					map[x][y] = 0;
					Scene.the.addEnemy(new Koopa(x * TILE_WIDTH, y * TILE_HEIGHT - 16));
				case 17:
					map[x][y] = 0;
					Scene.the.addEnemy(new Fly(x * TILE_WIDTH - 32, y * TILE_HEIGHT - 8));
				case 46:
					map[x][y] = 0;
					Scene.the.addEnemy(new Coin(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 52:
					map[x][y] = 52;
					Scene.the.addEnemy(new Exit(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 56:
					map[x][y] = 1;
					Scene.the.addEnemy(new BonusBlock(x * TILE_WIDTH, y * TILE_HEIGHT));*/
				default:
					map[x][y] = originalmap[x][y];
				}
			}
		}
		
		var computerCount : Int = 2;
		var computers : Array<Vector2> = new Array<Vector2>();
		for (i in 0...spriteCount) {
			var sprite : kha2d.Sprite = null;
			switch (sprites[i * 3]) {
			case 0:
				computers.push(new Vector2(sprites[i * 3 + 1], sprites[i * 3 + 2]));
			}
		}
		for (i in 0...computerCount) {
			if (computers.length <= 0) break;
			
			var pos : Vector2 = computers[Random.getIn(0, computers.length - 1)];
			Scene.the.addOther(new Computer(pos.x, pos.y));
			computers.remove(pos);
		}
		
		Scene.the.addHero(player);
		
		if (Keyboard.get() != null) Keyboard.get().notify(keyboardDown, keyboardUp);
		if (Gamepad.get() != null) Gamepad.get().notify(axisListener, buttonListener);
		
		Configuration.setScreen(this);
	}
	
	private static function isCollidable(tilenumber: Int): Bool {
		/*switch (tilenumber) {
		case 1: return true;
		case 6: return true;
		case 7: return true;
		case 8: return true;
		case 26: return true;
		case 33: return true;
		case 39: return true;
		case 48: return true;
		case 49: return true;
		case 50: return true;
		case 53: return true;
		case 56: return true;
		case 60: return true;
		case 61: return true;
		case 62: return true;
		case 63: return true;
		case 64: return true;
		case 65: return true;
		case 67: return true;
		case 68: return true;
		case 70: return true;
		case 74: return true;
		case 75: return true;
		case 76: return true;
		case 77: return true;
		case 84: return true;
		case 86: return true;
		case 87: return true;
		default:
			return false;
		}*/
		return tilenumber != 0;
	}
	
	public override function update() {
		super.update();
		//Scene.the.camx = Std.int(Jumpman.getInstance().x) + Std.int(Jumpman.getInstance().width / 2);
		Scene.the.camx = 0;
		Scene.the.camy = 0;
		Scene.the.update();
	}
	
	public override function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		//g.font = font;	
		Scene.the.render(g);
		g.end();
		
		startRender(frame);
		Scaler.scale(backbuffer, frame, kha.Sys.screenRotation);
		endRender(frame);
	}
	
	private function axisListener(axis: Int, value: Float): Void {
		/*switch (axis) {
			case 0:
				if (value < -0.2) {
					Jumpman.getInstance().left = true;
					Jumpman.getInstance().right = false;
				}
				else if (value > 0.2) {
					Jumpman.getInstance().right = true;
					Jumpman.getInstance().left = false;
				}
				else {
					Jumpman.getInstance().left = false;
					Jumpman.getInstance().right = false;
				}
		}*/
	}
	
	private function buttonListener(button: Int, value: Float): Void {
		/*switch (button) {
			case 0, 1, 2, 3:
				if (value > 0.5) Jumpman.getInstance().setUp();
				else Jumpman.getInstance().up = false;
			case 14:
				if (value > 0.5) {
					Jumpman.getInstance().left = true;
					Jumpman.getInstance().right = false;
				}
				else {
					Jumpman.getInstance().left = false;
					Jumpman.getInstance().right = false;
				}
			case 15:
				if (value > 0.5) {
					Jumpman.getInstance().right = true;
					Jumpman.getInstance().left = false;
				}
				else {
					Jumpman.getInstance().right = false;
					Jumpman.getInstance().left = false;
				}
		}*/
	}
	
	private function keyboardDown(key: Key, char: String): Void {
		switch (key) {
			case LEFT:
				player.left = true;
				player.right = false;
			case RIGHT:
				player.right = true;
				player.left = false;
			default:
				
		}
	}
	
	private function keyboardUp(key: Key, char: String): Void {
		switch (key) {
			case LEFT:
				player.left = false;
			case RIGHT:
				player.right = false;
			default:
				
		}
	}
}
