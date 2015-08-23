package sprites;

import dialogue.Bla;
import haxe.crypto.Adler32;
import haxe.io.Bytes;
import kha.Image;
import kha.math.Random;
import kha2d.Direction;
import sprites.IdSystem.IdLogger;

class IdCard
{
	public var Id(default, null): String;
	public var Name(get, null): String;
	
	function get_Name(): String { return Localization.getText(Name); } 
	
	public function new(name: String)
	{
		var rand = new Random(Adler32.make(Bytes.ofString(name)));
		var skip = Random.getUpTo(10);
		for (i in 0...skip) rand.Get();
		
		this.Id = "ID";
		for(i in 0...5) {
			var hex = rand.GetUpTo(16);
			this.Id += (hex < 10) ? String.fromCharCode('0'.code + hex) : String.fromCharCode('A'.code + hex-10);
		}
		this.Name = name;
	}
}

class IdLogger
{
	var loggedIDs: Array<IdCard> = new Array();
	var currendDayIndex: Int = 0;
	var txtKey: String;

	public function new(nameTxtKey: String) 
	{
		this.txtKey = nameTxtKey;
	}
	
	public function useID(idCard: IdCard)
	{
		loggedIDs.push(idCard);
	}
	
	function countById(users: Array<IdCard>): Map<String, Int>
	{
		var toDisplay = new Map<String, Int>();
		for (card in users)
		{
			var id = card.Id + ": " + card.Name;
			if (toDisplay.exists(id)) toDisplay[id] += 1;
			else toDisplay[id] = 1;
		}
		return toDisplay;
	}
	public function displayUsers(): String
	{
		var toDisplay = countById(loggedIDs);
		var list : String = Localization.getText(Keys_text.IDLOGGER_DISPLAY, [txtKey]);
		for (id in toDisplay.keys())
		{
			list += "\n" + id + ": " + toDisplay[id];
		}
		return list;
	}
	
	public function newDay()
	{
		loggedIDs.splice(0, currendDayIndex);
		currendDayIndex = loggedIDs.length;
	}
}

interface IdCardOwner
{
	var IdCard(default, never): IdCard;
}


class IdLoggerSprite extends InteractiveSprite
{
	public var idLogger: IdLogger;
	
	public function new(nameTxtKey: String, image:Image, width:Int=0, height:Int=0, z:Int=1) {
		super(image, width, height, z);
		idLogger = new IdLogger(nameTxtKey);
		isUseable = true;
	}
	
	override public function useFrom(dir: Direction, user: Dynamic): Bool
	{
		if (Std.is(user, sprites.IdCardOwner))
		{
			var owner: IdCardOwner = cast user;
			
			idLogger.useID(owner.IdCard);
			
			return true;
		}
		return false;
	}
}