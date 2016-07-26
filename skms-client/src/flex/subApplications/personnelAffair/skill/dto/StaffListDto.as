package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 社員リストDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class StaffListDto
	{
		/**
		 * 社員リストです。
		 */
		private var _staffList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 * 
		 * @param DBからの取得結果
		 */
		public function StaffListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:SkillStaffDto in object){
				tmpArray.push(tmp);
			} 
			_staffList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * 社員リスト取得処理
		 * 
		 * @return 社員リスト
		 */
		public function get StaffList():ArrayCollection
		{
			return _staffList;
		}
	}
}