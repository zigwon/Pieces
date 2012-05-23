package org.net
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.interfaces.ILoader;
	
	/**
	 * 异步操作结果捕捉类 
	 * @author Administrator
	 * 
	 */	
	public class AbcResponder
	{
		/**
		 * 返回结果处理
		 *onComplete(loader:ILoader) 
		 */		
		public var loading:MovieClip
		/**
		 * 返回结果处理
		 *onComplete(loader:ILoader) 
		 */		
		public var onComplete:Function
		/**
		 * 返回成功结果
		 *onResult(loader:ILoader) 
		 */		
		public var onResult:Function
		
		/**
		 * 返回加载进度
		 *onResult(loader:ILoader) 
		 */		
		public var onProgress:Function
		
		/**
		 * 返回失败结果
		 *onResult(loader:ILoader) 
		 */
		public var onFault:Function
		
		public function AbcResponder():void { 
			
			onComplete=function(loader:ILoader):void{   }
			
			onResult=function(loader:ILoader):void{   }
			
			onProgress=function(loader:ILoader):void{}
			
			onFault=function(loader:ILoader):void{ 
				trace("出错了"+loader.url);
				// throw new Error("出错了"+loader.url)
			}
			
		}
		
	}   
}