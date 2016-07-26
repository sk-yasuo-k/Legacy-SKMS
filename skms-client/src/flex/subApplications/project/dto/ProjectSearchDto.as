package subApplications.project.dto
{
	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectSearchDto")]
	public class ProjectSearchDto
	{
		public function ProjectSearchDto()
		{
		}

		/**
		 *社員IDです.
		 */
		public var staffId:int;

		/**
		 * プロジェクトIDリストです.
		 */
		public var projectIdItems:Array;

		/**
		 * プロジェクトコードです.
		 */
		public var projectCode:String;

		/**
		 * プロジェクト名です.
		 */
		public var projectName:String;

		/**
		 * プロジェクトマネージャ 社員IDです.
		 */
		public var pmStaffId:int;

		/**
		 * プロジェクトメンバー名です.
		 */
		public var projectMemberName:String;

		/**
		 * 開始実績日 from です.
		 */
		public var actualStartDateFrom:Date;

		/**
		 * 開始実績日 to です.
		 */
		public var actualStartDateTo:Date;

		/**
		 * 開始実績日 未設定です.
		 */
		public var actualStartDateNone:Boolean;

		/**
		 * 終了実績日 from です.
		 */
		public var actualFinishDateFrom:Date;

		/**
		 * 終了実績日 to です.
		 */
		public var actualFinishDateTo:Date;

		/**
		 * 終了実績日 未設定です.
		 */
		public var actualFinishDateNone:Boolean;

	}
}