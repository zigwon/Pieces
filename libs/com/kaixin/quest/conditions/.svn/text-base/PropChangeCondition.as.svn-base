package com.kaixin.quest.conditions
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:19:59 PM
	 */
	
	import com.kaixin.quest.QuestCondition;
	import com.kaixin.quest.QuestManager;
	import com.kaixin.quest.QuestProgress;
	import com.kaixin.quest.QuestTrigger;
	import com.kaixin.quest.QuestTriggerData;
	import com.kaixin.quest.triggerData.PropertyData;
	import com.kaixin.utils.KOperator;
	
	public class PropChangeCondition extends QuestCondition
	{ 
		private var progress:QuestProgress;
		private var _progresses:Array;
		public var propertyData:PropertyData
		public function PropChangeCondition(propertyData:PropertyData=null)
		{
			super(QuestTrigger.TYPE_PROP_CHANGE,propertyData);
			this.propertyData=propertyData;
			progress=new QuestProgress(this);
			_progresses=new Array()
			_progresses.push(progress);
			
		}
		override public function checkCondition(triggerData:QuestTriggerData=null):Boolean
		{
			//当没有判断依据传过来时，那通常是在做从上到下的主动判断的时候，这时，我们把这一查询递归下去
			var res:Boolean;
			if(triggerData==null)
			{	progress.done=propertyData.propRealValue;
				progress.total=propertyData.propValue;
				res=KOperator.Op(propertyData.propRealValue,propertyData.propOp,propertyData.propValue);
				if(res)QuestManager.instance().questCondtion(this.ownerFuze.fireQuest,this);
				return res;
			}	
			if(this.propertyData.compare(triggerData))
			{
				progress.done=PropertyData(triggerData).propValue;
				progress.total=propertyData.propValue;
				res=KOperator.Op(PropertyData(triggerData).propValue,PropertyData(triggerData).propOp,propertyData.propValue);
				if(res)QuestManager.instance().questCondtion(this.ownerFuze.fireQuest,this);
				return res;
			}
			return false;
		}
		override public function get progresses():Array
		{
			return _progresses;
		};
	}
}