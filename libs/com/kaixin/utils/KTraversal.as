package com.kaixin.utils
{
	/**
	 * this class is use for make a traversal in any object,and return an object can be direct traver
	 * author:KAN
	 * mail:minzojian@hotmail.com
	 * site:lunastudio.cn
	**/
	
	import flash.utils.describeType;
	public class KTraversal
	{
		public static var VARIABLES:int=1;
		public static var WRITEONLY_ACCESSORS:int=2;
		public static var READONLY_ACCESSORS:int=4;
		public static var METHODS:int=8;
		public static var ALL_READABLE_VARIABLES:int=VARIABLES|READONLY_ACCESSORS;
		
		static public function traver(target:Object,filiter:int=0):Object
		{
			var out:*={}
			var sturcure:XML=describeType(target);			
			if ((filiter | KTraversal.VARIABLES)==filiter || filiter==0)calcNode(sturcure.variable,out,"",target);
			if ((filiter | KTraversal.WRITEONLY_ACCESSORS )==filiter ||  filiter==0)calcNode(sturcure.accessor,out,"access==writeonly");
			if ((filiter | KTraversal.READONLY_ACCESSORS)==filiter ||  filiter==0)calcNode(sturcure.accessor,out,"access==readonly",target);
			if ((filiter | KTraversal.METHODS)==filiter ||  filiter==0)calcNode(sturcure.method,out,"",target);
			return out;
		}
		static private function calcNode(xl:XMLList,obj:*,sp:String="",target:*=null):void
		{
			for each(var node:* in xl)
			{
				if(sp!="") 
				{
					var op:*=KOperator.ParseOp(sp);					
					if(!KOperator.Op(node.attribute(op[0]),op[1],op[2])){continue};
				}
				if(target!=null)obj[node.@name]=target[node.@name];
				else obj[node.@name]=null;
			}			
		}
	}
}