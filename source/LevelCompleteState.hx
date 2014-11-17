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
		closeCallback = this.resetPlayer;
		super();
	}

	public function resetPlayer():Void
	{
		trace('closing callback!');
		_player.scale.set(1, 1);
		//_player.angle = 0;
		FlxG.switchState(new PlayState(cast(_parentState, PlayState).getLevelNum() + 1));
	}

	override public function update():Void
	{
		_elapsed += FlxG.elapsed;
		_player.scale.set(10 * Math.exp(-_elapsed), 10 * Math.exp(-_elapsed));
		_player.angle -= FlxG.elapsed * 1800.0 * _elapsed;//Std.random(100);

		super.update();

		if (_elapsed > 2)
		{
			// Not sure why this isn't being called by the callback
			resetPlayer();
			close();
		}
	}
}
