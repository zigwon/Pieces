package org.net.rpc
{
	import flash.events.EventDispatcher;
	import org.net.rpc.RpcClient;
	import org.net.rpc.RpcError;
	
	public class RpcClient extends EventDispatcher
	{	
		
		public var defaultCompleteHandle:Function;
		public var defaultErrorHandle:Function;
		protected var requester:RpcRequester;
		
		
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
			this.dispatchEvent(new RpcEvent(RpcEvent.REQUEST_ERROR,error))
		}
	}
}