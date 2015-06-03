package gamePackage {
	
	import flash.display.*;
	import flash.utils.*;
	import flash.text.*;
	
	import com.greensock.TweenMax;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Bug extends MovieClip{
		
		public static const MOVES:uint = 6;
		
		public static const UNDO:uint = 0;
		public static const FORWARD:uint = 1;
		public static const TURNLEFT:uint = 2;
		public static const TURNRIGHT:uint = 3;
		public static const ACTION_4:uint = 4;
		public static const ACTION_5:uint = 5;
		public static const ACTION_6:uint = 6;
		
		public static const ANIMATION_DELAY:uint = 250;
		
		public var posX:uint;
		public var posY:uint;
		
		var grid:Grid;
		var direction:int;
		
		// for smooth rotation
		private var angle:int;
		public var speed:Number;
		
		// for movement sounds
		protected var forwardSound:Sound;
		protected var turnSound:Sound;
		protected var bumpSound:Sound;
		protected var block_sound:Boolean;
		protected var unblockSoundTimer:Timer;
		
		// store the last performed action for undo()
		public var last:uint;
		
		/**
		 * Adds a new bug to the grid and positions it correctly.
		 * 
		 * @param direction Uses the directions Grid.EAST, Grid.SOUTH, Grid.WEST and Grid.NORTH.
		 * @param alpha Controls the transparency of the bug.
		 */
		public function Bug(grid:Grid, posX:uint = 0, posY:uint = 0, direction:uint = 0, speed:Number = 1.0, alpha:Number = 1.0) {
			this.posX = posX;
			this.posY = posY;

			this.direction = direction;
			this.angle = 0;
			if (direction != 0) {
			TweenMax.to(this, 0, {
				shortRotation: {
					rotation: angle = 90 * direction
				}
			});
			}
			
			this.speed = speed;
			this.alpha = alpha;
			
			forwardSound = new Sound(new URLRequest(Grid.SOUNDPATH + "ant_fwd" + Grid.SOUND_FILEEXTENSION));
			turnSound = new Sound(new URLRequest(Grid.SOUNDPATH + "ant_turn" + Grid.SOUND_FILEEXTENSION));
			bumpSound = new Sound(new URLRequest(Grid.SOUNDPATH + "ant_wall" + Grid.SOUND_FILEEXTENSION));
			
			block_sound = false;
			unblockSoundTimer = new Timer(100);
			unblockSoundTimer.addEventListener(TimerEvent.TIMER, function(e:Event = null):void {
				block_sound = false;
				unblockSoundTimer.reset();
			});
			this.last = UNDO;
			
			this.grid = grid;
			
			updatePosition(false);
		}
		
		public function move(action:uint):void {
			switch (action) {
				case UNDO:
					undo();
					break;
				case FORWARD:
					forward();
					break;
				case TURNLEFT:
					turnLeft();
					break;
				case TURNRIGHT:
					turnRight();
					break;
				default:
			}
		}
		
		public function reverse(action:uint):void {
			switch (action) {
				case FORWARD:
					direction = (direction + 2) % 4;
					forward();
					direction = (direction + 2) % 4;
					break;
				case TURNLEFT:
					turnRight();
					break;
				case TURNRIGHT:
					turnLeft();
					break;
				default:
			}
		}
		
		public function undo():void {
			reverse(last);
			last = UNDO;
		}
		
		public function forward():void {
			var dx:int, dy:int;
			
			// calculate offsets for x and y
			dx = -1 * ((direction - 1) % 2); // 0: 1, 1: 0, 2: -1, 3: 0
			dy = -1 * ((direction - 2) % 2); // 0: 0, 1: 1, 2: 0, 3: -1
			
			if (grid.isAccessible(posX + dx, posY + dy)){
				this.posX += dx;
				this.posY += dy;
				updatePosition();
				
				if (alpha == 1.0 && !block_sound) {
					forwardSound.play();
					block_sound = true;
					unblockSoundTimer.start();
				}
			
				last = FORWARD;
			} else {
				noAccess();
				last = UNDO;
			}
		}
		
		public function turnLeft():void {
			direction = (direction + 3) % 4;
			main.delayCallback(ANIMATION_DELAY, function():void {
				TweenMax.to(this, 0.8 / speed, {
					shortRotation: {
						rotation: angle -= 90
					}
				});
				angle %= 360;
			}, this);
			
			if (alpha == 1.0 && !block_sound) {
				turnSound.play();
				block_sound = true;
				unblockSoundTimer.start();
			}
			
			last = TURNLEFT;
		}
		
		public function turnRight():void {
			direction = (direction + 1) % 4;
			main.delayCallback(ANIMATION_DELAY, function():void {
				TweenMax.to(this, 0.8 / speed, {
					shortRotation: {
						rotation: angle += 90
					}
				});
				angle %= 360;
			}, this);
			
			if (alpha == 1.0 && !block_sound) {
				turnSound.play();
				block_sound = true;
				unblockSoundTimer.start();
			}
			
			last = TURNRIGHT;
		}
		
		public function updatePosition(animate:Boolean = true):void {
			if (animate) {
				main.delayCallback(ANIMATION_DELAY - 25, function():void {
					TweenMax.to(this, 1.0 / speed, {
						x: (posX + 0.5) * Grid.DX,
						y: (posY + 0.5) * Grid.DY
					});
				}, this);
			} else {
				this.x = (posX + 0.5) * Grid.DX;
				this.y = (posY + 0.5) * Grid.DY;
			}
		}
		
		private function noAccess() {
			main.delayCallback(ANIMATION_DELAY, function():void {
				TweenMax.to(this, 0.2 / speed, {
					x: (posX + 0.5 + 0.5 * ((direction + 1) % 2)) * Grid.DX,
					y: (posY + 0.5 + 0.5 * (direction % 2)) * Grid.DY
				});
				TweenMax.to(this, 0.5 / speed, {
					x: (posX + 0.5) * Grid.DX,
					y: (posY + 0.5) * Grid.DY
				});
			}, this);
			
			if (alpha == 1.0 && !block_sound) {
				bumpSound.play();
				block_sound = true;
				unblockSoundTimer.start();
			}
		}
	}
}
