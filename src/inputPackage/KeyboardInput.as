package inputPackage {
	
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
			codeMap[52] = 7;
			codeMap[53] = 8;
			codeMap[54] = 9;
			codeMap[55] = 13;
			codeMap[56] = 14;
			codeMap[57] = 15;
			codeMap[81] = 19; // q
			codeMap[87] = 20; // w
			codeMap[69] = 21; // e
			
			document.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode in codeMap) {
					input(codeMap[e.keyCode]);
				}
				trace("keycode: " + e.keyCode);
			});
		}
	}
	
}
