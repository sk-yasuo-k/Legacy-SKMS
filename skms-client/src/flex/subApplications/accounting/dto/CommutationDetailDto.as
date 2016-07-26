package subApplications.accounting.dto
{
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	[Bindable]
	[RemoteClass(alias="services.accounting.entity.CommutationDetail")]
	
	public class CommutationDetailDto
	{
		public function CommutationDetailDto()
		{
		}
		
		/** 社員ID */
		public var staffId:int;

		/** 通勤費月コード */
		public var commutationMonthCode:String;

		/** 通勤費詳細連番 */
		public var detailNo:int;

		 /** 通勤開始日 */
		public var commutationStartDate:Date;
		
		/** 通勤費項目リスト */
		public var commutationItems:ArrayCollection;
		
	}
	
}
