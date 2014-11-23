package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

/**
 * ...
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	// First tiles to be drawn
	public var drawTiles1:FlxGroup;
	public var drawTiles2:FlxGroup;
	// Tilemap used for collision
	private var collidableTileLayers:Array<FlxTilemap>;
	// Five FlxTilemaps, two for each solid color, and one for spikes
	private var maps1:FlxTilemap;
	private var maps2:FlxTilemap;
	private var mape1:FlxTilemap;
	private var mape2:FlxTilemap;
	private var spikeMap:FlxTilemap;
	// The current map being used for collisions
	public var collideMap:FlxTilemap;
	// Either 1 or 2
	private var currentNum:Int;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		drawTiles1 = new FlxGroup();
		drawTiles2 = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);

		// Assume 1 layer for now (the main layer)
		var tileLayer = layers[0];

		// Create 5 tilemaps from the tiled layer: 1 solid for each of the two
		// colors, 1 'edge' for each of the two colors, and one spike
		var ts1 = new Array<Int>();
		var te1 = new Array<Int>();
		var ts2 = new Array<Int>();
		var te2 = new Array<Int>();
		var spikes = new Array<Int>();
		for (i in tileLayer.tileArray)
		{
			switch(i)
			{
				case 0: // Blank
					ts1.push(i);
					te1.push(i);
					ts2.push(i);
					te2.push(i);
					spikes.push(0);
				case 1: // Spike
					ts1.push(0);
					te1.push(0);
					ts2.push(0);
					te2.push(0);
					spikes.push(i);
				case 2: // Solid White
					ts1.push(i);
					te1.push(5);
					ts2.push(0);
					te2.push(0);
					spikes.push(0);					
				case 3: // Solid Black
					ts1.push(0);
					te1.push(0);
					ts2.push(i);
					te2.push(6);
					spikes.push(0);					
				case 4: // Both
					ts1.push(2);
					te1.push(5);
					ts2.push(3);
					te2.push(6);
					spikes.push(0);					
			}
		}
		
		var tileSheetName:String = tileLayer.properties.get("tileset");
			
		if (tileSheetName == null)
			throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
		var tileSet:TiledTileSet = null;
		for (ts in tilesets)
		{
			if (ts.name == tileSheetName)
			{
				tileSet = ts;
				break;
			}
		}
			
		if (tileSet == null)
			throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
		var imagePath 		= new Path(tileSet.imageSource);
		var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

		for (tArray in [ts1, te1, ts2, te2, spikes])
		{
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			if (tArray == te1)
			{
				mape1 = tilemap;
			}
			else if (tArray == te2)
			{
				mape2 = tilemap;
			}
			else if (tArray == ts1)
			{
				maps1 = tilemap;
			}
			else if (tArray == ts2)
			{
				maps2 = tilemap;
			}
			else if (tArray == spikes)
			{
				spikeMap = tilemap;
			}
		}
		currentNum = 2;
		switchTiles();
	}

	public function switchTiles()
	{
		drawTiles1.clear();
		drawTiles2.clear();
		drawTiles1.add(spikeMap);
		if (currentNum == 1)
		{
			currentNum = 2;
			collideMap = maps2;
			drawTiles1.add(maps2);
			drawTiles2.add(mape1);
		}
		else
		{
			currentNum = 1;
			collideMap = maps1;
			drawTiles1.add(maps1);
			drawTiles2.add(mape2);
		}
	}
	
	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;

		//trace(x, y);
		//trace(o.name.toLowerCase());
		
		// objects in tiled are aligned bottom-left (top-left in flixel)

		switch (o.name)
		{
			case "goal":
				state.addGoal(x, y);
			case "player":
				state.addPlayer(x, y);
		}
		
		/*
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "player_start":
				var player = new FlxSprite(x, y);
				player.makeGraphic(32, 32, 0xffaa1111);
				player.maxVelocity.x = 160;
				player.maxVelocity.y = 400;
				player.acceleration.y = 400;
				player.drag.x = player.maxVelocity.x * 4;
				FlxG.camera.follow(player);
				state.player = player;
				state.add(player);
				
			case "floor":
				var floor = new FlxObject(x, y, o.width, o.height);
				state.floor = floor;
				
			case "coin":
				var tileset = g.map.getGidOwner(o.gid);
				var coin = new FlxSprite(x, y, c_PATH_LEVEL_TILESHEETS + tileset.imageSource);
				state.coins.add(coin);
				
			case "exit":
				// Create the level exit
				var exit = new FlxSprite(x, y);
				exit.makeGraphic(32, 32, 0xff3f3f3f);
				exit.exists = false;
				state.exit = exit;
				state.add(exit);
		}
		*/
	}

	private function upY(obj1:FlxObject, obj2:FlxObject):Bool
	{
		// obj2 is Player
		if (obj2.y > obj1.y - obj2.height)
		{
			//			trace(obj1.touching);
			obj2.y = obj1.y - obj2.height;
			obj2.touching = FlxObject.FLOOR;
			trace(obj1.x, obj2.x, obj1.y, obj2.y);
			return true;
		}
		return false;
	}

	public function playerCollideCallback(obj1:FlxObject, obj2:FlxObject):Bool
	{
		FlxObject.separateX(obj1, obj2);

		// Need to replace this with something that lets the player 'whoosh' upwards
		//trace(obj1.type);
		//FlxObject.separateY(obj1, obj2);
		//trace(cast(obj1, FlxTilemap).widthInTiles);
		//trace(obj1.y);
		cast(obj1, FlxTilemap).overlapsWithCallback(obj2, upY);
		//obj2.y = 100;
		//obj2.y = obj1.y;
		return true;
	}
	
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		// IMPORTANT: Always collide the map with objects, not the other way around. 
		//			  This prevents odd collision errors (collision separation code off by 1 px).
		FlxG.collide(spikeMap, obj, function (obj1:FlxObject, obj2:FlxObject):Bool { cast(obj2, Player).hitSpikes(); return true;});
		return FlxG.overlap(collideMap, obj, notifyCallback, processCallback != null ? processCallback : playerCollideCallback);
		//return FlxG.overlap(collideMap, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);		
	}
}
