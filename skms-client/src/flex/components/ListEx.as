package components
{
	/**
	 * データフィールドのデータにて選択状態にする拡張List
	 * */
	import mx.collections.ArrayCollection;
	import mx.controls.List;

	public class ListEx extends List
	{
		private var _dataField:String;
		
		public function ListEx()
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
		public function set selectedDataArray(valueArray:Array):void
	    {
	    	if ((_dataField == "") || (_dataField == null ))
	    	{
	    		return;
	    	}
	    	var selectedArray:Array = new Array();
	    	for each( var value:String in valueArray)
	    	{
				var listArray:ArrayCollection = this.dataProvider as ArrayCollection;				
				for (var i:int=0 ; i<listArray.length ; ++i)
				{
					if(listArray[i][_dataField] == value){
						selectedArray.push(i);						
					}
				}
	    	}
	    	this.selectedIndices = selectedArray;
			return;

	    }
	
	}
}