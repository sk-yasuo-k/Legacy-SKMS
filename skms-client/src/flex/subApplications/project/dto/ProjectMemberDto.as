package subApplications.project.dto
{
	import enum.ProjectPositionId;

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectMemberDto")]
	public class ProjectMemberDto
	{
		public function ProjectMemberDto()
		{
		}
		/**
		 * プロジェクトIDです.
		 */
		public var projectId:int;

		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * 社員名です.
		 */
		public var staffName:String;

		/**
		 * 姓です.
		 */
		public var lastName:String;

		/**
		 * 名です.
		 */
		public var firstName:String;

		/**
		 * 姓(かな)です.
		 */
		public var lastNameKana:String;

		/**
		 * 名(かな)です.
		 */
		public var firstNameKana:String;

		/**
		 * プロジェクト役職IDです.
		 */
		public var projectPositionId:int;

		/**
		 * プロジェクト役職種別略称です.
		 */
		public var projectPositionAlias:String;

		/**
		 * プロジェクト役職種別名称です.
		 */
		public var projectPositionName:String;

		/**
		 * 開始予定日です.
		 */
		public var planedStartDate:Date;

		/**
		 * 完了予定日です.
		 */
		public var planedFinishDate:Date;

		/**
		 * 開始実績日です.
		 */
		public var actualStartDate:Date;

		/**
		 * 完了実績日です.
		 */
		public var actualFinishDate:Date;

		/**
		 * 登録バージョンです.
		 */
		public var registrationVer:int;


		/**
		 * 削除フラグです.
		 */
		public var isDelete:Boolean = false;


		/**
		 * プロジェクトメンバを作成する.
		 *
		 * @param members   プロジェクトメンバリスト.
		 * @param positions 役職リスト.
		 * @param staffs    プロジェクトスタッフリスト.
		 * @return プロジェクトメンバリスト.
		 */
		 public static function createMembers(members:ArrayCollection, positions:ArrayCollection, staffs:ArrayCollection):ArrayCollection
		 {
			var dst:ArrayCollection = new ArrayCollection();

			// 役職リストから役職IDを取得・設定する.
			if (members && positions) {
				for (var i:int = 0; i < members.length; i++) {
					var member:ProjectMemberDto = ObjectUtil.copy(members.getItemAt(i)) as ProjectMemberDto;
					for (var k:int = 0; k < positions.length; k++) {
						if (ObjectUtil.compare(member.projectPositionAlias, positions.getItemAt(k).label) == 0) {
							member.projectPositionId = positions.getItemAt(k).data;
							break;
						}
					}
					dst.addItem(member);
				}
			}

			// プロジェクメンバから外されたスタッフを取得・設定する.
			if (staffs) {
				for (var j:int = 0; j < staffs.length; j++) {
					var staff:ProjectMemberDto = ObjectUtil.copy(staffs.getItemAt(j)) as ProjectMemberDto;
					if (staff.projectId > 0) {
						staff.isDelete = true;
						dst.addItem(staff);
					}
				}
			}
			return dst;
		}

		/**
		 * プロジェクトメンバの一致確認.
		 *
		 * @return true/false 一致/不一致.
		 */
		public static function compare(comp1:ProjectMemberDto, comp2:Object):Boolean
		{
			if (!comp1 || !comp2)	return false;
			if (!comp2.hasOwnProperty("staffId"))	return false;
			if (ObjectUtil.compare(comp1.staffId, comp2.staffId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * プロジェクト状況登録権限.
		 *
		 * @return 権限.
		 */
		public function isAuthorisationProjectSituationEntry():Boolean
		{
// 2012.02.20 kawaguchi 状況報告は全員に許可
//			if (this.projectPositionId == ProjectPositionId.PM
//				|| this.projectPositionId == ProjectPositionId.PL) {
//				return true;
//			}
//			return false;
			return true;
		}

	}
}