package org.utils
{
	/**
	 * 字符串处理 
	 * @author Administrator
	 * 
	 */    
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		//把第一个字母改成 大写
		public static function onewordUp(value:String):String{
			
			
			return value.replace(new RegExp(value.charAt(0)),value.charAt(0).toUpperCase())

		}
		
		//把第一个字母改成 小写
		public static function onewordLower(value:String):String{

			return value.replace(new RegExp(value.charAt(0)),value.charAt(0).toLowerCase())
			
		}
		
		/**
		 * 解析公式为数组类型
		 * @param	formulaStr
		 * @return  
		 */
		public static function parseFormula(formulaStr:String):Array
		{
			var formula:Array=[]
			
			if (formulaStr != "" && formulaStr != null)
			{
				
				var list:Array = formulaStr.split("|");
				
				var i:int = 0;
				
				var c:int = list.length;
				
				while (i < c)
				{
					
					var data:String = list[i];
					
					var result:Array = data.split("*");
					
					formula[i] = [];
					
					for(var k:int=0;k<result.length;k++){
					
						formula[i].push(result[k])
					
					}
					
					i++;
					
				}
			}
			
			return formula;
		}
		
		/**
		 * 解析公式为字典类型
		 * @param	formulaStr  公式字符串
		 * @param	isreverse   是否反转键值
		 * @return
		 */
		public static function reparseFormulaObject(formulaStr:String,isreverse:Boolean=false):Object
		{
			var formula:Object={}
			
			if (formulaStr != "" && formulaStr != null)
			{
				
				var list:Array = formulaStr.split("|");
				
				var i:int = 0;
				
				var c:int = list.length;
				
				while (i < c)
				{
					
					var data:String = list[i];
					
					var result:Array = data.split("*");
					
					isreverse?formula[result[0]]=result[1]:formula[result[1]]=result[0];
					
					i++;
					
				}
				
			}
			
			return formula;
		}
		
		/**
		 * [5173,move,,5,false]
		 * 
		 * 取得5173并返回
		 * 搜索标志位之前的字符串,遇到forw结束，并返回
		 */		
		public static function searchStrForwardIco(str:String,ico:String,forw:String="["):String{
			var curnumEnd:int=str.indexOf(ico,0)
			var curnumStart:int
			var uid:String
			
			//找到开始索引
			for(var i:int=curnumEnd-1;i>=0;i--){	
				if(str.charAt(i)==forw){//遇到forw结束，确定起始索引
					curnumStart=i+1
					break;
				}
			}
			uid=str.slice(curnumStart,curnumEnd)
			return uid
		}
		
		
		//去左右空格;  
		public static function trim(char:String):String{  
			if(char == null){  
				return null;  
			}  
			return rtrim(ltrim(char));  
		}  
		
		//去左空格;   
		public static function ltrim(char:String):String{  
			if(char == null){  
				return null;  
			}  
			var pattern:RegExp = /^\s*/;   
			return char.replace(pattern,"");  
		}  
		
		//去右空格;  
		public static function rtrim(char:String):String{  
			if(char == null){  
				return null;  
			}  
			var pattern:RegExp = /\s*$/;   
			return char.replace(pattern,"");  
		}  
		

	}
}