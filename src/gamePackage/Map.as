package gamePackage {
	
	import goalPackage.*;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Map extends Grid {
		public static const MUSICPATH:String = "../Music/";
		public static const MUSIC_FILEEXTENSION = ".mp3";
		public static const MAPPATH:String = "../Maps/";
		public static const LAYOUT_FOLDER:String = "layouts/";
		public static const LAYOUT_FILEEXTENSION:String = ".txt";
		public static const MAPFOLDER_PREFIX:String = "map";
		public static const BASETILE:String = "base";
		public static const TILE_FILEEXTENSION:String = ".png";
		public static const BACKGROUND:String = "background.png";
		public static const OTHERPATH:String = "../Other/";
		public static const TUTORIAL:String = "tutorial.png";
		public static const GOALNAMES:String = "goals.txt";
		
		private var path;
		private var file:URLLoader;
		
		protected var logicGoal:LogicGoal;
		
		protected var music:Sound;
		protected var channel:SoundChannel;
		
		private var map:uint;
		private var level:uint;
		private var layout:uint;

		public function Map(document:main, x:uint, y:uint, rows:uint, cols:uint, map:uint, level:uint, layout:uint = 1) {
			super(document, rows, cols, false);
			this.x = x;
			this.y = y;
			
			this.map = map;
			this.level = level;
			this.layout = layout;
			
			this.path = MAPPATH + MAPFOLDER_PREFIX + map + "/";
			
			this.music = new Sound(new URLRequest(MUSICPATH + map + MUSIC_FILEEXTENSION));
			
			document.blockInput();
			
			restart(false);
			removeChild(character);
		}
		
		override public function close():void {
			super.close();
			
			if (channel) {
				channel.stop();
			}
		}
		
		override public function restart(removeChildren:Boolean = true):void {
			super.restart(removeChildren);
			
			if (removeChildren) {
				channel.stop();
			}
			
			this.goal = new LogicGoal(this, rows, cols);
			this.logicGoal = goal as LogicGoal;
			
			this.file = new URLLoader();
			file.addEventListener(Event.COMPLETE, loadMap);
			file.load(new URLRequest(MAPPATH + LAYOUT_FOLDER + level + "/" + layout + LAYOUT_FILEEXTENSION));
		}
		
		private function loadMap(e:Event = null) {
			var structure:Array = file.data.split("\n");
			var image:Loader;
			
			image = new Loader();
			image.load(new URLRequest(path + BACKGROUND));
			addChild(image);
			
			for (var y:Number = 0; y < rows; y++) {
				var row:Array = structure[y].split("");
				for (var x in row.slice(0, cols)) {
					image = new Loader();
					image.load(new URLRequest(path + BASETILE + TILE_FILEEXTENSION));
					image.x = x * Grid.DX;
					image.y = y * Grid.DY;
					addChild(image);
					
					if (row[x].match(/[a-z1-9X]/) != null) {
						image = new Loader();
						image.load(new URLRequest(path + row[x] + TILE_FILEEXTENSION));
						if (row[x].match(/[a-z]/) != null) {
							block[x][y] = true;
						} else if (row[x].match(/[1-9]/) != null) {
							logicGoal.setPos(x, y, row[x]);
						} else if (row[x].match(/X/) != null) {
							character.posX = x;
							character.posY = y;
							character.updatePosition(false);
						}
						image.x = x * Grid.DX;
						image.y = y * Grid.DY;
						addChild(image);
					}
				}
			}
			
			addChild(character);
			
			image = new Loader();
			image.load(new URLRequest(OTHERPATH + TUTORIAL));
			document.addChild(image);
			
			document.setClickGoButtonOnce(function():void {
				document.removeChild(image);
				
				logicGoal.input = structure.slice(rows);
				file = new URLLoader();
				file.addEventListener(Event.COMPLETE, loadGoalNames);
				file.load(new URLRequest(path + GOALNAMES));
			}, this);
			
			channel = music.play(0, 10000, new SoundTransform(0.15, 0));
		}
		
		private function loadGoalNames(e:Event = null) {
			var goalNames:Array = file.data.split("\n");
			logicGoal.goalNames = goalNames;
			logicGoal.parse();
			logicGoal.x = cols * Grid.DX + 100;
			logicGoal.y = rows * Grid.DY / 2;
			addChild(logicGoal);
			addMessage(logicGoal.toString(), 40, function():void {
				document.allowInput();
				document.nextPlayerSounds[document.input.next].play();
			});
		}
	}
}
