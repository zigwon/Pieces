package org.manager
{	
	import flash.system.ApplicationDomain;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class GlobalManager
	{
		/**
		 *默认域 
		 */		
		public var defaultDomain:ApplicationDomain
		/**
		 *主容器
		 */		
		public var stage:Stage	
		/**
		 *主UI容器
		 */		
		public  const  uiContainer:Sprite=new Sprite()
		/**
		 *主人id 
		 */		
		public var userId:String
			
			
		/**
		 *单例 
		 */
		private static var _instance:GlobalManager
		
		public static function get instance():GlobalManager{
			return _instance||(_instance=new GlobalManager(new Singleton()))
		}
		
		public function GlobalManager(singleton:Singleton){}
		
		
		/**
		 * 初始化
		 */
		public  function initialize(container:Stage):void{
			defaultDomain=ApplicationDomain.currentDomain;
				
			stage=container;
			
			stage.addChild(uiContainer);
		}
	}
}

class Singleton{}