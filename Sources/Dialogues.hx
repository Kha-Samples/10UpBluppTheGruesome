package;

import dialogue.*;
import Cfg;
import haxe.macro.Expr.Var;
import kha.Color;
import kha.Loader;
import kha2d.Scene;
import kha2d.Sprite;
import sprites.IdSystem;
import sprites.Player;
import sprites.RandomGuy;

using Lambda;

class Dialogues {
	static public function escMenu() {
		trace ('escMenu!');
		var msg = "What to do?";
		var choices = new Array<Array<DialogueItem>>();
		for (l in Localization.availableLanguages.keys()) {
			if (l != Cfg.language) {
				choices.push([new StartDialogue(function() { Localization.language = Cfg.language = l; Cfg.save(); } )]);
				msg += '\n(${choices.length}): Set language to "${Localization.availableLanguages[l]}"';
			}
		}
		choices.push([ new StartDialogue(howToPlay) ]);
		msg += '\n(${choices.length}): How to Play?';
		choices.push( [] );
		msg += '\n(${choices.length}): ' + Localization.getText(Keys_text.BACK);
		Empty.the.playerDlg.insert( [
			new BlaWithChoices(msg, null, choices)
		], true );
	}
	
	static function fadeFromBlackNoBlock()
	{
		var dlg = new Dialogue();
		Empty.the.npcDlgs.push(dlg);
		dlg.insert([
			new Action(null, ActionType.FADE_FROM_BLACK)
			, new StartDialogue(function() { Empty.the.renderOverlay = false; })
		]);
	}
	
	static public function dawn() {
		trace ('DAWN!');
		Empty.the.renderOverlay = true;
		Empty.the.playerDlg.insert([
			new Action(null, ActionType.FADE_TO_BLACK)
			, new StartDialogue(Empty.the.onNightEnd)
			, new BlaWithChoices(Keys_text.DAWN, null, [
				[
					new StartDialogue(Empty.the.onDayBegin)
					, new StartDialogue(fadeFromBlackNoBlock)
				]
				, [new StartDialogue(escMenu), new StartDialogue(dawn)]
			])
		]);
	}
	static public function dusk() {
		trace ('DUSK!');
		Empty.the.renderOverlay = true;
		Empty.the.playerDlg.insert([
			new Action(null, ActionType.FADE_TO_BLACK)
			, new StartDialogue(Empty.the.onDayEnd)
			, new BlaWithChoices(Keys_text.DUSK, null, [
				[
					new StartDialogue(Empty.the.onNightBegin)
					, new StartDialogue(fadeFromBlackNoBlock)
				]
				, [new StartDialogue(escMenu), new StartDialogue(dusk)]
			])
		]);
	}
	static function howToPlay() {
		Empty.the.playerDlg.insert([
			new BlaWithChoices(Keys_text.MENU_HOW_TO_PLAY, null, [
				[] //  OK
				, [] // Nicht OK
				, [new StartDialogue(Loader.the.loadURL.bind("http://10up.robdangero.us/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(Loader.the.loadURL.bind("http://10up.robdangero.us/mountainbrew/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(Loader.the.loadURL.bind("http://10up.robdangero.us/interdimensionalliquids/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(Loader.the.loadURL.bind("http://10up.robdangero.us/justanordinaryday/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(Loader.the.loadURL.bind("http://10upunity.robdangero.us/")), new StartDialogue(howToPlay)]
			])
		], true);
	}
	public static function startGame() {
		Empty.the.renderOverlay = true;
		Empty.the.playerDlg.set([
			new StartDialogue(howToPlay)
			, new Action(null, ActionType.FADE_TO_BLACK)
			, new StartDialogue(function() {
				Empty.the.mode = PlayerSwitch;
				kha.Configuration.setScreen(new kha.LoadingScreen());
				Loader.the.loadRoom("testlevel", Empty.the.initLevel);
			})
		]);
	}
	
	public static function showdownChatter(accused: RandomGuy) {
		
	}
	
	public static function showdownShoot(accused: RandomGuy) {
		
	}
	
	public static function showdownHesitate(accused: RandomGuy) {
		
	}
}
