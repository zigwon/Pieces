package com.kaixin.quest
{
	/**
	 *　可燃物接口 
	 * @author KAN
	 * 
	 */	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 2, 2009 5:22:01 PM
	 */
	
	public interface IQuestCombustible
	{
		/**
		 *　点火 （触发引信）
		 * 
		 */		
		function fire(from:IQuestCombustible=null):void
		
			
		/**
		 * 上级引信  
		 * @param tar
		 * 
		 */		
		function set fireTarget(tar:IQuestCombustible):void
		function get fireTarget():IQuestCombustible;
		
	}
}