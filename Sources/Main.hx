package;
import kha.System;


class Main {
	public static function main() {
		System.init("10Up", 1024, 768, function () {
			new Empty();
		});
	}
}
