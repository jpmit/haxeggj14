package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;

class PlayState extends FlxState
{
	public var player:Player;
	public var goal:Goal;
	private var level:TiledLevel;
	private var background:FlxBackdrop;
	private var mainCamera:FlxCamera;
	private var gibs:FlxEmitter;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		add(background = new FlxBackdrop("assets/images/bg.png"));

		gibs = new FlxEmitter();
		gibs.setXSpeed(-800, 800);
		gibs.setYSpeed(-800, 800);
		gibs.acceleration.y = 0;
		gibs.setRotation(-720, 720);
		gibs.makeParticles("assets/images/gibs.png", 500, 16, true, 0.0);

		add(gibs);

		level = new TiledLevel("assets/tiled/l1full.tmx");
		add(level.drawTiles1);
		add(level.drawTiles2);
		// This will load goal and player
		level.loadObjects(this);

		mainCamera = new FlxCamera(0, 0, 1000, 600);
		mainCamera.setBounds(0, 0, 1500, 450);
		// The number is how much to lag the camera
		mainCamera.follow(player, 1);
		FlxG.cameras.add(mainCamera);

		FlxG.sound.playMusic("assets/music/main.ogg");

		super.create();
	}

	public function addPlayer(x:Int, y:Int)
	{
		player = new Player(x, y, gibs);
		add(player);
	}

	public function addGoal(x:Int, y:Int)
	{
		goal = new Goal(x, y);
		add(goal);
	}
	
  	override public function destroy():Void
	{
		super.destroy();
	}

	public function reachedGoal(obj1:FlxObject, obj2:FlxObject):Bool
	{
		// Go to next level
		trace("reached goal!");
		return true;
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
		FlxG.collide(goal, player, reachedGoal);
		//FlxG.collide(gibs, level.collideMap);
	}
}
