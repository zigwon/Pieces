package org.interfaces
{
	public interface ILoader
	{
		/**
		 *加载标识 
		 * @return 
		 * 
		 */		
		function get name():String
		/**
		 * 获取加载路径 
		 * @return 
		 * 
		 */		
		function get url():String
		/**
		 * 获取加载数据 
		 * @return 
		 * 
		 */			
		function get data():*
			
		/**
		 * 获取加载进度
		 * @return 
		 * 
		 */			
		function get progress():Number
		/**
		 *  是否 加载 状态
		 * @return 
		 * 
		 */		
		function get isloading():Boolean
		
		/**
		 *开始加载 
		 * 
		 */			
		function initLoad():void
			
		/**
		 *停止加载 
		 * 
		 */			
		function stopLoad():void
				
			
	}
}