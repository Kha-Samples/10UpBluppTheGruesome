package;

import dialogue.*;
import Cfg;
import haxe.macro.Expr.Var;
import localization.Keys_text;
import kha2d.Scene;
import kha2d.Sprite;

import sprites.Player;

using Lambda;

class Dialogues {
		
	static public function escMenu() {
		if (Player.current() != null) {
			Player.current().left = false;
			Player.current().right = false;
			Player.current().up = false;
		}
		var msg = "What to do?";
		var choices = new Array<Array<DialogueItem>>();
		var i = 1;
		for (l in Localization.availableLanguages.keys()) {
			if (l != Cfg.language) {
				choices.push([new StartDialogue(function() { Cfg.language = l; } )]);
				msg += '\n($i): Set language to "${Localization.availableLanguages[l]}"';
				++i;
			}
		}
		msg += '\n($i): Back"';
		choices.push( [] );
		TenUp5.the.dlg.insert( [
			new BlaWithChoices(msg, null, choices)
			, new StartDialogue(Cfg.save)
			, new StartDialogue(function () { Localization.language = Cfg.language; } )
		], true );
	}
	
	static public function startAsDetective() {
		/*PlayerBullie.the.setCurrent();
		PlayerBullie.the.dlg.insert( [
			new Action( null, ActionType.FADE_FROM_BLACK )
			, new Bla(Keys_text.START_AS_BULLY_1, PlayerBullie.the)
			, new Action( [PlayerBullie.the], ActionType.AWAKE )
			, new Bla(Keys_text.START_AS_BULLY_2, PlayerBullie.the)
			, new Bla(Keys_text.START_AS_BULLY_3, PlayerBullie.the)
		] );*/
	}
	static public function startAsMonster() {
		/*PlayerBlondie.the.setCurrent();
		PlayerBlondie.the.dlg.insert( [
			new Action( null, ActionType.FADE_FROM_BLACK )
			, new Action(null, ActionType.PAUSE )
			, new Action( [PlayerBlondie.the], ActionType.AWAKE )
			, new Bla(Keys_text.START_AS_MECHANIC, PlayerBlondie.the)
		] );*/
	}
}
