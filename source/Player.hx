package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{
	public static inline var RUN_SPEED:Int = 300;
	public static inline var GRAVITY:Int = 920;

	private var _isJumping:Bool = false;
	
	public function new()
	{
		super(100, 100);
		
		loadGraphic("assets/images/player.png", true, 50, 59);

		// Left facing images
		animation.add("running", [4, 5, 6, 7, 9, 10, 11], 20, true);
		animation.add("idle", [0]);
		animation.add("jump", [2]);

		// Set size of hitbox
		setSize(30, 39);
		offset.set(10, 20);

		drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		maxVelocity.set(RUN_SPEED, 3 * RUN_SPEED);
	}

	public function jump():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			trace("pressed space");
			animation.play("jump");
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

		super.update();
	}
}
