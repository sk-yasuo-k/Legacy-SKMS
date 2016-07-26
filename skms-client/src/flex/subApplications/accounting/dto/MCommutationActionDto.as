package subApplications.accounting.dto
{
	[Bindable]
	[RemoteClass(alias="services.accounting.entity.MCommutationAction")]
	
	public class MCommutationActionDto
	{
		/**
		 * 通勤費手続き動作種別IDです.
		 */
		public var commutationActionId:int;
	
		/**
		 * 通勤費手続き動作種別名です.
		 */
		public var commutationActionName:String;

	}
}