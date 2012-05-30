package com.kaixin.quest
{
	
	/**
	 * 判定任务条件用的导火线接口 
	 * @author KAN
	 * 
	 */	
	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:34:14 PM
	 */
	
	public interface IQuestFuze extends IQuestCombustible
	{ 
		/**
		 * one fuze muti conditions
		 * 一个引信，多个触发条件 
		 * @param con
		 * @return 
		 * 
		 */		
		function set conditions(con:Array):void;
		function get conditions():Array;
		
		function set fireQuest(tar:QuestObject):void
		function get fireQuest():QuestObject;
		
		/**
		 *　检测是否可燃烧 （主动判断任务达成条件）
		 * 
		 */			
		function checkFire(exceptCondition:IQuestCondition=null,doFire:Boolean=true):Boolean
		
		/**
		 * the progress of one fuze
		 * 引信的触发进度 
		 * @return 
		 * 
		 */		
		function get progresses():Array;
	}
}