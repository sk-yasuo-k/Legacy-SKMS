package components
{
	/**
	 * データフィールドのデータにて選択状態にする拡張combobox
	 * */
	import mx.controls.ComboBox;
	import mx.collections.ArrayCollection;

	public class ComboBoxEx extends ComboBox
	{
		private var _dataField:String;
		

		public function ComboBoxEx()
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
		 * データフィールド変更
		 * */
	    public function set dataField(value:String):void
	    {
	    	_dataField = value;
	    }


		/**
		 * 初期選択状態作成
		 * */
		public function set selectedData(value:String):void
	    {
	    	if ((_dataField == "") || (_dataField == null ))
	    	{
	    		return;
	    	}

			var ac:ArrayCollection = this.dataProvider as ArrayCollection;
			
			for (var iCnt:int=0 ; iCnt<ac.length ; ++iCnt)
			{
				if(ac[iCnt] != null){
					if(ac[iCnt][_dataField] == value){
						this.selectedIndex = iCnt;
						return;
					}
				}	
			}
	    }
	    
		/**
		 * 選択データ取得
		 * */
		public function get selectedData():String
		{
	    	var ac:ArrayCollection = this.dataProvider as ArrayCollection;
	    	
	    	return ac[this.selectedIndex][_dataField].toString();
		}	    
	}
}
