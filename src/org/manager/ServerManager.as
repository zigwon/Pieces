package org.manager
{
	import org.net.AbcRpcClient
	
	public class ServerManager
	{
		public function ServerManager()
		{
			
			private var rpc:AbcRpcClient;
			
			
			
			/**
			 * 呼叫服务器 
			 * @param paras ["serverName",[value1,value2],[fun],timeOut]
			 * 最后一个可以省略，省略为默认60000,即一分钟
			 */		
			public function callServer(paras:Array):void{
				trace("读取接口："+paras[0])
				readyRequest();
				newRequest.apply(null,paras);
				doRequest()
			}
			
			
			public function readyRequest(completeHandle:Function=null,errorHandle:Function=null):void
			{
				rpc.readyRequest(completeHandle, errorHandle);
			}
			
			
			/**
			 * 执行请求
			 * @param	func				函数名
			 * @param	vars				[参数]
			 * @param	callbacks		[回调函数]
			 */
			public function newRequest(func:String,vars:Array,callbacks:Array,timeOut:Number=60000):void
			{
				rpc.newRequest(func, vars, callbacks, timeOut);
			}
			
			/**
			 * 执行通讯请求 
			 * 
			 */		
			public function doRequest():void
			{
				rpc.doRequest();
				
			}
		}
	}
}

class Singleton{}