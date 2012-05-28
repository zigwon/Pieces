package org.net.data
{
	import flash.utils.ByteArray;
	
	
	public class DataPackager
	{
		private var _data:ByteArray
		public var prevPosition:uint=0;
		
		
		public function DataPackager(data:ByteArray=null)
		{
			if(data!=null)this._data=data;
			this.prevPosition=0;
		}
	}
}