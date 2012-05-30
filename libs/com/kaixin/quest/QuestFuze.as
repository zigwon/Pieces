package com.kaixin.quest
{
	import com.kaixin.quest.conditions.FuzeFireCondition;
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Oct 27, 2009 4:56:58 PM
	 */
	
	public class QuestFuze implements IQuestFuze
	{
		
		private var _condtions:Array=new Array;
		
		public function set conditions(con:Array):void
		{
			_condtions=con;
		}
		public function get conditions():Array
		{
			return _condtions;
		}
		private var _fireQuest:QuestObject;
		public function set fireQuest(tar:QuestObject):void
		{
			this._fireQuest=tar;
		};
		public function get fireQuest():QuestObject
		{
			return this._fireQuest;
		};
		
		private var _fireTarget:IQuestCombustible;
		public function set fireTarget(tar:IQuestCombustible):void
		{
			this._fireTarget=tar;
		};
		public function get fireTarget():IQuestCombustible
		{
			return this._fireTarget;
		};
		
		public function get progresses():Array
		{
			var progVector:Array=new Array;
			this.conditions.forEach(
				function(item:IQuestCondition,index:int,vector:Array):void
				{
					progVector=progVector.concat(item.progresses);
				}
			);
			return progVector;
		};
		
		public function QuestFuze()
		{
		}
		
		
		
		/**
		 *　点燃引信将会触发＂引信点燃＂ 
		 * @param from 如果值不为空，那通常是下级引信
		 * 
		 */
		public function fire(from:IQuestCombustible=null):void
		{
			if(from!=null)
			{
				this.conditions.some(
					function(item:IQuestCondition,index:int,vector:Array):Boolean
					{
						if((item is FuzeFireCondition) && (from is IQuestFuze))
						{
							if(FuzeFireCondition(item).targetFuze==IQuestFuze(from))
							{
								this.fireTarget.checkFire(FuzeFireCondition(item));
								return true;
							}
						}
						return false;
					}
				)
			}
			
			
			
			//触发引信点燃的事件
			//new FuzeFireTrigger().trigger(new FuzeFireData(this));
			
		}
		
		public function checkFire(exceptCondtion:IQuestCondition=null,doFire:Boolean=true):Boolean
		{
			//检测条件是否满足
			
			//假设条件已经达成
			var ok:Boolean=true;
			this.conditions.some(
				function(item:IQuestCondition,index:int,vector:Array):Boolean
				{
					if(item!=exceptCondtion){
						//如果子条件点燃对象不是当前判断的发出者
						if(item.type==QuestCondition.TYPE_SUFFICIENT && item.checkCondition())
						{
							//如果子条件是充分条件且已经满足点燃条件
							ok=true;
							return true;
						}else if(item.type==QuestCondition.TYPE_NECESSARY && !item.checkCondition())
						{
							//如果子条件是必要条件且未满足点燃条件
							ok=false;
							return false;
						}
					}
					return false;
					
				}
			);
			if(ok && doFire)this.fireTarget.fire(this);
			return ok;
		}
		
	}
}