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
	private var _gibs:FlxEmitter;
	private var _lnum:Int;
	private var _ltxt:FlxText;

	override public function new(lnum:Int):Void
	{
		_lnum = lnum;
		super();
	}

	public function getLevelNum():Int
	{
		return _lnum;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		_gibs = new FlxEmitter();
		_gibs.setXSpeed(-800, 800);
		_gibs.setYSpeed(-800, 800);
		_gibs.acceleration.y = 0;
		_gibs.setRotation(-720, 720);
		_gibs.makeParticles("assets/images/gibs.png", 500, 16, true, 0.0);

		_ltxt = new FlxText(400, 30, _lnum + ": " + Reg.levelNames[_lnum], 15);
		_ltxt.setFormat("assets/fonts/ShareTechMono-Regular.ttf", 20);
		_ltxt.scrollFactor.set(0, 0);

		level = new TiledLevel("assets/tiled/l" + _lnum + "full.tmx");

		if (_lnum == 1)
		{
			FlxG.sound.playMusic("assets/music/main.ogg");
		}

		// Add sprites in correct order
		add(background = new FlxBackdrop("assets/images/bg.png"));
		add(level.drawTiles1);
		add(level.drawTiles2);
		// This will load goal and player
		level.loadObjects(this);
		add(_gibs);
		Util.addCenteredText(this, _ltxt);

		mainCamera = new FlxCamera(0, 0, 1000, 600);
		mainCamera.setBounds(0, 0, level.width * level.tileWidth, level.height * level.tileHeight);
		// The number is how much to lag the camera
		mainCamera.follow(player, 1);
		FlxG.cameras.add(mainCamera);

		super.create();
	}

	public function addPlayer(x:Int, y:Int)
	{
		player = new Player(x, y);
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
		FlxG.sound.play("assets/sounds/goal.ogg");
		this.subState = new LevelCompleteState(this, player);
		return true;
	}

	public function playerDied():Void
	{
		trace('died!');
		
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
		FlxG.sound.play("assets/sounds/death.ogg");

	    _gibs.at(player);
		_gibs.start(true, 2.80);

		Reg.nDeaths += 1;

		// Reset player position etc.
		player.resetToLevelStart();
		// Make sure white tiles are selected
		level.reset();
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.X)
		{
			FlxG.sound.play("assets/sounds/click.ogg");
			level.switchTiles();
		}
		else
		{
			level.dontSwitchTiles();
		}
		
		level.collideWithLevel(player);
		FlxG.collide(goal, player, reachedGoal);

		if ((player.x + player.width > level.fullWidth) || (player.x < 0)
		|| (player.y + player.height > level.fullHeight) || (player.y < 0))
		{
			playerDied();
		}
	}
}
