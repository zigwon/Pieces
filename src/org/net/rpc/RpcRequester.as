package org.net.rpc
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
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
		
		private var _headData:ByteArray;
		private var timeOuter:Timer
		
		private var batchData:ByteArray;
		
		
		public function RpcRequester()
		{
			this.requests=[];
		}
	
		
		public function input(ro:RpcRequestObject):void
		{
			this.requests.push(ro);
		}
		
		
		public function set headData(headData:ByteArray):void
		{
			this._headData=headData;			
		}
		
		public function get headData():ByteArray
		{
			return _headData;			
		}
		
		/**
		 * 重新设置超时时间
		 * @param timeOut
		 * 
		 */		
		public function setTimeOut(timeOut:Number):void{
			timeOuter.delay=timeOut;
		}
		
		
		public function go(uri:String):void
		{
			this.batchData.writeBytes(this._headData);
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:RpcRequestObject=this.requests[i];
				this.batcher.writeUTFString(ro.funcName);
				this.batcher.writeArray(ro.vars);
			}
			this.batchData.writeBytes(this._tailData);
			requester=new URLRequest(uri);
			requester.contentType="application/octet-stream";
			requester.method=URLRequestMethod.POST;
			
			this.batchData.compress();
			
			requester.data=this.batchData;
			this.responser.addEventListener(Event.COMPLETE,handleResponse);
			this.responser.addEventListener(IOErrorEvent.IO_ERROR,errorResponse);
			this.responser.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandle);
			this.responser.load(requester);		
			timeOuter.reset();
			timeOuter.start();
			
		}
	}
}