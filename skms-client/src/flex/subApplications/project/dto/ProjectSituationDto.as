package subApplications.project.dto
{
	import mx.utils.ObjectUtil;

	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectSituationDto")]
	public class ProjectSituationDto
	{
		public function ProjectSituationDto()
		{
		}
		/**
		 * プロジェクトIDです.
		 */
		public var projectId:int;

		/**
		 * プロジェクト状況連番です.
		 */
		public var situationNo:int;

		/**
		 * プロジェクト状況です.
		 */
		public var situation:String;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです。
		 */
		public var registrantId:int;

		/**
		 * 登録バージョンです.
		 */
		public var registrationVer:int;

		/**
		 * 登録者名です.
		 */
		public var registrationName:String;


		public function entry(project:ProjectDto):ProjectSituationDto
		{
			var dst:ProjectSituationDto = ObjectUtil.copy(this) as ProjectSituationDto;
			dst.projectId = project.projectId;
			return dst;
		}
	}
}