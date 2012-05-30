package org.manager
{
	import org.net.AbcRpcClient;
	import org.utils.Constants;
	import org.net.rpc.RpcError;
	import org.net.rpc.RpcEvent;
	
	public class ServerManager
	{
		
			/**
			 *单例 
			 */
			private static var _instance:ServerManager
			
			public static function get instance():ServerManager{
				return _instance||(_instance=new ServerManager(new Singleton()))
			}
				
			private var rpc:AbcRpcClient;
	
			
			public function ServerManager(singleton:Singleton)
			{
			}
				
			/**
			 * 呼叫服务器 
			 * @param paras ["serverName",[value1,value2],[fun],timeOut]
			 * 最后一个可以省略，省略为默认60000,即一分钟
			 */		
			public function callServer(paras:Array):void{
				trace("读取接口："+paras[0])
				setServer();
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
			
			
			public function setServer(server:String=null, appId:String = null, userid:String = null, uniquekey:String=null):void{
				
				//userId
				GlobalManager.instance.userId = userid||GlobalManager.instance.userId;
				
				server = Constants.URL_SERVER;
				appId = Constants.APP_ID;
				
				if(uniquekey==null||uniquekey==""){
					uniquekey = GlobalManager.instance.userId+"#"+appId+"#l63ocwAM0H"
				}
				
				var RequestURI:String = server+"?appId="+appId;
				
				registerRpcClient(uniquekey, server+"?appId="+appId);
			}
			
			
			/**
			 *  
			 * @param code 加密码
			 * 
			 */		
			public function registerRpcClient(code:String,requestURI:String):void
			{
				if(rpc){
					rpc.code = code;
				}else{
					rpc = new AbcRpcClient(code);
				}
				
				rpc.RequestURI = requestURI;
				
			}
			
			
			/**
			 * 默认批请求异常回调
			 */
			private function defaultErrorHandler(error:RpcError):void
			{
				trace(error.msg);
				//AbcDispatcher.dispatchEvent(ComController_org.instance.Err_Server_COM,new Err_Server_VO(error.errorID,error.message))
			}
	}
}
	
	

class Singleton{}