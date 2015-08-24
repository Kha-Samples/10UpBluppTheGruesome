package;

import dialogue.*;
import Cfg;
import haxe.macro.Expr.Var;
import kha.Color;
import kha2d.Scene;
import kha2d.Sprite;
import sprites.IdSystem;
import sprites.Player;

using Lambda;

class Dialogues {
	static public function escMenu() {
		trace ('escMenu!');
		var msg = "What to do?";
		var choices = new Array<Array<DialogueItem>>();
		var i = 1;
		for (l in Localization.availableLanguages.keys()) {
			if (l != Cfg.language) {
				choices.push([new StartDialogue(function() { Localization.language = Cfg.language = l; Cfg.save(); } )]);
				msg += '\n($i): Set language to "${Localization.availableLanguages[l]}"';
				++i;
			}
		}
		msg += '\n($i): ' + Localization.getText(Keys_text.BACK);
		choices.push( [] );
		Empty.the.playerDlg.insert( [
			new BlaWithChoices(msg, null, choices)
		], true );
	}
	
	static public function dawn() {
		trace ('DAWN!');
		Empty.the.mode = PlayerSwitch;
		Empty.the.renderOverlay = true;
		Empty.the.playerDlg.insert([
			new Action(null, ActionType.FADE_TO_BLACK)
			, new StartDialogue(Empty.the.onNightEnd)
			, new BlaWithChoices(Keys_text.DAWN, null, [
				[
					new StartDialogue(Empty.the.onDayBegin)
					, new Action(null, ActionType.FADE_FROM_BLACK)
					, new StartDialogue(function() {
						trace ('after FADE_FROM_BLACK');
						Empty.the.renderOverlay = false;
						Empty.the.mode = Game;
					})
				]
				, [new StartDialogue(escMenu), new StartDialogue(dawn)]
			])
		]);
	}
	static public function dusk() {
		trace ('DUSK!');
		Empty.the.mode = PlayerSwitch;
		Empty.the.renderOverlay = true;
		Empty.the.playerDlg.insert([
			new Action(null, ActionType.FADE_TO_BLACK)
			, new StartDialogue(Empty.the.onDayEnd)
			, new BlaWithChoices(Keys_text.DUSK, null, [
				[
					new StartDialogue(Empty.the.onNightBegin)
					, new Action(null, ActionType.FADE_FROM_BLACK)
					, new StartDialogue(function() {
						trace ('after FADE_FROM_BLACK');
						Empty.the.renderOverlay = false;
						Empty.the.mode = Game;
					})
				]
				, [new StartDialogue(escMenu), new StartDialogue(dusk)]
			])
		]);
	}
}
