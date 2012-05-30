package com.kaixin.quest
{
	import com.kaixin.quest.triggerData.QuestCompleteData;
	import com.kaixin.quest.triggers.QuestCompleteTrigger;
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:13:10 PM
	 */
	
	public class QuestObject extends QuestFuze
	{
		/**
		 * 是否是锁定状态 
		 */
		public function get isLock():Boolean
		{
			return course==LOCK;
		}
		/**
		 * 是否是锁定状态 
		 */
		public function get isFinish():Boolean
		{
			return course==DONE;
		};	
		
		/**
		 * 是否是放弃状态 
		 */
		public function get isGiveUp():Boolean
		{
			return course==GIVEUP;
		};	
		
		public function get isDoing():Boolean
		{
			return course==DOING;
		}
		
		public function get isExpired():Boolean
		{
			return course==EXPIRED;
		}
		
		/**
		 * 任务的过程状态 
		 */		
		public var course:int; 
		
		public static var LOCK:int=0;
		public static var DOING:int=1;
		public static var DONE:int=2;
		public static var EXPIRED:int=3;
		public static var GIVEUP:int=4;
		
		/**
		 * 任务ID 
		 */		
		private var _id:int;

		public function get id():int
		{
			return _id;
		}

		/**
		 * 任务标题 
		 */
		public var title:String="";
		/**
		 * 任务说明 
		 */		
		public var desc:String="";
		/**
		 * 任务开始时间 
		 */		
		public var startTime:String="";
		/**
		 * 任务结束时间 
		 */		
		public var endTime:String="";		
		/**
		 * 奖励列表 
		 */
		public var rewards:Array;	
		
				
		
		public function QuestObject(id:int,tile:String="",desc:String="")
		{
			this.fireTarget=this;
			this._id=id;
			init(title,desc);
		}
		public function init(title:String="",desc:String=""):void
		{
			this.title=title;
			this.desc=desc;
		}
		/**
		 *　点燃任务将会触发＂任务完成＂ 
		 * 
		 */		
		override public function fire(from:IQuestCombustible=null):void
		{
			//this.fireTarget.checkFire(this);
			//触发引信点燃的事件
			course=DONE;
			QuestManager.instance().questComplete(this);
			var questCompleteTrigger:QuestCompleteTrigger=new QuestCompleteTrigger();
			questCompleteTrigger.triggerTarget=this;
			questCompleteTrigger.trigger(new QuestCompleteData(this));
		}
		override public function checkFire(exceptCondtion:IQuestCondition=null,doFire:Boolean=true):Boolean
		{
			if(course==DONE)return true;
			else return super.checkFire(exceptCondtion,doFire);
		}
	}
}