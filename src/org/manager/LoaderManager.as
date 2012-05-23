package org.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.interfaces.IManager;
	import org.net.AbcResponder;
	import org.interfaces.ILoader;

	/**
	 * 加载管理
	 * @author Administrator
	 * 
	 */	
	public class LoaderManager implements IManager
	{	
		
		/**
		 *单例 
		 */
		private static var _instance:LoaderManager
		
		public static function get instance():LoaderManager{
			return _instance||(_instance=new LoaderManager(new Singleton()))
		}
		
		
		public function LoaderManager(singleton:Singleton)
		{
		}
		
		/**
		 * 初始化
		 * 
		 */		
		public function initialize():void{
			//init				
		}
		
		/**
		 * 注册 单一加载 类型  
		 * @param loader  AbcLoaderText or AbcLoaderBinary
		 * @param url     加载地址
		 * @param event   响应回调逻辑处理方法
		 * @param domain  域
		 * @param name    加载标志
		 * @param container 加载容器，如果有则显示加载进度
		 */		
		public function registerLoadHandler(loader:Class,url:String,onResult:Function=null,domain:ApplicationDomain=null,name:String="",onProgress:Function=null,container:Sprite=null,onFault:Function=null):void{
			
			var responder:AbcResponder=new AbcResponder();
			
			responder.onResult=onResult||responder.onResult;
			responder.onProgress=onProgress||responder.onProgress;
			responder.onFault=onFault||responder.onFault;
			
			//domain=	domain||GlobalManager.instance.defaultDomain
			
			var _loader:ILoader=new loader(url,responder,domain,name);
			
			//showLoading(_loader,responder,container);
			
			_loader.initLoad();
			
		}
	}
}


class Singleton{}
