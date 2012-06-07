package com.kaixin.event
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-7 ����10:41:03
	*/
	
	public class KDataEvent extends KEvent
	{
		public static var DATA_COMPLETE:String="dataComplete";
		public static var DATA_ERROR:String="dataError";
		
		public static var DATASOURCE_ALL_READY:String="datasourceAllReady";
		
		public static var DATASOURCE_DATA_UPDATE:String="datasourceDataUpdate";
		
		public static var DATALOADER_DATA_COMPLETE:String="dataloaderDataComplete";
		
		public function KDataEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}