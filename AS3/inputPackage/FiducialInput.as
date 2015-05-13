package inputPackage {
	
	import flash.display.*;
	
	import org.tuio.ITuioListener;
	import org.tuio.TuioBlob;
	import org.tuio.TuioClient;
	import org.tuio.TuioCursor;
	import org.tuio.TuioObject;
	import org.tuio.connectors.LCConnector;
	
	public class FiducialInput extends Input implements ITuioListener {

		private var tuio:TuioClient;
		
		public function FiducialInput(document:main) {
			super(document);
			
			this.tuio = new TuioClient(new LCConnector());
			this.tuio.addListener(this);
		}
		
		/**
		 * Called if a new object was tracked.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
		public function addTuioObject(tuioObject:TuioObject):void {
			input(tuioObject.classID);
		}
		
		/**
		 * Called if a tracked object was updated.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
		public function updateTuioObject(tuioObject:TuioObject):void {
		}
		
		/**
		 * Called if a tracked object was removed.
		 * @param	tuioObject The values of the received /tuio/**Dobj.
		 */
		public function removeTuioObject(tuioObject:TuioObject):void {
		}

		/**
		 * Called if a new cursor was tracked.
		 * @param	tuioObject The values of the received /tuio/**Dcur.
		 */
		public function addTuioCursor(tuioCursor:TuioCursor):void {
		}
		
		/**
		 * Called if a tracked cursor was updated.
		 * @param	tuioCursor The values of the received /tuio/**Dcur.
		 */
		public function updateTuioCursor(tuioCursor:TuioCursor):void {
		}
		
		/**
		 * Called if a tracked cursor was removed.
		 * @param	tuioCursor The values of the received /tuio/**Dcur.
		 */
		public function removeTuioCursor(tuioCursor:TuioCursor):void {
		}
		
		/**
		 * Called if a new blob was tracked.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
		public function addTuioBlob(tuioBlob:TuioBlob):void {
		}

		/**
		 * Called if a tracked blob was updated.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
		public function updateTuioBlob(tuioBlob:TuioBlob):void {
		}
		
		/**
		 * Called if a tracked blob was removed.
		 * @param	tuioBlob The values of the received /tuio/**Dblb.
		 */
		public function removeTuioBlob(tuioBlob:TuioBlob):void {
		}
		
		/**
		 * Called if a new frameID is received.
		 * @param	id The new frameID
		 */
		public function newFrame(id:uint):void {
		}
	}
}