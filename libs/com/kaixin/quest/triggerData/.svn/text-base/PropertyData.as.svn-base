package com.kaixin.quest.triggerData
{
	
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 4, 2009 4:31:39 PM
	 */
	import com.kaixin.quest.QuestTriggerData;
	public class PropertyData extends QuestTriggerData
	{
		public var propTarget:*;
		public var propName:String;
		public var propValue:*;
		public var propOp:String
		public function PropertyData(propTarget:*,propName:String,propValue:*,propOp:String="==")
		{
			this.propTarget=propTarget;
			this.propName=propName;
			this.propValue=propValue;
			this.propOp=propOp;
		}
		override public function compare(data:QuestTriggerData) : Boolean
		{
			var propData:PropertyData=PropertyData(data);
			return propData.propTarget==this.propTarget &&
				propData.propName==this.propName &&
				propData.propOp==this.propOp;	
		}
		public function get propRealValue():*
		{
			if(this.propTarget[this.propName]==null)return 0;
			return this.propTarget[this.propName];
		}
	}
}