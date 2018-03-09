package;

import haxe.io.Path;
import haxe.xml.Parser;

#if !macro

import kha.Assets;
import kha.Blob;

#end

class Localization
{
#if !macro
	static var fallbackLanguage : String = "en";
	static public var language : String;
	static public var availableLanguages(default, null) : Map<String, String>;
	static var texts : Map <String, Map <String, String>> = null;
	
	static public function init(initFile : Blob, startingLanguage = "en") {
		availableLanguages = new Map();
		var xml = Parser.parse(initFile.toString());
		var languages = xml.firstElement();
		if (languages.nodeName.toLowerCase() == "languages") {
			for (language in languages.elements()) {
				var key = language.nodeName.toLowerCase();
				availableLanguages[key] = language.firstChild().nodeValue;
			}
		}
		
		if (availableLanguages.exists(startingLanguage)) {
			language = startingLanguage;
		} else {
			language = availableLanguages.keys().next();
		}
		if (!availableLanguages.exists(fallbackLanguage)) {
			fallbackLanguage = availableLanguages.keys().next();
		}
	}
	
	static public function load(filename : String, replace = false) {
		if (texts == null || replace) {
			texts = new Map();
		}
		
		var xml = Parser.parse(Reflect.field(Assets.blobs, filename + "_xml").toString());
		for (item in xml.elements()) {
			var key = item.nodeName;
			if (key == "DefaultLanguage") {
				fallbackLanguage = item.firstChild().nodeValue.toLowerCase();
			} else {
				texts[key] = new Map();
				for (language in item.elements()) {
					var l = language.nodeName.toLowerCase();
					texts[key][l] = StringTools.replace(StringTools.replace(StringTools.replace(language.firstChild().nodeValue, "\r\n", "\n"),"\r","\n"), "\t", "");
				}
			}
		}
	}
	
	static public function getText(key : String, paramKeys: Array<String> = null) {
		var text = key;
		if (texts != null) {
			var t = texts[key];
			if (t != null) {
				if (t.exists(language)) {
					text = t[language];
				} else if (t.exists(fallbackLanguage)) {
					text = t[fallbackLanguage];
				}
			}
			var front: Int = text.indexOf("{");
			var back: Int = front >= 0 ? text.indexOf("}", front+1) : -1;
			var fix: Int = front;
			while (back >= 0)
			{
				key = text.substring(front + 1, back);
				t = texts[key];
				if (t != null)
				{
					if (t.exists(language)) {
						text = StringTools.replace(text, text.substring(front, back+1), t[language]);
					} else if (t.exists(fallbackLanguage)) {
						text = StringTools.replace(text, text.substring(front, back+1), t[fallbackLanguage]);
					} else {
						text = StringTools.replace(text, text.substring(front, back+1), key);
					}
					front = text.indexOf("{", fix);
					back = front >= 0 ? text.indexOf("}", front + 1) : -1;
				}
				else
				{
					front = text.indexOf("{", fix+1);
					back = front >= 0 ? text.indexOf("}", front+1) : -1;
				}
				fix = front;
			}
		}
		if (paramKeys != null)
		{
			for (i in 0...paramKeys.length)
			{
				text = StringTools.replace(text, '{$i}', getText(paramKeys[i]));
			}
		}
		return text;
	}
#end

	macro static public inline function buildKeys(file: String, assetName: String) : haxe.macro.Expr {
		// trace ('Building keys for "$file"');
		assetName = assetName.substr(0, assetName.length - 4);
		var f = haxe.macro.Context.getPosInfos(haxe.macro.Context.currentPos()).file;
		var dir = Path.directory(f) + "/";
		var name = 'Keys_$assetName';
		var contend = new StringBuf();
		contend.add("package;\n\n");
		contend.add('class $name {\n');
		
		var xml = Parser.parse(sys.io.File.getContent(file));
		for (item in xml.elements()) {
			var key = item.nodeName;
			if (key != "DefaultLanguage") {
				contend.add('\tstatic public var ${key.toUpperCase()} = "$key";\n');
			}
		}
		contend.add("}");
		
		sys.io.File.saveContent(dir + '/$name.hx', contend.toString());
		
		return haxe.macro.Context.parse('Localization.load("$assetName")' , haxe.macro.Context.currentPos());
	}
}