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
import kha.math.FastMatrix3;
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
import kha2d.Sprite;
import kha2d.Tile;
import kha2d.Tilemap;
import localization.*;
import sprites.Agent;
import sprites.Computer;
import sprites.Fishman;
import sprites.InteractiveSprite;
import sprites.Player;
import sprites.RandomGuy;

import dialogue.*;

enum Mode {
	StartScreen;
	Game;
	Menu;
}

class Empty extends Game {
	public static var the(default, null): Empty;
	private var tileColissions: Array<Tile>;
	private var map : Array<Array<Int>>;
	private var originalmap : Array<Array<Int>>;
	private var font: Font;
	private var backbuffer: Image;
	private var monsterPlayer : Player;
	private var agentPlayer : Player;
	private var interactiveSprites: Array<InteractiveSprite>;
	
	public var mode(default, null) : Mode;
	
	public var renderOverlay : Bool;
	public var overlayColor : Color;
	public var dlg : Dialogue;
	
	private var elevatorOffset: Float = 10;
	
	public function new() {
		super("10Up");
		the = this;
		dlg = new Dialogue();
	}
	
	public override function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Random.init(Std.int(kha.Sys.getTime() * 100));
		Loader.the.loadRoom("titlescreen", initFirst);
	}
	
	function initFirst() {
		backbuffer = Image.createRenderTarget(1024, 768);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		
		Configuration.setScreen(this);
		
		font = Loader.the.loadFont("arial", FontStyle.Default, 34);
		Localization.init("localizations");
		
		Cfg.init();
		
		if (Cfg.language == null) {
			var msg = "Please select your language:";
			var choices = new Array<Array<DialogueItem>>();
			var i = 1;
			for (l in Localization.availableLanguages.keys()) {
				choices.push([new StartDialogue(function() { Cfg.language = l; } )]);
				msg += '\n($i): ${Localization.availableLanguages[l]}';
				++i;
			}
			dlg.set( [
				new BlaWithChoices(msg, null, choices)
				, new StartDialogue(Cfg.save)
				, new StartDialogue(initTitleScreen)
			] );
		}
		else
		{
			initTitleScreen();
		}
	}
	
	@:access(dialogue.BlaBox) 
	function initTitleScreen() {
		mode = StartScreen;
		
		Localization.language = Cfg.language;
		Localization.buildKeys("../Assets/text.xml","text");
		
		var logo = new Sprite( Loader.the.getImage( "10up-logo" ) );
		logo.x = 0.5 * width - 0.5 * logo.width;
		logo.y = 0.5 * height - 0.5 * logo.height;
		Scene.the.clear();
		Scene.the.setBackgroundColor(Color.fromBytes(0, 0, 0));
		Scene.the.addHero( logo );
		Configuration.setScreen(this);
		
		if (Keyboard.get() != null) Keyboard.get().notify(keyboardDown, keyboardUp);
		if (Gamepad.get() != null) Gamepad.get().notify(axisListener, buttonListener);
	}

	public function initLevel(): Void {
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
		ElevatorManager.init(new ElevatorManager());
		startGame(spriteCount, sprites);
	}
	
	public function startGame(spriteCount: Int, sprites: Array<Int>) {
		mode = Game; 
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
		
		var computerCount : Int = 4;
		var computers : Array<Vector2> = new Array<Vector2>();
		var elevatorPositions : Array<Vector2> = new Array<Vector2>();
		interactiveSprites = new Array();
		for (i in 0...spriteCount) {
			var sprite : kha2d.Sprite = null;
			switch (sprites[i * 3]) {
			case 0:
				monsterPlayer = new Fishman(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				agentPlayer = new Agent(sprites[i * 3 + 1], sprites[i * 3 + 2]);
			case 1:
				computers.push(new Vector2(sprites[i * 3 + 1], sprites[i * 3 + 2]));
			case 2:
				elevatorPositions.push(new Vector2(sprites[i * 3 + 1], sprites[i * 3 + 2]));
			}
		}
		for (i in 0...computerCount) {
			if (computers.length <= 0) break;
			
			var pos : Vector2 = computers[Random.getIn(0, computers.length - 1)];
			var computer = new Computer(pos.x, pos.y);
			interactiveSprites.push(computer);
			Scene.the.addOther(computer);
			computers.remove(pos);
		}
		var elevatorSprites = ElevatorManager.the.setPositions(elevatorPositions);
		for (sprite in elevatorSprites) {
			Scene.the.addOther(sprite);
		}
		
		var guy = new RandomGuy(monsterPlayer);
		guy.x = 64;
		guy.y = 64;
		Scene.the.addOther(guy);
		
		setMainPlayer(monsterPlayer);
		
		Configuration.setScreen(this);
	}
	
	private function setMainPlayer(player : Player) {
		if (Player.current() != null) {
			Scene.the.removeHero(Player.current());
		}
		player.setCurrent();
		Scene.the.addHero(player);
	}
	
	private static function isCollidable(tilenumber: Int): Bool {
		switch (tilenumber) {
		/*case 1: return true;
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
		case 62: return true;*/
		case 63: return true;
		case 64: return true;
		case 65: return true;
		case 66: return true;
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
		}
	}
	
	public override function update() {
		super.update();
		
		var player = Player.current();
		if (player != null) {
			Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
			Scene.the.camy = Std.int(player.y + player.height + 80 - 0.5 * height);
		}
		Scene.the.update();
		
		dlg.update();
	}
	
	public override function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		switch (mode) {
		/*case GameOver:
			var congrat = Loader.the.getImage("gameover");
			g.drawImage(congrat, width / 2 - congrat.width / 2, height / 2 - congrat.height / 2);
		case Congratulations:
			var congrat = Loader.the.getImage("congratulations");
			g.drawImage(congrat, width / 2 - congrat.width / 2, height / 2 - congrat.height / 2);*/
		case Game, Menu:
			Scene.the.render(g);
			/*g.transformation = FastMatrix3.identity();
			g.color = Color.Black;
			for (door in Level.the.doors) {
				if (!door.opened && door.health > 0) {
					if (door.x < Player.current().x) {
						var doorXscreen = door.x - Scene.the.screenOffsetX; 
						if (doorXscreen > 0 && doorXscreen < width) {
							g.fillRect(0, 0, doorXscreen, height);
						}
					} else {
						var doorXscreen = door.x + 0.5 * door.width - Scene.the.screenOffsetX; 
						if (doorXscreen > 0 && doorXscreen < width) {
							g.fillRect(doorXscreen, 0, width - doorXscreen, height);
						}
					}
				}
			}*/
			//if (Player.current() != null) drawPlayerInfo(g);
		case StartScreen:
			Scene.the.render(g);
			g.font = font;
			g.color = Color.Magenta;
			g.pushTransformation(g.transformation.multmat(FastMatrix3.scale(3, 3)));
			g.drawString("MONSTER", 180 + 10 * Math.cos(0.3 * kha.Sys.getTime()), 140 + 10 * Math.sin(0.6 * kha.Sys.getTime()));
			g.popTransformation();
			var b = Math.round(100 + 125 * Math.pow(Math.sin(0.5 * kha.Sys.getTime()),2));
			g.color = Color.fromBytes(b, b, b);
			var str = Localization.getText(Keys_text.CLICK_TO_START);
			g.drawString(str, 0.5 * (width - font.stringWidth(str)), 650);
		}
		g.end();
		
		g.transformation = FastMatrix3.identity();
		for (box in BlaBox.boxes) {
			g.color = Color.White;
			box.render(g);
		}
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
		if (mode != Game) return;
		
		switch (key) {
			case LEFT:
				Player.current().left = true;
				Player.current().right = false;
			case RIGHT:
				Player.current().right = true;
				Player.current().left = false;
			case UP:
				Player.current().setUp();
			default:
				if (char == "f") setMainPlayer(monsterPlayer);
				else if (char == "g") setMainPlayer(agentPlayer);
		}
	}
	
	private function keyboardUp(key: Key, char: String): Void {
		switch (mode) {
		case Game:
			switch (key) {
			case LEFT:
				Player.current().left = false;
			case RIGHT:
				Player.current().right = false;
			case UP:
				/*if (Math.abs(Player.current().x-elevator.x)<elevatorOffset && elevator.canMove) {
				elevator.goup();
				}
				else {*/
					Player.current().up = false;
				//}
			case DOWN:
				/*if (Math.abs(Player.current().x-elevator.x)<elevatorOffset && elevator.canMove) {
				elevator.godown();	
				}*/
			case Key.CHAR:
				switch(char) {
				case "e":
					Player.current().use();
				}
			default:
				
			}
		case StartScreen:
			switch (key) {
			case Key.ESC:
				Dialogues.escMenu();
			default:
				dlg.set([new Action(null, ActionType.FADE_TO_BLACK)
						, new StartDialogue(function() {
							Configuration.setScreen(new LoadingScreen());
							Loader.the.loadRoom("testlevel", initLevel);
						}) ]);
			}
		default:
			switch (key) {
			case Key.ESC:
				Dialogues.escMenu();
			default:
			}
		}
	}
}
