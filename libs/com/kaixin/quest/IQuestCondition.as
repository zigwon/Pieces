package com.kaixin.quest
{
	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:52:42 PM
	 */
	
	public interface IQuestCondition
	{
		function get triggerType():int;
		function get type():int;
		function get ownerFuze():IQuestFuze;
		function set ownerFuze(of:IQuestFuze):void;
		function get progresses():Array;
		function checkCondition(triggerData:QuestTriggerData=null):Boolean;
		
	}
}