package com.kaixin.data
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-1 ����11:52:51
	*/
	
	import com.kaixin.event.KDataEvent;
	import com.kaixin.event.KEvent;
	import com.kaixin.net.rpc.KRPCClient;
	import com.kaixin.net.rpc.KRPCRequestObject;
	
	import flash.events.EventDispatcher;

	public class KDataLoader extends KDataProcessor
	{
		protected var relatedDSs:Array=[];
		public function KDataLoader(db:KDataBase,rpcClient:KRPCClient=null)
		{
			super(db,rpcClient);
		}
		override public function dataHandle(data:*):void
		{
			//override by child
			this.dispatchEvent(new KDataEvent(KDataEvent.DATALOADER_DATA_COMPLETE))
		}

		protected function updateRelatedDSs():void
		{
			for each(var ds:KDataSource in this.relatedDSs)
			{
				ds.dataUpdated();
			}
		}
		
		
	}
}