package com.kaixin.quest.triggerData
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:51:04 PM
	 */
	
	import com.kaixin.quest.IQuestFuze;
	import com.kaixin.quest.QuestTriggerData;
	
	public class FuzeFireData extends QuestTriggerData
	{
		public var targetFuze:IQuestFuze;
		public function FuzeFireData(targetFuze:IQuestFuze)
		{
			this.targetFuze=targetFuze;
			super();
		}
	}
}