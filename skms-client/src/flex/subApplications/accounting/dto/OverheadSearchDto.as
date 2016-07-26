package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.OverheadSearchDto")]
	public class OverheadSearchDto
	{
		public function OverheadSearchDto()
		{
			;
		}

		/**
		 * プロジェクトリストです.
		 */
		public var projectList:ArrayCollection;

		/**
		 * 所属プロジェクトの部下検索フラグです.
		 */
		public var subordinateOnly:Boolean = false;

		/**
		 * 申請状態リストです.
		 */
		public var statusList:ArrayCollection;
	}
}