package com.kaixin.data
{
	import com.kaixin.utils.KOperator;

	/**WWW.LUNASTUDIO.CN
	*KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-6-19 ����11:46:20
	*/
	
	public class KSQL
	{
	/*	private var _command:String="";
		public function set Command(c:String):void
		{
			this._command=c;
		}
		public function get Command():String
		{
			return this._command;
		}
		public function KRSSQL()
		{
		}*/
		private static var SELECT:RegExp=/SELECT (?P<columns>.*?) FROM (?P<tables>.*?)( WHERE (?P<condtion>.*))?( ORDER BY ((?P<sortCondtion>.*)(?P<sortType> DESC| ASC| $)))/ig;		
		private static var UPDATE:RegExp=/UPDATE (?P<table>.*?) SET (?P<newvalues>.*?) WHERE (?P<condtion>.*)/ig;
		private static var INSERT:RegExp=/INSERT INTO (?P<table>.*)/ig;
		private static var DELETE:RegExp=/DELETE (?P<table>.*) WHERE (?P<condtion>.*)/ig;
		private static var ANDS:RegExp=/(?: AND )?((?P<parameter>[^@><=! ]+)(?P<operation>[@><=!]+)(?P<value>[^@><=! ]+)).*?/ig;
		private static var COMMAS:RegExp=/(?:,)?((?P<parameter>[^*,]+)).*?/ig
		private static var COMMAVALUES:RegExp=/(?:,)?((?P<parameter>[^@><=!, ]+)(?P<operation>[@><=!]+)(?P<value>[^@><=!, ]+)).*?/ig
		private static var DOTS:RegExp=/((?P<target>[^\.]+)\.(?P<property>[^\.]+))/ig
		private static var BRACE:RegExp=/^{(?P<parameter>.*)}$/ig
		private static var BRACKET:RegExp=/^\[(?P<parameter>.*)\]$/ig
		private static var operation:RegExp=/(?P<parameter>[^@><=! ]+)(?P<operation>[@><=!]+)(?P<value>[^@><=! ]+)/ig;
		private static var CALCULATION:RegExp=/(?P<parameterA>[^\+\-\*\/]+)(?P<operation>[\+\-\*\/]+)(?P<parameterB>[^\+\-\*\/]+)/ig;
		
		private static var SELECT_PRE:RegExp=/^SELECT/ig
		private static var UPDATE_PRE:RegExp=/^UPDATE/ig
		private static var DELETE_PRE:RegExp=/^DELETE/ig
		private static var INSERT_PRE:RegExp=/^INSERT INTO/ig
		
		public static function execute(db:KDataBase,query:String,dataHolder:*=null):*
		{
			SELECT.lastIndex=0;
			ANDS.lastIndex=0;
			COMMAS.lastIndex=0;
			SELECT_PRE.lastIndex=0;
			UPDATE_PRE.lastIndex=0;
			DELETE_PRE.lastIndex=0;
			INSERT_PRE.lastIndex=0;
			
			if(SELECT_PRE.test(query)){
				return doSelect(db,query);
			}else if(UPDATE_PRE.test(query)){
				return doUpdate(db,query,dataHolder);
			}else if(DELETE_PRE.test(query)){
				return doDelete(db,query);
			}else if(INSERT_PRE.test(query)){
				return doInsert(db,query,dataHolder);
			}else{
				throw new Error("invalid query head")
			}		
			return null;	
		}
		private static function doSelect(db:KDataBase,query:String):KRecordSet
		{
			
			var phy:*=SELECT.exec(query);
			var columnStr:String=phy.columns;
			var tableStr:String=phy.tables;
			var condStr:String=phy.condtion
			var sortCondStr:String=phy.sortCondtion
			var sortTypeStr:String=phy.sortType
			
			var columns:Array=[]
			var columnsLen:int=columnStr.match(COMMAS).length;
			COMMAS.lastIndex=0;
			for(var c:int=0;c<columnsLen;c++)
			{
				var col:*=COMMAS.exec(columnStr);
				columns.push(col.parameter);				
			}
			
			var tables:Array=[]
			var tablesLen:int=tableStr.match(COMMAS).length;
			COMMAS.lastIndex=0;
			for(var t:int=0;t<tablesLen;t++)
			{
				var tabout:*=COMMAS.exec(tableStr);
				tables.push(tabout.parameter);				
			}
			
			var conds:Array=[]
			var condsLen:int=condStr.match(ANDS).length;
			////trace(condStr.match(ANDS))
			ANDS.lastIndex=0;
			for(var i:int=0;i<condsLen;i++)
			{				
				var out:*=ANDS.exec(condStr);
				conds.push([out.parameter,out.operation,out.value])
			}
			var sortConds:Array=[]
			var sortCondsLen:int=sortCondStr.match(COMMAS).length;
			
			var sortType:String=sortTypeStr==" DESC"?"DESC":"ASC"
			
			/////开始查询操作!嚎~~~!!!
			
			var rs:KRecordSet
			
			//判断是不是关联查询
			
			if(tables.length>1){				
				var unionconds:Array=[];
				var simpleconds:Array=[]; 	
				for each(var cond:* in conds)
				{
					DOTS.lastIndex=0;
					var checkLeft:Boolean=DOTS.test(cond[0]);
					DOTS.lastIndex=0;
					var checkRight:Boolean=DOTS.test(cond[2]);
					
					if(!checkLeft && !checkRight){throw new Error("need use the full name while use union search")}
					var out:*
					if(checkLeft){
						DOTS.lastIndex=0;
						out=DOTS.exec(cond[0])
						cond[0]=[out.target,out.property]
					}
					if(checkRight){
						DOTS.lastIndex=0;
						out=DOTS.exec(cond[2])
						cond[2]=[out.target,out.property]
					}
					
					if(checkLeft!=checkRight){	
						simpleconds.push(cond);					
					}else{
						if(cond[1]!="="){throw new Error("link operation only equals '='")}
						unionconds.push(cond);
					}					
				}	
				
				if(unionconds.length==0){throw new Error("need define the link condition between two tables")}
				
				
				//建立临时数据库及临时表
				//然后先进行单表内条件查询
				var tmpDB:*={};
				var tableABData:Array=new Array(tables.length);
				var tableIndexs:*={}
				var tableDatas:Array=[]
				for(var t:int=0;t<tables.length;t++)
				{
					var tab:*=tables[t];
					var tconds:Array=[];
					for each(var sc:* in simpleconds)
					{
						if(sc[0] is Array){
							if(sc[0][0]==tab){
								sc[0]=sc[0].join(".");
								tconds.push(sc);
							}					
						}					
					}	
					if(db.tables[tab]==null)throw new Error("table is not exsit");
					tmpDB[tab]=KTable(db.tables[tab]).clone(true);
					KTable(tmpDB[tab]).createFromDataGrid(processSingleSearch(tmpDB[tab],"SELECT",tconds))
					tableABData[t]=[];
					tableIndexs[tab]=t;
					tableDatas.push(tmpDB[tab])
				}				
				//再进行联合查询	
				var hasPushedDataIn:Boolean=false;			
				for each(var unicond:* in unionconds)
				{
					var tableA:KTable=tmpDB[unicond[0][0]];
					var tableB:KTable=tmpDB[unicond[2][0]];
					var tableAindex:*=tableIndexs[unicond[0][0]];
					var tableBindex:*=tableIndexs[unicond[2][0]];
					var tableAlen:int=tableA.Data.length;
					var tableBlen:int=tableB.Data.length;
					unicond[0]=unicond[0].join(".");
					unicond[2]=unicond[2].join(".");
					
					var tableAkey:int=tableA.Header.Keys[unicond[0]].index
					var tableBkey:int=tableB.Header.Keys[unicond[2]].index
					
					if(hasPushedDataIn){		
						
						var tableAdata:*=tableABData[tableAindex]
						
						for(var ta:int=0;ta<tableAdata.length;ta++)
						{
							var dataA:*=tableAdata[ta][tableAkey]
							var hasData:Boolean=false;
							for(var tb:int=0;tb<tableB.Data.length;tb++)
							{
								
								
								
								var dataB:*=tableB.Data[tb][tableBkey]
								if(dataA==dataB)
								{
									hasData=true;
									
									//tableABData[tableAindex].push(tableA.Data[ta]);
									tableABData[tableBindex].push(tableB.Data.splice(tb,1)[0]);
									
									for(var ii:String in tableABData)
									{
										if(ii!=tableBindex)
										{
											tableABData[ii].splice(ta,0,tableABData[ii][ta])
										}
									}
									
									break;
								}
							}
							if(!hasData){
								for(var iii:String in tableABData)
								{
									if(iii!=tableBindex)
									{
										tableABData[iii].splice(ta,1)
									}
								}
								ta--;
							}
							
							
							
						}
					}else{
						for(var taa:int=0;taa<tableAlen;taa++)
						{
							var dataA:*=tableA.Data[taa][tableAkey]
							for(var tbb:int=0;tbb<tableBlen;tbb++)
							{
								var dataB:*=tableB.Data[tbb][tableBkey]
								if(dataA==dataB)
								{
									tableABData[tableAindex].push(tableA.Data[taa]);
									tableABData[tableBindex].push(tableB.Data[tbb]);
									//break;
								}
							}
						}										
					}
					hasPushedDataIn=true;
				}
				for(var tt:int=0;tt<tables.length;tt++)
				{
					var tabb:*=tables[tt];
					tmpDB[tabb].Data=tableABData[tt];
				}
				
				rs=processUnionSearch(tableDatas);
											
			}else{
				var table:KTable=db.tables[tables[0]];
				if(table==null){throw new Error("table not exist")}			
				 rs=new KRecordSet()
				 //rs.addHeader(tab.Header)
				 var ndg:*=processSingleSearch(table,"SELECT",conds)
				 rs.addGrid(ndg)
				 //rs.createFromTable(tab);
				 //rs.processData("SELECT",conds);
			}
					
			
			COMMAS.lastIndex=0;
			for(var s:int=0;s<sortCondsLen;s++)
			{
				var sortout:*=COMMAS.exec(sortCondStr);
				rs.sortData(sortout.parameter,sortType);				
			}			
			rs.initMemoCache();
			return rs;
		}
		private static function doUpdate(db:KDataBase,query:String,dataHolder:*=null):int
		{
			UPDATE.lastIndex=0;
			var phy:*=UPDATE.exec(query);
			var newValueStr:String=phy.newvalues;
			var tableStr:String=phy.table;
			var condStr:String=phy.condtion
			var sortCondStr:String=phy.sortCondtion
			var sortTypeStr:String=phy.sortType
			
			var newValues:Array=[]
			var newValuesLen:int=newValueStr.match(COMMAS).length;
			COMMAVALUES.lastIndex=0;
			for(var c:int=0;c<newValuesLen;c++)
			{
				BRACE.lastIndex=0;	
				BRACKET.lastIndex=0;			
				var newValuesOut:*=COMMAVALUES.exec(newValueStr);
				var base:*=null;
				if(BRACE.test(newValuesOut.value)){
					BRACE.lastIndex=0;									
					newValuesOut.value=dataHolder[BRACE.exec(newValuesOut.value).parameter]
				}else if(BRACKET.test(newValuesOut.value)){
					BRACKET.lastIndex=0;
					newValuesOut.value=BRACKET.exec(newValuesOut.value).parameter
					CALCULATION.lastIndex=0;
					if(CALCULATION.test(newValuesOut.value)){
						CALCULATION.lastIndex=0;
						var calcOut:*=CALCULATION.exec(newValuesOut.value)
						base=[calcOut.parameterA,calcOut.operation,calcOut.parameterB]
					}else{
						newValuesOut.value="["+newValuesOut.value+"]";
					}
				}
				
				newValues.push([newValuesOut.parameter,newValuesOut.operation,newValuesOut.value,base]);				
			}
			
			/*var tables:Array=[]
			var tablesLen=tableStr.match(COMMAS).length;
			COMMAS.lastIndex=0;
			for(var t=0;t<tablesLen;t++)
			{
				var tabout=COMMAS.exec(tableStr);
				tables.push(tabout.parameter);				
			}*/
			
			var conds:Array=[]
			var condsLen:int=condStr.match(ANDS).length;
			////trace(condStr.match(ANDS))
			ANDS.lastIndex=0;
			for(var i:int=0;i<condsLen;i++)
			{				
				var out:*=ANDS.exec(condStr);
				conds.push([out.parameter,out.operation,out.value])
			}
			var table:KTable=db.tables[tableStr];
			if(table==null){throw new Error("table not exist")}			
			return processSingleSearch(table,"UPDATE",conds,newValues)
		}
		private static function doDelete(db:KDataBase,query:String):int
		{
			DELETE.lastIndex=0;
			var phy:*=DELETE.exec(query);
			var tableStr:String=phy.table;
			var condStr:String=phy.condtion
			
			var conds:Array=[]
			var condsLen:int=condStr.match(ANDS).length;
			ANDS.lastIndex=0;
			for(var i:int=0;i<condsLen;i++)
			{				
				var out:*=ANDS.exec(condStr);
				conds.push([out.parameter,out.operation,out.value])
			}
			var table:KTable=db.tables[tableStr];
			if(table==null){throw new Error("table not exist")}			
			return processSingleSearch(table,"DELETE",conds)
			
		}
		private static function doInsert(db:KDataBase,query:String,data:*):int
		{
			INSERT.lastIndex=0
			var phy:*=INSERT.exec(query);
			var tableStr:String=phy.table;
			
			var table:KTable=db.tables[tableStr];
			if(table==null){throw new Error("table not exist")}
			table.addRow(data);
			return 1;
		}
		private static function phyCondition(condtions:Array,conStr:String):void
		{
			var ncond:Array=KOperator.ParseOp(conStr);
			if(ncond==null)throw new Error("invalid condition");
			condtions.push(ncond);
		}
		
		private static function processUnionSearch(tables:Array):KRecordSet
		{
			var rs:KRecordSet=new KRecordSet();
			for each(var dg:KDataGrid in tables)
			{
				rs.addGrid(dg);
			}	
			return rs;		
		}
		
		
		private static function processSingleSearch(dg:KDataGrid,process:String,condtions:Array,newvalues:Array=null):*
		{			
			dg.fixMapKey(condtions);
			dg.fixMapKey(newvalues);	
			var selected:Array=[];
			//var tempData:Array=[];		
			var i:int=0;
			var accord:Boolean=true;
			var cond:*;
			var effectRow:int=0;
			
			//tempData=this.Data.slice();
			if(condtions.length==0 || dg.Data.length==0)
			{
				selected=dg.Data;
			}else{
				while(i<dg.Data.length)
				{
					var cData:*=dg.Data[i]
					accord=condtions.length==0;
					for each(cond in condtions)
					{					
						if(!KOperator.Op(cData[cond[0]],cond[1],cond[2]))
						{
							accord=false;
							break;
						}else{
							accord=true;
						}												
					}
					if(accord){					
						switch(process)
						{
							case "SELECT":
								selected.push(dg.Data[i]);
								i++;
								break;
							case "UPDATE":
								for each(var nv:* in newvalues){
									
									var type:int=KDataGridColumn(dg.Header.Columns[nv[0]]).dataType;
									var trueType:*=0;
									if(type==KDataFormat.TYPE_INT || type==KDataFormat.TYPE_UINT || type==KDataFormat.TYPE_NUMBER )
									{trueType=1}
									else if(type==KDataFormat.TYPE_STRING)
									{trueType=2};
									var value:*
									if(nv[3]!=null)
									{
										var baseMaps:*=[nv[3]]
										dg.fixMapKey(baseMaps);
										var baseMap:*=baseMaps[0]
										value=KOperator.Calc(cData[baseMap[0]],baseMap[1],baseMap[2]);
									}else{
										value=nv[2]
									}
									if(trueType==1){cData[nv[0]]=Number(value)}
										else if(trueType==2){cData[nv[0]]=String(value)}
										else{cData[nv[0]]=value}
								};
								effectRow++;
								i++;
								break;
							case "DELETE":
								dg.Data.splice(i,1)
								effectRow++;
								break;					
						}				
					}else{
						i++;
					}
				}
			}
			if(process=="SELECT"){
				var rdg:KDataGrid=new KDataGrid(dg.Header,selected)
			return rdg;}
			return effectRow;
		}		
		
		
		
	}
}