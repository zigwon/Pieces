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

	public class KDataSource extends KDataProcessor
	{
		public var name:String="";
	
		protected var selectQuery:String="";
		
		protected var forceLoad:Boolean=false;
		
		protected var requested:Boolean=false;
		
		protected var recordSet:KRecordSet 
		
		public function get IsReady():Boolean
		{
			return this.recordSet!=null || this.requested; 
		}
		public function get RecordSet():KRecordSet
		{
			return this.recordSet;
		}
		/*public function set RecordSet(d:KRecordSet):void
		{
			this.recordSet=d;			
		}*/
		public var isStaticDS:Boolean=true;

		public function KDataSource(name:String,db:KDataBase,rpcClient:KRPCClient=null)
		{
			super(db,rpcClient);
			this.name=name;		
		}
		override public function dataHandle(data:*):void
		{
			//override by child
			this.requested=true;
			dataUpdated()
			this.dispatchEvent(new KDataEvent(KDataEvent.DATA_COMPLETE))
		}
		final public function readyData():void
		{		
			//if it is not a static DS
			//something need be reset	
			if(!this.isStaticDS){			
				this.recordSet=null;
				requested=false;
			}
			//if i don't wanna force clean it.i will try to select the data from the current table
			if(!this.forceLoad)
			{
				selectData();
			}
			if(this.IsReady){
				this.dispatchEvent(new KDataEvent(KDataEvent.DATA_COMPLETE));				
			}else{
				/*updateRequestObject()
				rpcClient.newRequestObject(this.requestObject);		*/
				loadData(COURSE_ONLY_ADD_REQUEST)		
			}			
		}
		
		public function selectData():void
		{
			//override by child which is not static ds			
			if(this.selectQuery==""){
				//this.recordSet=new KRecordSet();
				return;
			}
			this.recordSet=KSQL.execute(this.dataBase,this.selectQuery);
			if(this.recordSet!=null && this.recordSet.Data.length==0 && !this.isStaticDS && !this.requested)
			{				
				this.recordSet=null
			}			
		}

		override public function dataUpdated():void
		{
			selectData();
			this.dispatchEvent(new KDataEvent(KDataEvent.DATASOURCE_DATA_UPDATE))
		}
	}
}