package;

import dialogue.*;
import Cfg;
import haxe.macro.Expr.Var;
import kha.Color;
import kha.math.Random;
import kha.math.Vector2;
import kha.System;
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
			new BlaWithChoices(Keys_text.MENU_HOW_TO_PLAY_BAD_VERSION, null, [
				[] //  OK
				, [ // Nicht OK
					new BlaWithChoices(Keys_text.MENU_HOW_TO_PLAY_GOOD_VERSION, null, [
						[] //  OK
						, [] // Sehr Gut!
						, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/")), new StartDialogue(howToPlay)]
						, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/mountainbrew/")), new StartDialogue(howToPlay)]
						, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/interdimensionalliquids/")), new StartDialogue(howToPlay)]
						, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/justanordinaryday/")), new StartDialogue(howToPlay)]
						, [new StartDialogue(System.loadUrl.bind("http://10upunity.robdangero.us/")), new StartDialogue(howToPlay)]
					])
				]
				, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/mountainbrew/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/interdimensionalliquids/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(System.loadUrl.bind("http://10up.robdangero.us/justanordinaryday/")), new StartDialogue(howToPlay)]
				, [new StartDialogue(System.loadUrl.bind("http://10upunity.robdangero.us/")), new StartDialogue(howToPlay)]
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
				//Loader.the.loadRoom("testlevel", Empty.the.initLevel);
				Empty.the.renderOverlay = false;
				Empty.the.initIntro();
			})
		]);
	}
	
	public static function showdownChatter(accused: RandomGuy) {
		function getChatter(): String {
			return Keys_text.YOUMONSTER_CHATTER_ + Random.getUpTo(10);
		}
		var guyindex = 0;
		function getGuy(): RandomGuy {
			var guy = RandomGuy.allguys[(guyindex++) % RandomGuy.allguys.length];
			while (guy == accused) guy = RandomGuy.allguys[(guyindex++) % RandomGuy.allguys.length];
			return guy;
		}
		
		new SpawnNpcDialog([
			new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
			, new Action(null, ActionType.PAUSE)
			, new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
		]).execute(null);
		new SpawnNpcDialog([
			new Action(null, ActionType.PAUSE)
			, new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
			, new Action(null, ActionType.PAUSE)
			, new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
			, new Bla(getChatter(), getGuy(), false)
		]).execute(null);
	}
	
	static function spawnMonster(): Void {
		var monsterGuy = RandomGuy.monsterGuy();
		Empty.the.monsterPlayer.x = monsterGuy.x;
		Empty.the.monsterPlayer.y = monsterGuy.y + monsterGuy.collisionRect().height - Empty.the.monsterPlayer.collisionRect().height - 2; // -2, just to be sure
		Scene.the.removeOther(monsterGuy);
		Scene.the.addEnemy(Empty.the.monsterPlayer);
		Empty.the.monsterPlayer.visible = true;
	}
	
	public static function showdownShoot(accused: RandomGuy) {
		spawnMonster();
		if (accused.youarethemonster)
		{
			Empty.the.mode = Empty.Mode.AgentWins;
			Empty.the.monsterPlayer.health = 0;
			// TODO: BLOOD! we need BLOOD!!!!
		}
		else
		{
			accused.sleeping = true; // TODO: KILL HIM!
			Empty.the.mode = Empty.Mode.ProfessorWins;
		}
	}
	
	public static function showdownHesitate(accused: RandomGuy) {
		spawnMonster();
		if (accused.youarethemonster)
		{
			Empty.the.mode = Empty.Mode.FischmanWins;
			Empty.the.agentPlayer.health = -77;
			// TODO: BLOOD! we need BLOOD!!!!s
		}
		else
		{
			Empty.the.mode = Empty.Mode.ProfessorWins;
			for (guy in RandomGuy.allguys) {
				guy.sleeping = true; // TODO: KILL HIM!
			}
			// TODO: spawn professor!
		}
	}
}
