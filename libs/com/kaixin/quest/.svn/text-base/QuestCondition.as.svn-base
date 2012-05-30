package com.kaixin.quest
{
	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:13:29 PM
	 */
	
	public class QuestCondition implements IQuestCondition
	{
		/**
		 * 充分条件 
		 * 如果该条件是充分条件，则一旦该条件达成，则条件对应的引信被点燃
		 */		
		public static var TYPE_SUFFICIENT:int=1;
		/**
		 *　必要条件 
		 * 如果该条件是必要条件，则只有所有必要条件达成时，条件对应的引信才被点燃
		 */		
		public static var TYPE_NECESSARY:int=2;
		
		/**
		 * 激活类型
		 * @see QuestTrigger 
		 */		
		protected var _triggerType:int=0;
		public function get triggerType():int
		{
			return this._triggerType;
		};
		/**
		 * 条件类型
		 * @see TYPE_SUFFICIENT
		 * @see TYPE_NECESSARY
		 */		
		private var _type:int=2;
		public function get type():int
		{
			return this._type;
		};
		
		/**
		 * 条件所属的引信 
		 */
		private var _ownerFuze:IQuestFuze;

		public function get ownerFuze():IQuestFuze
		{
			return _ownerFuze;
		};

		public function set ownerFuze(value:IQuestFuze):void
		{
			_ownerFuze = value;
		};
		
		
		public function get progresses():Array
		{
			//override by child class
			//return this._targetFuze.progresses;
			return null;
		};
		
		private var _triggerData:QuestTriggerData;
		public function get triggerData():QuestTriggerData
		{
			return this._triggerData;
		}
		
		public function QuestCondition(triggerType:int=0,triggerData:QuestTriggerData=null)
		{
			this._triggerType=triggerType;
			this._triggerData=triggerData;
		};
		public function checkCondition(triggerData:QuestTriggerData=null):Boolean
		{
			//override by child class;
			return true;
		};
		
	}
}