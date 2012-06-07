package com.kaixin.net.rpc
{
	/**WWW.OPI-CORP.COM
	 *AS FLEET
	 *JIAN.WU@OPI-CORP.COM
	 *2009-6-8 ����02:38:26
	 */
	
	import com.adobe.serialization.json.OldJSON;
	import com.kaixin.data.KDataFormat;
	import com.kaixin.data.KDataPackager;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.core.AbcDispatcher;
	import org.data.enum.MessageType;
	import org.events.ComController_org;
	import org.events.vo.err.Err_Server_VO;
	import org.manager.GlobalManager;
	
	
	public class KRPCRequester extends EventDispatcher
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
		
		public function get TimeOut():int
		{
		return timeOut;
		}
		
		public function set TimeOut(v:int):void
		{
		timeOut = v;
		timeOuter.reset();
		timeOuter.delay=v;			
		}
		/**已经经过的时间*/
		private var timeOutPass:int=0;
		private var timeOuter:Timer
		
		
		
		private var requests:Array; 
		private var batchData:ByteArray;
		private var batcher:KDataPackager;
		
		private var responser:URLLoader;
		private var requester:URLRequest;
		
		
		private var _headData:ByteArray;
		private var _tailData:ByteArray;
		
		
		//通过KRPCClient的readyRequest定义
		public var completeHandle:Function
		public var errorHandle:Function
		
		//直接通过更改静态属性
		public static var defaultCompleteHandle:Function
		public static var defaultErrorHandle:Function
		
		public function set headData(hd:ByteArray):void
		{
			this._headData=hd;			
		}
		public function set tailData(td:ByteArray):void
		{
			this._tailData=td;			
		}
		
		
		public function get dataBatched():ByteArray
		{
			return this.batchData;
		}
		
		public function KRPCRequester(){
			
			this.requests=[];
			this.batchData=new ByteArray();
			this.batcher=new KDataPackager(this.batchData);	
			this.responser=new URLLoader()
			this.responser.dataFormat=URLLoaderDataFormat.BINARY;
			this._headData=new ByteArray();
			this._tailData=new ByteArray();
			timeOuter=new Timer(60000,1);
			timeOuter.addEventListener(TimerEvent.TIMER_COMPLETE,timeOutHandle)
		}
		/**
		 * 重新设置超时时间
		 * @param timeOut
		 * 
		 */		
		public function setTimeOut(timeOut:Number):void{
			
			timeOuter.delay=timeOut
			
		}
		
		
		public function input(ro:KRPCRequestObject):void
		{
			this.requests.push(ro);
		}
		
		public function go(uri:String):void
		{
			this.batchData.writeBytes(this._headData);
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:KRPCRequestObject=this.requests[i];
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
				AbcDispatcher.dispatchEvent(ComController_org.instance.Err_Server_COM,new Err_Server_VO(509, MessageType.systemError));
				return;
			}
			
			//UTFBytes(this.batchData.bytesAvailable));
			
			
			if(firstByte==KDataFormat.TYPE_ERROR){
				/*
				try{
				this.batchData.readUTF()
				}catch(e:Error){AbcDispatcher.dispatchEvent(ComController_org.instance.Err_Server_COM,new Err_Server_VO(509,"遇到文件尾了。。。！"));return;}
				*/
				//errorAction(new KRPCError(this.batchData.readInt(),this.batchData.readUTF()+"["+this.requests[0].funcName+"]"))
				var errint:int=this.batchData.readInt()
				var errstr:String=this.batchData.readUTF()
				
				trace("错误："+firstByte,errint,errstr)
				
				
				errorAction(new KRPCError(errint,errstr?errstr:MessageType.systemError))
				return;
			}
			this.batchData.position=0;
			var results:Array=this.batcher.readVars();
			if(results.length<this.requests.length)throw new Error(KRPCError.PARAMETERS_ARE_UNCONFORMITY);
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:KRPCRequestObject=this.requests[i];
				var f:Function;
				if(results[i] is KRPCError)
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
			//进一步判断和执行服务端附带传送回来的请求
			for(i=this.requests.length;i<results.length;i++)
			{
				var func:*=results[i][0];
				var vars:*=results[i][1];
				var pool:KRPCHandlePool=KRPCHandlePool.connect();
				pool.call(func,vars);
				//trace(this.requests[i].funcName+":"+JSON.encode(results[i]))
			}
			
			
			if(completeHandle!=null)completeHandle.apply();
			if(defaultCompleteHandle!=null)defaultCompleteHandle.apply();
			
		}
		public function errorResponse(e:ErrorEvent):void
		{
			//--hide--//trace(e);
			
			var reqs:String=""
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:KRPCRequestObject=this.requests[i];
				reqs+=ro.toString()+"\n";	
			}
			//errorAction(new KRPCError(0,KRPCError.TIME_OUT+"\n"+reqs))
			
			if(retryPass++>RetryTimes){
				errorAction(new KRPCError(-1,KRPCError.TIME_OUT+"\n"+reqs))
			}else{
				this.responser.load(this.requester);	
			}
		}
		private function httpStatusHandle(e:HTTPStatusEvent):void
		{
			//--hide--//trace(e);
		}
		
		public function errorAction(err:KRPCError):void
		{
			timeOuter.reset();
			timeOuter.removeEventListener(TimerEvent.TIMER_COMPLETE,timeOutHandle)
			if(errorHandle!=null)errorHandle.apply(null,[err]);
			if(defaultErrorHandle!=null)defaultErrorHandle.apply(null,[err]);
		}		
		private function timeOutHandle(e:TimerEvent):void
		{
			var reqs:String=""
			for(var i:int=0;i<this.requests.length;i++)
			{
				var ro:KRPCRequestObject=this.requests[i];
				reqs+=ro.toString()+"\n";	
			}
			errorAction(new KRPCError(0,KRPCError.TIME_OUT+"\n"+reqs))
			
			//如果超时则不响应回调函数了
			completeHandle=null
			defaultCompleteHandle=null
		}
		
		public function remove():void
		{
			
		}
	}
}