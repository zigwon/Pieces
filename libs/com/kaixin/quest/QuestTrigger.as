package com.kaixin.quest
{
	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 2, 2009 11:26:44 AM
	 */
	
	public class QuestTrigger
	{
		/**
		 *　道具数量变化的触发 
		 */		
		public static var TYPE_ITEM_CHANGE:int=0;
		/**
		 *　属性变化的触发 
		 */
		public static var TYPE_PROP_CHANGE:int=1;
		/**
		 *　引信点燃后的触发 
		 */
		public static var TYPE_FUZE_FIRE:int=2;
		/**
		 *　任务达成后的触发 
		 */
		public static var TYPE_QUEST_COMPLETE:int=3;
		/**
		 *　其它情况下触发 
		 */
		public static var TYPE_OTHERS:int=4;
		
		
		public var type:int;		
		public var triggerData:QuestTriggerData;
		
		/**
		 * 触发来源
		 * 可能是来自用户的直接呼叫,则此值不定义(根引信上的条件触发)
		 * 也有可能来自引信盒子里(支引信触发其它引信)或任务盒子(任务结束时触发)
		 */		
		public var triggerTarget:IQuestCombustible;
		
		public function QuestTrigger(type:int,triggerData:QuestTriggerData=null)
		{
			this.type=type;
			if(triggerData!=null)
			{
				this.triggerData=triggerData;
				trigger();
			}
			
		}
		public function trigger(triggerData:QuestTriggerData=null):void
		{
			if(triggerData!=null)this.triggerData=triggerData;

			QuestFuzeBox.instance().trigger(this);
			//override by child class
		}
	}
}