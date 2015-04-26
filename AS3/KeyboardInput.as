﻿package  {
	
	import flash.events.*;
	import flash.utils.*;
	
	public class KeyboardInput extends Input {
		
		// maps keycodes to inputs
		private var codeMap:Dictionary;

		public function KeyboardInput(document:main) {
			super(document);
			
			codeMap = new Dictionary();
			codeMap[48] = 0;
			codeMap[49] = 1;
			codeMap[50] = 2;
			codeMap[51] = 3;
			codeMap[52] = 4;
			codeMap[53] = 5;
			codeMap[54] = 6;
			codeMap[55] = 7;
			codeMap[56] = 8;
			codeMap[57] = 9;
			
			document.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode in codeMap) {
					input(codeMap[e.keyCode]);
				}
			});
		}
	}
	
}
