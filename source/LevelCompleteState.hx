package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;

class LevelCompleteState extends FlxSubState
{
	private var _player:Player;
	private var _elapsed:Float;
	
	public function new(parentState:FlxState, player:Player)
	{
		_parentState = parentState;
		_player = player;
		// Total time elapsed in this substate
		_elapsed = 0;
		closeCallback = this.nextLevel;
		super();
	}

	public function nextLevel():Void
	{
		var currentLevelNum = cast(_parentState, PlayState).getLevelNum();
		if (currentLevelNum == Reg.nLevels)
		{
			FlxG.switchState(new GameCompleteState());
		}
		else
		{
			FlxG.switchState(new PlayState(cast(_parentState, PlayState).getLevelNum() + 1));
		}
	}

	override public function update():Void
	{
		_elapsed += FlxG.elapsed;
		_player.scale.set(100 * Math.exp(-8 * _elapsed), 100 * Math.exp(-8 * _elapsed));
		_player.angle -= FlxG.elapsed * 1800.0 * _elapsed;

		super.update();

		if (_elapsed > 2)
		{
			close();
			// Not sure why this isn't being called by the callback
			nextLevel();
		}
	}
}
