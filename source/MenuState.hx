package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

class MenuState extends FlxState
{
	private var _background:FlxBackdrop;
	private var _txtMain:FlxText;
	private var _txtPress:FlxText;	
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		_background = new FlxBackdrop("assets/images/bg.png");
		_txtMain = new FlxText(100, 200, "Two Levels");
		_txtMain.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 100);
		   
		_txtPress = new FlxText(250, 350, "Press space to start");
		_txtPress.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 30);
		FlxTween.tween(_txtPress, { alpha: 0}, 0.1, { type:FlxTween.PINGPONG, loopDelay: 0.5 });
		
		add(_background);
		Util.addCenteredText(this, _txtMain);
		Util.addCenteredText(this, _txtPress);
		FlxG.sound.playMusic("assets/music/menu.ogg");		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

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
