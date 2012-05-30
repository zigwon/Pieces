package com.kaixin.data
{
	import com.kaixin.net.rpc.KRPCClient;

	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-1 ����05:07:31
	*/
	
	public class KDataSourcePool
	{
		public var rpcClient:KRPCClient
		public var pool:Object
		public function KDataSourcePool(focer:ForceSingleton)
		{
			pool={};		
		}
		private static var dsPool:KDataSourcePool;
		public static function connect(rpcClient:KRPCClient):KDataSourcePool
		{
			if(dsPool==null)
			{
				dsPool=new KDataSourcePool(new ForceSingleton());
			}
			dsPool.rpcClient=rpcClient;
			return dsPool;
		}
		public function addDataSource(ds:KDataSource):void
		{
			if(pool[ds.name]!=null)return;//throw new Error("Data Source Exist");
			pool[ds.name]=ds;
			ds.RPCClient=this.rpcClient;
			if(ds.isStaticDS)
			{
				ds.readyData();
			}
		}
	}
}
class ForceSingleton{}