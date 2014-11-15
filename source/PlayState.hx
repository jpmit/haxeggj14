package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	public var player:Player;
	private var level:TiledLevel;
	private var background:FlxBackdrop;
	private var mainCamera:FlxCamera;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		add(background = new FlxBackdrop("assets/images/bg.png"));

		add(player = new Player());

		level = new TiledLevel("assets/tiled/l1full.tmx");
		add(level.drawTiles1);
		add(level.drawTiles2);		

		mainCamera = new FlxCamera(0, 0, 1000, 600);
		mainCamera.setBounds(0, 0, 1500, 450);
		// The number is how much to lag the camera
		mainCamera.follow(player, 1);
		FlxG.cameras.add(mainCamera);

		FlxG.sound.playMusic("assets/music/main.ogg");

		super.create();
	}
	
  	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.X)
		{
			FlxG.sound.play("assets/sounds/click.ogg");
			level.switchTiles();
		}
		level.collideWithLevel(player);
	}
}
