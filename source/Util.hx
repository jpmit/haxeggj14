package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * Some general utility functions.
 */
class Util
{
	public static function addCenteredText(state:FlxState, txt:FlxText):Void
	{
		txt.x = FlxG.width / 2 - txt.fieldWidth / 2;
		state.add(txt);
	}
}
