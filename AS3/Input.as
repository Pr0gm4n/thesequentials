﻿package  {
	
	public class Input {
		
		private var document;
		public var last:int;
		public var next:int;

		public function Input(document:main) {
			this.document = document;
			this.last = -1;
			this.next = -1;
		}

		protected function input(input:uint):void {
			var tmp = 0, cube = -1;
			if (input > 0) {
				tmp = ((input + Bug.MOVES - 1) % Bug.MOVES) + 1;
				cube = (input - tmp) / 3;
				
				if (cube == last) {
					document.input(0);
				}
			}
			
			if (next < 0 || cube == last || cube == next) {
				last = cube;
				document.input(tmp);
			}
		}
	}
	
}