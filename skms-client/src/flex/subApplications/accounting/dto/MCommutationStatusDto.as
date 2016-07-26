package subApplications.accounting.dto
{
	
	[Bindable]
	[RemoteClass(alias="services.accounting.entity.MCommutationStatus")]
	
	public class MCommutationStatusDto
	{
		/**
		 * 通勤費手続き状態種別IDです.
		 */
		public var commutationStatusId:int;
	
		/**
		 * 通勤費手続き状態種別名です.
		 */
		public var commutationStatusName:String;
	
		/**
		 * 通勤費手続き状態表示色です.
		 */
		public var commutationStatusColor:int;

	}
}