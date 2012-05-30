package org.net.rpc
{
	import flash.events.EventDispatcher;
	
	import org.net.rpc.RpcError;
	import org.net.rpc.RpcRequestObject;
	
	public class RpcClient extends EventDispatcher
	{	
		
		public var defaultCompleteHandle:Function;
		public var defaultErrorHandle:Function;
		protected var requester:RpcRequester;
		private var _requestURI:String="";
		
		public function RpcClient()
		{
			defaultCompleteHandle=this.defaultCompleteHandleFunc;
			defaultErrorHandle=this.defaultErrorHandleFunc;
		}
		
		
		public function readyRequest(completeHandle:Function=null,errorHandle:Function=null):void
		{
			this.requester=new RpcRequester();
			this.requester.completeHandle=completeHandle==null?defaultCompleteHandle:completeHandle;
			this.requester.errorHandle=errorHandle==null?defaultErrorHandle:errorHandle;
		}
		
		private function defaultCompleteHandleFunc():void
		{
			this.dispatchEvent(new RpcEvent(RpcEvent.REQUEST_COMPLETE))
		}
		
		
		private function defaultErrorHandleFunc(error:RpcError):void
		{
			this.dispatchEvent(new RpcEvent(RpcEvent.REQUEST_ERROR, error))
		}
		
		public function set RequestURI(r:String):void
		{
			this._requestURI=r;
		}
		/**
		 * @param func
		 * @param vars
		 * @param callbacks
		 * @param timeOut
		 */		
		public function newRequest(func:String,vars:Array,callbacks:Array,timeOut:Number=60000):void
		{
			if(this.requester==null)
				throw new Error(RpcError.REQUESTER_IS_NULL);
			this.requester.input(new RpcRequestObject(func,vars,callbacks));
			
			this.requester.setTimeOut(timeOut);
			
		}
		
		public function doRequest():void
		{
			if(this.requester==null)throw new Error(RpcError.REQUESTER_IS_NULL);
			if(this._requestURI=="")throw new Error(RpcError.URI_IS_NULL);
			if(this._requestURI.indexOf("?")!=-1)
			{
				this.requester.go(this._requestURI+"&t="+new Date().time);
			}else{
				this.requester.go(this._requestURI+"?t="+new Date().time);
			}
			this.requester=null;
		}
	}
}