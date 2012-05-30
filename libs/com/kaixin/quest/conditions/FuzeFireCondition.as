package com.kaixin.quest.conditions
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:57:10 PM
	 */
	
	import com.kaixin.quest.IQuestFuze;
	import com.kaixin.quest.QuestCondition;
	import com.kaixin.quest.QuestTrigger;
	import com.kaixin.quest.QuestTriggerData;
	import com.kaixin.quest.triggerData.FuzeFireData;
	
	public class FuzeFireCondition extends QuestCondition
	{
		/**
		 * 判断的目标引信，即“引信点燃”是由哪个引信传来 
		 */		
		public var targetFuze:IQuestFuze
		public function FuzeFireCondition(conditionData:FuzeFireData)
		{
			super(this._triggerType=QuestTrigger.TYPE_FUZE_FIRE,conditionData);
			this.targetFuze=conditionData.targetFuze;
		}
		override public function checkCondition(triggerData:QuestTriggerData=null):Boolean
		{
		//当没有判断依据传过来时，那通常是在做从上到下的主动判断的时候，这时，我们把这一查询递归下去
			if(triggerData==null)return this.targetFuze.checkFire(null,false);	
			return FuzeFireData(triggerData).targetFuze==this.targetFuze;
		}
	}
}