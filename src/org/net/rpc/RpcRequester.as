package org.net.rpc
{	
	import com.adobe.serialization.json.OldJSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.net.data.DataFormat;
	import org.net.data.DataPackager;
	
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
		
		public static var defaultErrorHandle:Function
		public static var defaultCompleteHandle:Function
		
		private var _headData:ByteArray;
		private var _tailData:ByteArray;
		private var timeOuter:Timer
		
		private var batchData:ByteArray;
		private var batcher:DataPackager;
		
		private var responser:URLLoader;
		private var requester:URLRequest;
		
		public function RpcRequester()
		{
			this.requests=[];
			this.batchData=new ByteArray();
			this._headData=new ByteArray();
			this._tailData=new ByteArray();
			this.responser=new URLLoader()
			this.responser.dataFormat=URLLoaderDataFormat.BINARY;
			timeOuter=new Timer(60000,1);
			this.batcher=new DataPackager(this.batchData);	
			timeOuter.addEventListener(TimerEvent.TIMER_COMPLETE,timeOutHandle)
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
		
		public function set tailData(td:ByteArray):void
		{
			this._tailData=td;			
		}
		public function get tailData():ByteArray
		{
			return _tailData;	
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
			//this.responser.addEventListener(IOErrorEvent.IO_ERROR,errorResponse);
			//this.responser.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandle);
			this.responser.load(requester);		
			timeOuter.reset();
			timeOuter.start();
			
		}
		
		
		
		public function handleResponse(e:Event):void
		{
			timeOuter.reset();
			timeOuter.removeEventListener(TimerEvent.TIMER_COMPLETE,timeOutHandle)
			
			this.batchData=URLLoader(e.target).data;
			this.batchData.uncompress();
			this.batcher.Data=this.batchData;
			this.batchData.position=0;
			
			try{
				var firstByte:int=this.batchData.readByte();
			}catch(e:Error){
				//TODO error eventdispatch
				//AbcDispatcher.dispatchEvent(ComController_org.instance.Err_Server_COM,new Err_Server_VO(509, MessageType.systemError));
				trace("509");
				return;
			}
			
			if(firstByte==DataFormat.TYPE_ERROR){
				var errint:int=this.batchData.readInt()
				var errstr:String=this.batchData.readUTF()
				
				trace("错误："+firstByte,errint,errstr)
				
				errorAction(new RpcError(errint,errstr?errstr:"Error!!!"));
				return;
			}
			this.batchData.position=0;
			var results:Array=this.batcher.readVars();
			if(results.length<this.requests.length) throw new Error(RpcError.PARAMETERS_ARE_UNCONFORMITY);
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:RpcRequestObject=this.requests[i];
				var f:Function;
				if(results[i] is RpcError)
				{
					for each(f in ro.errorHandles)
					{
						if(f!=null)f.apply(null,[results[i]]);
					}
				}else{
					for each(f in ro.callBacks)
					{
						if(f!=null){
							f.apply(null,[results[i]]);
							
							//if(!GlobalManager.instance.dataObject[requests[i].funcName]){
							
							//GlobalManager.instance.dataObject[requests[i].funcName]=JSON.encode(results[i])
							
							trace(requests[i].funcName+":"+OldJSON.encode(results[i]))
							
							//}
						}
						
					}
				}
			}
			/**
			//进一步判断和执行服务端附带传送回来的请求
			for(i=this.requests.length;i<results.length;i++)
			{
				var func:*=results[i][0];
				var vars:*=results[i][1];
				var pool:KRPCHandlePool=KRPCHandlePool.connect();
				pool.call(func,vars);
			}
			*/
			
			
			if(completeHandle!=null)completeHandle.apply();
			if(defaultCompleteHandle!=null)defaultCompleteHandle.apply();
			
		}
		
		
		
		private function timeOutHandle(e:TimerEvent):void
		{
			var reqs:String=""
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:RpcRequestObject=this.requests[i];
				reqs+=ro.toString()+"\n";	
			}
			errorAction(new RpcError(0,RpcError.TIME_OUT+"\n"+reqs))
			
			//如果超时则不响应回调函数了
			completeHandle=null
			defaultCompleteHandle=null
		}
		
		
		private function errorAction(err:RpcError):void
		{
			timeOuter.reset();
			timeOuter.removeEventListener(TimerEvent.TIMER_COMPLETE,timeOutHandle);
			if(errorHandle!=null)errorHandle.apply(null,[err]);
			if(defaultErrorHandle!=null)defaultErrorHandle.apply(null,[err]);
		}		
	}
}