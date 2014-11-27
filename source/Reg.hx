package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	public static var levelNames:Map<Int, String> =
		[1 => "nowhere to go",
		 2 => "jump",
         3 => "be careful please",
		 4 => "you can do it (kid)",
         5 => "raise to the roof",
		 6 => "hedgehog",
         7 => "tired disco",
         8 => "the tunnel",
         9 => "sparsity",
         10 => "hi lo",
         11 => "halfpipe",
         12 => "finale",
		];
	public static var nLevels = Lambda.count(levelNames);
	public static var nDeaths = 0;
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}