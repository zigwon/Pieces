package com.kaixin.utils
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*Aug 11, 2009 7:07:18 PM
	*/
	
	public class KReplacer
	{
		static private var MAX_LOOP:int=300;
		public function KReplacer()
		{
		}
		public static function replace(str:String,condition:*=null,replaces:*=null):String
		{
			if(condition==null){condition=/{(?P<var>[^{}]*)}/i;}
			if(replaces==null){replaces={};}
			
			if(condition is String)
			{
				var r:String="";
				if(replaces is Array)
				{
					r=replaces.join();
				}else if(replaces is String)
				{
					r=replaces 
				}
				return str.replace(	condition,r);
			}else if(condition is Array)
			{
				var ar:Array=[]
				if(replaces is Array)
				{
					ar=replaces	
				}else{
					ar=[replaces]
				}
				for(var c:int=0;c<condition.length;c++)
				{
					var cr:*
					if(ar[c]==null){cr=""}else{cr=ar[c]}
					str=replace(str,condition[c],cr)	
				}	
				return str
			}else if(condition is RegExp)
			{
				
				var searchEnd:Boolean=false;
				var trueLastIndex:int;
				var searchIndex:int=0;
				var loop_times:int=0
			
				while(!searchEnd){
					var result:*=condition.exec(str)
					for(var key:* in result)
					{
						if(isNaN(key)&& key!="index" && key!="input")
						{
							var keyMap:*=result[key]
							if(replaces[keyMap]==null){replaces[keyMap]=""}
							str=str.replace(condition,replaces[keyMap]);
							//loop_times++
							//if(loop_times<=MAX_LOOP){
								condition.lastIndex=0
							//}														
						}
					}					
					trueLastIndex=condition.lastIndex
					searchEnd=!condition.test(str)
					condition.lastIndex=trueLastIndex
				}
				condition.lastIndex=0;
				return str
			}
			return ""
		}
		
	}
}