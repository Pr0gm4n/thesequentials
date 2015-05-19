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
		public static const BACKGROUND:String = "background.png";
		public static const BASETILE:String = "base";
		public static const TILE_FILEEXTENSION:String = ".png";
		public static const GOALNAMES:String = "goals.txt";
		
		private var path;
		private var file:URLLoader;
		
		protected var logicGoal:LogicGoal;
		
		protected var music:Sound;
		protected var channel:SoundChannel;

		public function Map(document:main, x:uint, y:uint, rows:uint, cols:uint, map:uint, layout:uint = 1) {
			super(document, rows, cols, false);
			this.x = x;
			this.y = y;
			
			this.goal = new LogicGoal(rows, cols);
			this.logicGoal = goal as LogicGoal;
			
			this.path = MAPPATH + MAPFOLDER_PREFIX + map + "/";
			
			this.file = new URLLoader();
			file.addEventListener(Event.COMPLETE, loadMap);
			file.load(new URLRequest(MAPPATH + LAYOUT_FOLDER + layout + LAYOUT_FILEEXTENSION));
			
			this.music = new Sound(new URLRequest(MUSICPATH + map + MUSIC_FILEEXTENSION));
			
			document.blockInput();
		}
		
		private function loadMap(e:Event = null) {
			var structure:Array = file.data.split("\n");
			var image:Loader;
			
			image = new Loader();
			image.load(new URLRequest(path + BACKGROUND));
			addChild(image);
			
			for (var y:Number = 0; y < rows; y++) {
				var row:Array = structure[y].split("");
				row.splice(-1, 1);
				
				for (var x in row) {
					image = new Loader();
					image.load(new URLRequest(path + BASETILE + TILE_FILEEXTENSION));
					image.x = x * Grid.DX;
					image.y = y * Grid.DY;
					addChild(image);
					
					if (row[x] != " ") {
						image = new Loader();
						image.load(new URLRequest(path + row[x] + TILE_FILEEXTENSION));
						if (row[x].match(/[a-z]/) != null) {
							block[x][y] = true;
						} else if (row[x].match(/[1-9]/) != null) {
							logicGoal.setPos(x, y, row[x]);
						}
						image.x = x * Grid.DX;
						image.y = y * Grid.DY;
						addChild(image);
					}
				}
			}
			
			logicGoal.parse(structure.slice(rows));
			file = new URLLoader();
			file.addEventListener(Event.COMPLETE, loadGoalNames);
			file.load(new URLRequest(path + GOALNAMES));
			
			addChild(character);
			
			channel = music.play(0, 10000, new SoundTransform(0.15, 0));
		}
		
		private function loadGoalNames(e:Event = null) {
			var goalNames = file.data.split("\n");
			var task = logicGoal.toString();
			for (var name in goalNames) {
				task = task.split(name + 1).join(goalNames[name].slice(0, -1));
			}
			document.addMessage(task, 40, function():void {
				document.allowInput();
			});
		}
	}
}
