package com.kaixin.data
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-1 ����11:52:51
	*/
	
	import com.kaixin.net.rpc.KRPCClient;

	public class KDataUpdater extends KDataLoader
	{
		
		protected var selectQuery:String="";
		protected var deleteQuery:String="";
		protected var insertQuery:String="";
		protected var updateQuery:String="";
		
		public var isUpdated:Boolean=false;
		
		public function KDataUpdater(db:KDataBase,rpcClient:KRPCClient=null)
		{
			super(db,rpcClient);
		}


		public function saveData(course:int=7):void
		{
			loadData(course);
		}

		public function selectData():KRecordSet
		{
			//override by child which is not static ds
			return KSQL.execute(this.dataBase,this.selectQuery) as KRecordSet;
		}
		public function insertData(dataholder:*=null,silience:Boolean=false):void
		{
			//override by child which is not static ds
			isUpdated=true;
			KSQL.execute(this.dataBase,this.insertQuery,dataholder);
			if(!silience)updateRelatedDSs()			
		}
		public function updateData(dataholder:*=null,silience:Boolean=false):void
		{
			//override by child which is not static ds	
			isUpdated=true;
			KSQL.execute(this.dataBase,this.updateQuery,dataholder);
			if(!silience)updateRelatedDSs()			
		}
		public function deleteData(silience:Boolean=false):void
		{
			//override by child which is not static ds	
			isUpdated=true;
			KSQL.execute(this.dataBase,this.deleteQuery);
			if(!silience)updateRelatedDSs()						
		}		
	}
}