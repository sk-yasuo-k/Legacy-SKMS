package subApplications.generalAffair.dto
{
	import dto.StaffDto;

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	import subApplications.generalAffair.logic.AccountingLogic;


	public class StaffEntryDto
	{
		public function StaffEntryDto()
		{
			;
		}
		/** 職歴リスト */
		public var StaffDetails:ArrayCollection
		/** 備考 */
		public var note:String;
	}
}