package com.kaixin.quest
{
	import com.kaixin.quest.conditions.FuzeFireCondition;
	import com.kaixin.quest.fuzes.BranchFuze;
	
	import flash.utils.Dictionary;
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 2, 2009 3:18:21 PM
	 */
	
	public class QuestFuzeBox
	{
		private static var questFuzeBox:QuestFuzeBox;
		
		private var fuzebox:Dictionary;
			
		public function QuestFuzeBox(single:singleton)
		{
			//按触发类型而划分成5种不同的引信盒子,分流查询时的遍历
			fuzebox=new Dictionary(true);
			fuzebox[QuestTrigger.TYPE_ITEM_CHANGE]		=	new Dictionary(true);
			fuzebox[QuestTrigger.TYPE_PROP_CHANGE]		=	new Dictionary(true);
			fuzebox[QuestTrigger.TYPE_FUZE_FIRE]		=	new Dictionary(true);
			fuzebox[QuestTrigger.TYPE_QUEST_COMPLETE]	=	new Dictionary(true);
			fuzebox[QuestTrigger.TYPE_OTHERS]			=	new Dictionary(true);
		}
		/**
		 * 实例只能通过同包的QuestManager来创建 
		 * @return 
		 * 
		 */		
		internal static function instance():QuestFuzeBox
		{
			if(questFuzeBox==null)questFuzeBox=new QuestFuzeBox(new singleton());
			return questFuzeBox;
		}
		/**
		 * 一个触发器触发了! 
		 * @param trig
		 * 
		 */		
		public function trigger(trig:QuestTrigger):void
		{
			var conds:Dictionary=fuzebox[trig.type];
			//检测条件容器里是否有满足条件的
			for each(var item:IQuestCondition in conds)
			{
				if(item.checkCondition(trig.triggerData))
				{
					//满足的条件对象引信对象进行排除触发源之外的条件检测
					item.ownerFuze.checkFire(item);
				};
				//注意：强制刷新全部任务进度（看QUESTUPDATE是否有必要。否则是不应该使用它的）
				//QuestManager.instance().questUpdate(item.ownerFuze.fireQuest);
			}
		}
		
		
		/**
		 * 添加引信 ,（递归添加其下的所有子孙引信）
		 * @param fuze
		 * 
		 */		
		public function addFuze(fuze:IQuestFuze):void
		{
			if(fuze.fireQuest==null)fuze.fireQuest=QuestObject(fuze);
			var conds:Array=fuze.conditions;
			
			conds.forEach(
				function(item:IQuestCondition,index:int,vector:Array):void
				{
					fuzebox[item.triggerType][item]=item;
					item.ownerFuze=fuze;
					if(item is FuzeFireCondition)
					{
						FuzeFireCondition(item).targetFuze.fireQuest=fuze.fireQuest;
						addFuze(FuzeFireCondition(item).targetFuze);
					}
				}
			)
		}
		/**
		 * 移除引信 ,递归移除其下的所有子孙引信
		 * @param fuze
		 * 
		 */		
		public function removeFuze(fuze:IQuestFuze):void
		{
			var conds:Array=fuze.conditions;
			
			conds.forEach(
				function(item:IQuestCondition,index:int,vector:Array):void
				{
					fuzebox[item.triggerType][item]=null;
					if(item is FuzeFireCondition)
					{
						removeFuze(FuzeFireCondition(item).targetFuze);
					}
				}
			)
		}
	}
}
class singleton{};