package org.net.rpc
{
	import flash.events.EventDispatcher;

	public class RpcRequester extends EventDispatcher
	{
		
		/**
		 * 请求重试次数
		 */ 
		public static var RetryTimes:int=3;
		private var retryPass:int=0;
		/**
		 * 请求超时时间
		 */ 
		public  var timeOut:int=60000;
		
		private var requests:Array; 
		
		//通过Rpclient的readyRequest定义
		public var completeHandle:Function
		public var errorHandle:Function
		
		
		
		public function RpcRequester()
		{
			this.requests=[];
			
		}
	}
}