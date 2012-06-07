package com.kaixin.net.rpc
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*JIAN.WU@OPI-CORP.COM
	*����02:29:58
	*/
	
	import com.kaixin.event.KRPCEvent;
	
	import flash.events.EventDispatcher;

	public class KRPCClient extends EventDispatcher
	{
		
		private var _requestURI:String="";
		protected var requester:KRPCRequester;
		
		public var defaultCompleteHandle:Function;
		public var defaultErrorHandle:Function;
		
		public function KRPCClient()
		{			
			defaultCompleteHandle=this.defaultCompleteHandleFunc;
			defaultErrorHandle=this.defaultErrorHandleFunc;
		}
		public function set RequestURI(r:String):void
		{
			this._requestURI=r;
		}
		public function readyRequest(completeHandle:Function=null,errorHandle:Function=null):void
		{
			this.requester=new KRPCRequester();	
			this.requester.completeHandle=completeHandle==null?defaultCompleteHandle:completeHandle;
			this.requester.errorHandle=errorHandle==null?defaultErrorHandle:errorHandle;	
			
			
		}
		/**
		 * 补丁，添加了超时参数 
		 * @param func
		 * @param vars
		 * @param callbacks
		 * @param timeOut
		 * 
		 */		
		public function newRequest(func:String,vars:Array,callbacks:Array,timeOut:Number=60000):void
		{
			if(this.requester==null)throw new Error(KRPCError.REQUESTER_IS_NULL);
			this.requester.input(new KRPCRequestObject(func,vars,callbacks));
			
			this.requester.setTimeOut(timeOut)
			
		}
		public function newRequestObject(ro:KRPCRequestObject):void
		{
			if(this.requester==null)throw new Error(KRPCError.REQUESTER_IS_NULL);
			this.requester.input(ro);
		}
		public function doRequest():void
		{
			if(this.requester==null)throw new Error(KRPCError.REQUESTER_IS_NULL);
			if(this._requestURI=="")throw new Error(KRPCError.URI_IS_NULL);
			if(this._requestURI.indexOf("?")!=-1)
			{
				this.requester.go(this._requestURI+"&t="+new Date().getTime());
			}else{
				this.requester.go(this._requestURI+"?t="+new Date().getTime());
			}
			this.requester=null;
		}
		private function defaultCompleteHandleFunc():void
		{
			this.dispatchEvent(new KRPCEvent(KRPCEvent.REQUEST_COMPLETE))
		}
		private function defaultErrorHandleFunc(error:KRPCError):void
		{
			/*if(!this.hasEventListener(KRPCEvent.REQUEST_ERROR))
			{
				throw error;
			}*/
			this.dispatchEvent(new KRPCEvent(KRPCEvent.REQUEST_ERROR,error))
		}
	}
}