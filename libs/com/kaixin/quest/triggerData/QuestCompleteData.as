package com.kaixin.quest.triggerData
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:59:58 PM
	 */
	import com.kaixin.quest.QuestTriggerData;
	import com.kaixin.quest.QuestObject;

	public class QuestCompleteData extends QuestTriggerData
	{
		public var targetQuest:QuestObject
		public function QuestCompleteData(targetQuest:QuestObject)
		{
			super();
			this.targetQuest=targetQuest;
		}
	}
}