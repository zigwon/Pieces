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
	import com.kaixin.net.rpc.KRPCError;
	import com.kaixin.net.rpc.KRPCRequestObject;
	
	import flash.events.EventDispatcher;

	public class KDataProcessor extends EventDispatcher
	{

		static public var COURSE_READY_REQUEST:int=1
		static public var COURSE_ONLY_ADD_REQUEST:int=2
		static public var COURSE_READY_REQUEST_AND_ADD_REQUEST:int=3
		static public var COURSE_DO_REQUEST:int=4 
		static public var COURSE_ADD_REQUEST_AND_DO_REQUEST:int=6
		static public var COURSE_ALL_ACTION:int=7
		
		
		protected var dataBase:KDataBase;
		
		protected var requestParameter:Array=[]; 
		public function set RequestParameter(p:Array):void
		{
			this.requestParameter=p;
			updateRequestObject();
		}
		public function get RequestParameter():Array
		{
			return this.requestParameter;
		}
		protected var requestObject:KRPCRequestObject
		
		public function get RequestObject():KRPCRequestObject
		{
			return requestObject; 
		}
		
		protected var callBacks:Array=[]
		
		public function get CallBacks():Array
		{
			if(callBacks.length==0)
			{
				callBacks=[dataHandle]
			}
			return callBacks;
		}

		public function set CallBacks(v:Array):void
		{
			v.unshift(dataHandle)
			callBacks = v;
		}

		protected var errorHandles:Array=[]
		
		public function get ErrorHandles():Array
		{
			if(errorHandles.length==0)
			{
				errorHandles=[errorHandle]
			}
			return errorHandles;
		}

		public function set ErrorHandles(v:Array):void
		{
			v.unshift(errorHandle)
			errorHandles = v;
		}


	 	protected var rpcClient:KRPCClient
	 	public function set RPCClient(rpcClient:KRPCClient):void
	 	{
	 		this.rpcClient=rpcClient;
	 	}
		public function KDataProcessor(db:KDataBase,rpcClient:KRPCClient=null):void
		{
			super();
			this.dataBase=db;			
			this.rpcClient=rpcClient;
		}

		public function loadData(course:int=7):void
		{
			updateRequestObject()
			if((course|COURSE_READY_REQUEST)==course){
			rpcClient.readyRequest();}
			if((course|COURSE_ONLY_ADD_REQUEST)==course){
			rpcClient.newRequestObject(this.requestObject);}
			if((course|COURSE_DO_REQUEST)==course){
			rpcClient.doRequest();}
		}
		
		
		public function dataHandle(data:*):void
		{
			//override by child
		}
		
		public function errorHandle(error:KRPCError):void
		{
			//override by child 
		}
		
		
		
		protected function updateRequestObject():void
		{
			//override by child
		}
		public function dataUpdated():void
		{
			this.dispatchEvent(new KDataEvent(KDataEvent.DATASOURCE_DATA_UPDATE))
		}
	}
}