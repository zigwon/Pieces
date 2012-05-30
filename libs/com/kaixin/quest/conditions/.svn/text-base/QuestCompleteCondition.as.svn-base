package com.kaixin.quest.conditions
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:58:36 PM
	 */
	
	import com.kaixin.quest.QuestCondition;
	import com.kaixin.quest.QuestManager;
	import com.kaixin.quest.QuestObject;
	import com.kaixin.quest.QuestProgress;
	import com.kaixin.quest.QuestTrigger;
	import com.kaixin.quest.QuestTriggerData;
	import com.kaixin.quest.triggerData.QuestCompleteData;
	
	public class QuestCompleteCondition extends QuestCondition
	{
	
		private var progress:QuestProgress;
		private var _progresses:Array;
		
		public var targetQuest:QuestObject
		public function QuestCompleteCondition(conditionData:QuestCompleteData=null)
		{
			super(QuestTrigger.TYPE_QUEST_COMPLETE, conditionData);
			this.targetQuest=conditionData.targetQuest;
			progress=new QuestProgress(this);
			_progresses=new Array()
			_progresses.push(progress);
		}
		override public function checkCondition(triggerData:QuestTriggerData=null):Boolean
		{
			var res:Boolean;
			//当没有判断依据传过来时，那通常是在做从上到下的主动判断的时候，这时，我们把这一查询递归下去
			if(triggerData==null)
			{
				res=this.targetQuest.checkFire(null,false);
				if(res)QuestManager.instance().questCondtion(this.ownerFuze.fireQuest,this);
			return res
			}
			//判断的依据可以自定义，这里我们根据任务的ID来判断
			res=QuestCompleteData(triggerData).targetQuest.id==this.targetQuest.id;
			if(res)QuestManager.instance().questCondtion(this.ownerFuze.fireQuest,this);
			return res;	
			//return QuestCompleteData(triggerData).targetQuest==this.targetQuest;
		}
		override public function get progresses():Array
		{
			return _progresses;
		};
	}
}