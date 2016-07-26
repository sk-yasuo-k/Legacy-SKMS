package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 認定資格手当リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MInformationAllowanceListDto
	{
		private var mInformationAllowanceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MInformationAllowanceListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mInformationAllowanceDto:Object in object)
			{
				array.push(mInformationAllowanceDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mInformationAllowanceList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MInformationAllowanceList():ArrayCollection
		{
			// リストを取得元に返す	
			return mInformationAllowanceList;
		}
	}	
}
