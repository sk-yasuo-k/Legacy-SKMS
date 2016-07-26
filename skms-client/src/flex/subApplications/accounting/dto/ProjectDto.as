package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="services.accounting.dto.ProjectDto")]
	public class ProjectDto
	{
		public function ProjectDto()
		{
		}

		/**
		 * プロジェクトIDです。
		 */
		public var projectId:int;

		/**
		 * プロジェクトコードです。
		 */
		public var projectCode:String;

		/**
		 * プロジェクト名です。
		 */
		public var projectName:String;

		/**
		 * プロジェクト役職IDです。
		 */
		public var projectPositionId:int;

		/**
		 * プロジェクト役職略名です。
		 */
		public var projectPositionAlias:String;

		/**
		 * プロジェクト役職名です。
		 */
		public var projectPositionName:String;
		
		//追加 @auther watanuki
		/**
		 * 開始実績日です.
		 */
		public var actualStartDate:Date;

		/**
		 * 完了実績日です.
		 */
		public var actualFinishDate:Date;
	}
}
