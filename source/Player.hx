package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite
{
	public static inline var RUN_SPEED:Int = 300;
	public static inline var GRAVITY:Int = 920;

	private var _isJumping:Bool = false;
	private var _isAlive:Bool = true;
	private var _gibs:FlxEmitter;
	
	public function new(x:Int, y:Int, gibs:FlxEmitter)
	{
		super(x, y);
		
		loadGraphic("assets/images/player.png", true, 50, 59);

		// Left facing images
		animation.add("running", [4, 5, 6, 7, 9, 10, 11], 20, true);
		animation.add("idle", [0]);
		animation.add("jump", [2]);

		// Set size of hitbox
		setSize(30, 39);
		offset.set(10, 20);

		drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		maxVelocity.set(RUN_SPEED, 4 * RUN_SPEED);

		// Gibs
		_gibs = gibs;
	}

	public function resetPosition():Void
	{
		x = 100;
		y = 100;
	}

	public function jump():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			trace("pressed space");
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

	public function hitSpikes()
	{
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
		
		FlxG.sound.play("assets/sounds/death.ogg");
		_isAlive = false;
		_gibs.at(this);
		_gibs.start(true, 2.80);
		// Goodbye
		resetPosition();
	}
}
