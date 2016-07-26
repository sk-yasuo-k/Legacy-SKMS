package components
{
	import mx.controls.Tree;
	
	import subApplications.personnelAffair.skill.dto.StaffSkillHardDto;

	public class MultiSelectableTree extends Tree
	{
		private var _dataField:String;

		public function MultiSelectableTree()
		{
			super();
			_dataField = "data";
		}

		/**
		 * データフィールド名取得
		 * */
	    public function get dataField():String
	    {
	    	return _dataField;
	    }

	    /**
	    * データフィールド名変更
	    * */
	    public function set dataField(value:String):void
	    {
	    	_dataField = value;
	    }

		/**
		* 初期選択状態作成
		* */
		public function set selectedDataArray(transDtoArray:Array):void
	    {
	    	if ((_dataField == "") || (_dataField == null ))
	    	{
	    		return;
	    	}
	    	var selectedArray:Array = new Array();
	    	for each( var transDto : StaffSkillHardDto in transDtoArray)
	    	{
				var xmlList	: XMLList	= this.dataProvider as XMLList;
				var index	: int		= 0;				
				for each (var xml : XML in xmlList) {
					if (xml.name() != "hard") {
						index++;
						continue;
					}
					if (xml.@id == transDto.hardId) {
						selectedArray.push(index);
						break;						
					}
					index++;
				}
	    	}
	    	this.selectedIndices = selectedArray;
			return;
	    }
	}
}