package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _background:FlxBackdrop;
	private var _txtMain:FlxText;
	private var _txtPress:FlxText;	
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		_background = new FlxBackdrop("assets/images/bg.png");
		_txtMain = new FlxText(200, 200, "Two Levels", 30);
		_txtPress = new FlxText(250, 300, "Press space to start", 20);
		FlxTween.tween(_txtPress, { alpha: 0}, 0.1, { type:FlxTween.PINGPONG, loopDelay: 0.5 });
		add(_background);
		add(_txtMain);
		add(_txtPress);
		FlxG.sound.playMusic("assets/music/menu.ogg");		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justReleased.SPACE)
		{
			FlxG.sound.play("assets/sounds/start.ogg");
			new FlxTimer(1.5, function(t:FlxTimer) { FlxG.switchState(new PlayState(1)); });
		}
	}	
}
