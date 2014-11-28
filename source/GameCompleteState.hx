package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;

// Override update of player class so we don't apply gravity etc.
class NoUpdatePlayer extends Player
{
	public override function update():Void
	{
		animation.update();
	}
}

class GameCompleteState extends FlxState
{
	private var _player:Player;
	private var _background:FlxBackdrop;
	private var _comptxt:FlxText;
	private var _thtxt:FlxText;
	private var _deathtxt:FlxText;
	private var _againtxt:FlxText;
	private var _elapsed:Float;
	
	override public function create():Void
	{
		_background = new FlxBackdrop("assets/images/bg.png");
		_comptxt = new FlxText(180, 40, "Game Complete");
		_comptxt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 60);
		_thtxt = new FlxText(180, 170, "good job, thanks for playing!");
		_thtxt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 30);
		_deathtxt = new FlxText(180, 220, "You died " + Reg.nDeaths + " times");
		_deathtxt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 30);
		_elapsed = 0;
		var again;
		if (Reg.nDeaths > 0)
		{
			again = "Try for better next time!";
		}
		else
		{
			again = "Perfect!";
		}
		_againtxt = new FlxText(180, 270, again);
		_againtxt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 30);		
		_player = new NoUpdatePlayer(30, 400);
		_player.animation.play("running");

		add(_background);
		Util.addCenteredText(this, _comptxt);
		Util.addCenteredText(this, _thtxt);
		Util.addCenteredText(this, _deathtxt);
		Util.addCenteredText(this, _againtxt);		
		add(_player);

		FlxG.sound.playMusic("assets/music/complete.ogg", false);

		super.create();
	}

	override public function update():Void
	{
		super.update();
		_player.x += FlxG.elapsed * 240;

		_elapsed += FlxG.elapsed;
		if (_elapsed > 8.5)
		{
			FlxG.switchState(new MenuState());
		}
	}
}
