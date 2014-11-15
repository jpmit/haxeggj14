package;

import flixel.FlxSprite;

class Goal extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic("assets/images/goal.png");
		setSize(10, 10);
		offset.set(20, 20);
		// Offset doesn't seem to be working as advertised here (we shouldn't
		// have to increment y like this).
		this.y += 20;
		immovable = true;
	}
}
