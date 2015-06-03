package inputPackage {
	
	import gamePackage.Bug;
	
	public class Input {
		
		private var document;
		public var last:int;
		public var next:int;

		public function Input(document:main) {
			this.document = document;
			reset();
		}
		
		public function reset():void {
			this.last = -1;
			this.next = -1;
		}

		protected function input(input:uint):void {
			if (input > Bug.MOVES * main.cubeColors.length) return;
			var tmp = 0, cube = -1;
			if (input > 0) {
				tmp = ((input + Bug.MOVES - 1) % Bug.MOVES) + 1;
				cube = (input - tmp) / Bug.MOVES;
				
				if (cube == last) {
					document.newInput(Bug.UNDO);
				}
			}
			
			if (next < 0 || cube == last || cube == next) {
				if (document.mainMenu.isLoaded || document.mode == main.EASY || (!document.block_newInput && document.moves.length < 4)) {
					last = cube;
				}
				document.newInput(tmp);
			}
		}
	}
	
}