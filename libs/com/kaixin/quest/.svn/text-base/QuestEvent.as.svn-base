package com.kaixin.quest
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 6:23:29 PM
	 */
	
	import com.kaixin.event.KEvent;
	
	public class QuestEvent extends KEvent
	{
		public static var QUEST_UPDATE:String="questUpdate";
		public static var QUEST_CONDTION:String="questCondtion";
		public static var QUEST_COMPLETE:String="questComplete";
		
		public var condtion:QuestCondition;
		public function QuestEvent(type:String,questObject:QuestObject,cond:QuestCondition=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			condtion=cond;
			super(type,questObject,bubbles, cancelable);
		}
	}
}