package org.net
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.interfaces.ILoader;
	import org.utils.StringUtil;

	public class AbcLoaderText implements ILoader
	{
		
		/**
		 *加载状态 
		 */        
		private var _isloading:Boolean=false
		/**
		 *加载器标识
		 */		
		private var _name:String
		/**
		 *路径 
		 */		
		private var _url:String
		/**
		 *加载数据 
		 */		
		private var _data:ByteArray
		
		/**
		 * 获取加载进度
		 * 
		 */		
		private var _progress:Number
		
		/**
		 *回调函数
		 */		
		private var responder:AbcResponder
		
		
		/**
		 *加载器 
		 */
		private var loader:URLLoader
		
		/**
		 * 实现接口 
		 * @return 
		 * 
		 */	
		public function get isloading():Boolean{
			
			return _isloading
			
		}
		public function get name():String{
			
			return StringUtil.onewordUp(_name)
		}
		public function get url():String{
			
			return _url
			
		}
		
		public function get data():*{
			
			return _data
			
		}
		
		public function get progress():Number{
		
		   return _progress
		
		}
		
		
		/**
		 * 加载文本方法 
		 * @param _url 文件路径
		 * @param responder 异步响应捕捉类
		 */
		public function AbcLoaderText(_url:String,responder:AbcResponder=null,appDomain:ApplicationDomain=null,_name:String="")
		{
			this._name=_name
				
			this._url=_url
			this.responder=responder
				
		}
		
		/**
		 *开始加载 
		 * 
		 */		
		public function initLoad():void{
			
			_isloading=true
			
		    loader = new URLLoader();
			
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			
			configureListeners(loader);
			
			var request:URLRequest = new URLRequest(_url);
			
			try {
				
				loader.load(request);
				
			} catch (error:Error) {
				
				throw new Error(_url+"路径不存在!")
					
			}
			
		}
		/**
		 *停止加载 
		 * 
		 */		
		public function stopLoad():void{
			
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			loader.removeEventListener(Event.OPEN, openHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.close()
			
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(e:Event):void {
			
			_data=URLLoader(e.target).data
				
			if(responder)responder.onResult(this);
			if(responder)responder.onComplete(this);
		}
		
		private function openHandler(event:Event):void {
			
		}
		
		private function progressHandler(event:ProgressEvent):void {
			
			_progress=event.bytesLoaded/event.bytesTotal
			
			if(responder)responder.onProgress(this);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			if(responder)responder.onFault(this)
				
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			if(responder)responder.onFault(this)
		}
		
	}
}

