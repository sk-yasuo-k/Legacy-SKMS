package subApplications.personnelAffair.dto
{
	import mx.collections.ArrayCollection;
	import subApplications.personnelAffair.dto.MStaffDto;	

	/**
	 * 社員名リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MStaffSelectDto
	{	
		/**
		 * リスト
		 */
		private var _mStaffSelect:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MStaffSelectDto(object:Object)
		{	
			var tmpArray:Array = new Array();
			for each(var tmp:MStaffDto in object)
			{
				tmpArray.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			_mStaffSelect = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */
		public function get MStaffSelect():ArrayCollection
		{	
			// リストを取得元に返す	
			return _mStaffSelect;
		}		
	}	
}
