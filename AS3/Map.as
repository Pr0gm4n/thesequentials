package {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Map extends Grid {
		public static const MAPPATH:String = "../Maps/";
		public static const LAYOUT_FOLDER:String = "layouts/";
		public static const LAYOUT_FILEEXTENSION:String = ".txt";
		public static const MAPFOLDER_PREFIX:String = "map";
		public static const BACKGROUND:String = "background.png";
		public static const BASETILE:String = "base";
		public static const TILE_FILEEXTENSION:String = ".png";
		
		private var path;
		private var file:URLLoader;

		public function Map(document:main, rows, cols, map:uint, layout:uint = 1) {
			super(document, rows, cols, false);
			this.path = MAPPATH + MAPFOLDER_PREFIX + map + "/";
			
			this.file = new URLLoader();
			file.addEventListener(Event.COMPLETE, loadMap);
			file.load(new URLRequest(MAPPATH + LAYOUT_FOLDER + layout + LAYOUT_FILEEXTENSION));
		}
		
		private function loadMap(e:Event = null) {
			var structure:Array = file.data.split("\n");
			var image:Loader;
			
			image = new Loader();
			image.load(new URLRequest(path + BACKGROUND));
			addChild(image);
			
			for (var y:Number = 0; y < rows; y++) {
				var row:Array = structure[y].split("");
				trace(row[row.length-1]);
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
							goal = new SimpleGoal(x, y);
						}
						image.x = x * Grid.DX;
						image.y = y * Grid.DY;
						addChild(image);
					}
				}
			}
			
			addChild(character);
			
			// show goal image in the mock list
			image = new Loader();
			image.load(new URLRequest(path + "1.png"));
			image.x = 1075;
			image.y = 55;
			addChild(image);
		}
	}
}
