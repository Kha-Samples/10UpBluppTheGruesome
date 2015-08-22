package sprites;

import dialogue.Bla;
import haxe.crypto.Adler32;
import haxe.io.Bytes;
import kha.math.Random;
import localization.Keys_text;

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
		
		this.id = "ID";
		for(i in 0...5) {
			var hex = rand.GetUpTo(16);
			this.id += (hex < 10) ? String.fromCharCode('0'.code + hex) : String.fromCharCode('A'.code + hex-10);
		}
		this.Name = name;
	}
}

class IdLogger
{
	var loggedIDs: Array<IdCard> = new Array();
	var currendDayIndex: Int = 0;
	var txtKey: String;

	public function new(txtKey: String) 
	{
		this.txtKey = txtKey;
	}
	
	public function useID(idCard: IdCard)
	{
		loggedIDs.push(idCard);
	}
	
	public function displayUsers()
	{
		var toDisplay = new Map<String, Int>();
		for (card in loggedIDs)
		{
			var id = card.Id + ": " + card.Name;
			if (toDisplay.exists(id)) toDisplay[id] += 1;
			else toDisplay[id] = 1;
		}
		
		var list : String = Localization.getText(Keys_text.IDLOGGER_DISPLAY);
		list += Localization.getText(txtKey);
		for (id in toDisplay)
		{
			list += "\n" + id + ": " + toDisplay[id];
		}
		Dialogues.the.insert([new Bla(list,null)]);
	}
	
	public function newDay()
	{
		loggedIDs.splice(0, currendDayIndex);
		currendDayIndex = loggedIDs.length;
	}
}