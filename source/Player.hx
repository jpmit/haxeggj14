package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{
	public static inline var RUN_SPEED:Int = 500;
	public static inline var GRAVITY:Int = 7000;

	private var _isJumping:Bool = false;
	private var _startX:Int;
	private var _startY:Int;
	
	public function new(x:Int, y:Int)
	{
		
		super(x, y);

		_startX = x;
		_startY = y;
		
		loadGraphic("assets/images/player.png", true, 50, 59);

		// Left facing images
		animation.add("running", [4, 5, 6, 7, 9, 10, 11], 20, true);
		animation.add("idle", [0]);
		animation.add("jump", [2]);

		// Set size of hitbox
		setSize(30, 39);
		offset.set(10, 20);

		drag.set(RUN_SPEED * 10, RUN_SPEED * 10);
		maxVelocity.set(RUN_SPEED, 6 * RUN_SPEED);

		resetToLevelStart();
	}

	public function resetToLevelStart():Void
	{
		x = _startX;
		y = _startY;
		// Seems like flixel's collision system will be confused if we don't
		// reset last position as well.
		last.x = x;
		last.y = y;
		velocity.x = 0;
		velocity.y = 0;
		acceleration.x = 0;
		acceleration.y = 0;

		// Face right
		flipX = true;
	}

	public function jump():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.play("assets/sounds/jump.ogg");
			this.velocity.y = -this.maxVelocity.y / 2;
		}
	}

	public override function update():Void
	{
		acceleration.x = 0;
		acceleration.y = GRAVITY;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			flipX = false;
			acceleration.x = -drag.x;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			flipX = true;
			acceleration.x = drag.x;
		}

		if (this.isTouching(FlxObject.FLOOR))
		{
			if (velocity.x > 0 || velocity.x < 0)
			{	
				animation.play("running");
			}
			else if (velocity.x == 0)
			{
				animation.play("idle");
			}
			jump();
		}
		else
		{
			animation.play("jump");
		}

                
		super.update();
	}
}
