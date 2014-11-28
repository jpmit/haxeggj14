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
	private var _player:Player;
	private var _goal:Goal;
	private var _level:TiledLevel;
	private var _background:FlxBackdrop;
	private var _mainCamera:FlxCamera;
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

		_level = new TiledLevel("assets/tiled/l" + _lnum + "full.tmx");

		if (_lnum == 1)
		{
			FlxG.sound.playMusic("assets/music/main.ogg");
		}

		// Add sprites in correct order
		add(_background = new FlxBackdrop("assets/images/bg.png"));
		add(_level.drawTiles1);
		add(_level.drawTiles2);
		// This will add goal and player
		_level.loadObjects(this);
		add(_gibs);
		Util.addCenteredText(this, _ltxt);

		_mainCamera = new FlxCamera(0, 0, 1000, 600);
		_mainCamera.setBounds(0, 0, _level.width * _level.tileWidth, _level.height * _level.tileHeight);
		// The number is how much to lag the camera
		_mainCamera.follow(_player, 1);
		FlxG.cameras.add(_mainCamera);

		// Tutorial (text in top right)
		Tutorial.setup(this, _lnum);

		super.create();
	}

	public function addPlayer(x:Int, y:Int)
	{
		_player = new Player(x, y);
		add(_player);
	}

	public function addGoal(x:Int, y:Int)
	{
		_goal = new Goal(x, y);
		add(_goal);
	}
	
  	override public function destroy():Void
	{
		super.destroy();
	}

	public function reachedGoal(obj1:FlxObject, obj2:FlxObject):Bool
	{
		// Go to next level
		FlxG.sound.play("assets/sounds/goal.ogg");
		this.subState = new LevelCompleteState(this, _player);
		return true;
	}

	public function playerDied():Void
	{
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
		FlxG.sound.play("assets/sounds/death.ogg");

	    _gibs.at(_player);
		_gibs.start(true, 2.80);

		Reg.nDeaths += 1;

		// Reset player position etc.
		_player.resetToLevelStart();
		// Make sure white tiles are selected
		_level.reset();
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.X)
		{
			FlxG.sound.play("assets/sounds/click.ogg");
			_level.switchTiles();
		}
		else
		{
			// This will set a flag which is needed for collision handling
			_level.dontSwitchTiles();
		}
		
		_level.collideWithLevel(_player);
		FlxG.collide(_goal, _player, reachedGoal);

		if ((_player.x + _player.width > _level.fullWidth) || (_player.x < 0)
		|| (_player.y + _player.height > _level.fullHeight) || (_player.y < 0))
		{
			playerDied();
		}
	}
}
