package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

class Tutorial
{
	private static var _tutData:Map<Int, Array<Array<String>>> =
		[1 => [["Hi Kid!", "3.5", "5.5"],
			   ["Things aren't quite as simple", "as they seem around here", "7.5", "10.5"],
               ["But don't worry", "12", "15.5"],
               ["I'll help you out", "13.5", "15.5"],
			   ["Use the left and right arrow", "keys to run around", "18", "20"],
               ["Or your Gamepad", "22", "25.5"],
			   ["If it works!", "23.5", "25.5"],
               ["You need to get to", "the portal, kid", "28", "31"],
			   ["That's the glowing", "orange fireball", "34", "36.5"],
			   ["You'll need to use a technique", "I call 'switching'", "39", "42"],
               ["Press the 'X' key", "on your keyboard", "(or either shoulder button",
                "on your gamepad)", "44", "47"],
               ["Watch out for spikes", "though kid", "48", "50"],
               ["This is a video game", "after all", "52", "54.5"]
			  ],
		 2 => [["Did I mention you can jump?", "1", "3"],
               ["Press SPACEBAR to jump", "(or the 'A' button", " on your gamepad)", "6", "8"],
               ["Just don't jump", "off the screen", "10", "12"],
              ],
		 3 => [["There could be something", "interesting here", "1", "3"],
               ["Try shifting while", "in a hollow box", "10", "14"],
               ["Two shifts", "in close succession...", "20", "28"],
               ["You can do it kid", "50", "55"],
		       ["Jump towards the", "top of the tower", "57", "67"],
               ["And rapidly switch twice", "62", "67"]
		      ],
         5 => [["It's going to get harder", "from here kid", "1", "3"],
               ["They tell me there are", "12 levels in total", "5", "7"],
               ["But then", "8", "11.5"],
               ["Who am I to know?", "10", "11.5"],
               ["Quite Frankly, it's the", "Global Gam Jam at the moment", "13", "15"],
		       ["And I'm at least half asleep", "16", "20"],
		       ["Probably more like 90% actually", "18", "20"]
		      ],
         6 => [["Good luck kid", "1", "3.5"],
               ["You're on your own now", "1.5", "3.5"],
               ["I'm off to sleep", "5", "6.5"],
               ["I never did figure out", "8", "11"],
               ["Why I called you kid", "9.5", "11"]
		      ]
		];
	private static var _tposx = 580;
	private static var _tposy = 150;
	
	public static function setup(pstate:PlayState, lnum:Int):Void
	{
		if (_tutData.exists(lnum))
		{
			// Most recent time at which text disappeared
			var lastTime:Float = 0;
			// Current lines of text
			var currentLines = 0;
			for (t in _tutData[lnum])
			{
				// Number of lines of text for this dialogue
				var nlines = t.length - 2;
				var start = Std.parseFloat(t[nlines]);
				var end = Std.parseFloat(t[nlines + 1]);
				var txtArray = new Array();
				// Figure out if we are adding to existing dialogue
				if (start > lastTime)
				{
					currentLines = 0;
				}
					
				for (i in 0...nlines)
				{
					var txt = new FlxText(_tposx, _tposy + 30 * (i + currentLines), t[i]);
					txt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 22);
					txt.scrollFactor.set(0, 0);
					txtArray.push(txt);
				}
				currentLines += nlines;
				lastTime = end;
				new FlxTimer(start, function(timer:FlxTimer) { showText(pstate, txtArray); });
				new FlxTimer(end, function(timer:FlxTimer) { hideText(pstate, txtArray); });
			}
		}
	}

	public static function showText(pstate:PlayState, txtArray:Array<FlxText>)
	{
		FlxG.sound.play("assets/sounds/text.ogg");
		for (txt in txtArray)
		{
			pstate.add(txt);
		}
	}

	public static function hideText(pstate:PlayState, txtArray:Array<FlxText>)
	{
		for (txt in txtArray)
		{
			pstate.remove(txt);
		}
	}
}
