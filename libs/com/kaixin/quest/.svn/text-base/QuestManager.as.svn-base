package com.kaixin.quest
{
	import flash.events.EventDispatcher;
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:15:26 PM
	 */
	
	public class QuestManager extends EventDispatcher
	{
		private static var questManager:QuestManager;
		private var quests:Array=new Array;
		private var fuzebox:QuestFuzeBox;
		public function QuestManager(single:singleton)
		{
			fuzebox=QuestFuzeBox.instance();
		}
		public static function instance():QuestManager
		{
			if(questManager==null)questManager=new QuestManager(new singleton());
			return questManager;
		}
		
		public function getQuest(id:int):QuestObject
		{
			for each(var quest:QuestObject in quests)
			{
				if(quest.id==id)
				{
					return quest;
				}
			}
			return null;
		}
		public function getAllQuests():Array
		{
			return quests;
		}
		/**
		 * 建立任务
		 * 不同的项目建立任务的方式不同
		 * 由子类继承去实现该方法 
		 * 
		 */		
		public function addQuest(questObject:QuestObject):void
		{
			fuzebox.addFuze(questObject);
		}
		
		public function removeQuest(questObject:QuestObject):void
		{
			fuzebox.removeFuze(questObject);
		}
		
		
		public function questComplete(questObject:QuestObject):void
		{
			this.dispatchEvent(new QuestEvent(QuestEvent.QUEST_COMPLETE,questObject));
		}
		public function questUpdate(questObject:QuestObject):void
		{
			this.dispatchEvent(new QuestEvent(QuestEvent.QUEST_UPDATE,questObject));
		}
		public function questCondtion(questObject:QuestObject,cond:QuestCondition):void
		{
			this.dispatchEvent(new QuestEvent(QuestEvent.QUEST_CONDTION,questObject,cond));
		}
		public function trigger(trig:QuestTrigger):void
		{
			this.fuzebox.trigger(trig);
		}
		
	}
}
class singleton{};