package dto
{
	import enum.AuthorityId;
	import enum.DepartmentId;
	import enum.ProjectPositionId;
	
	import mx.collections.ArrayCollection;
	
	import subApplications.project.dto.MStaffProjectPositionDto;
	import subApplications.system.dto.StaffSettingDto;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.MStaff")]
	public class StaffDto
	{
		public function StaffDto()
		{
		}

		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * ログイン名です.
		 */
		public var loginName:String;

		/**
		 * メールアドレスです.
		 */
		public var email:String;

		/**
		 * 誕生日です.
		 */
		public var birthday:Date;

		/**
		 * 社員名情報です.
		 */
		public var staffName:StaffNameDto;

		/**
		 * 社員部署情報です.
		 */
		public var staffDepartment:ArrayCollection;

		/**
		 * 社員部署長情報です.
		 */
		public var staffDepartmentHead:ArrayCollection;

		/**
		 * 社員経営役職情報です.
		 */
		public var staffManagerialPosition:ArrayCollection;

		/**
		 * 社員プロジェクト役職情報です.
		 */
		public var staffProjectPosition:ArrayCollection;

		/**
		 * 社員環境設定情報です.
		 */
		public var staffSetting:StaffSettingDto;

		/**
		 * 社員就労状況です.
		 */
		public var currentStaffWorkStatus:Object;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var  registrantId:int;


		/**
		 * 社員プロジェクト役職がPMかどうか確認する.
		 *
		 * @return 確認結果.
		 */
		public function isProjectPositionPM():Boolean
		{
			if (this.staffProjectPosition && this.staffProjectPosition.length > 0) {
				var position:MStaffProjectPositionDto = this.staffProjectPosition.getItemAt(0) as MStaffProjectPositionDto;
				if (position) {
					if (position.projectPositionId == ProjectPositionId.PM) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 社員プロジェクト役職がPLかどうか確認する.
		 *
		 * @return 確認結果.
		 */
		public function isProjectPositionPL():Boolean
		{
			if (this.staffProjectPosition && this.staffProjectPosition.length > 0) {
				var position:MStaffProjectPositionDto = this.staffProjectPosition.getItemAt(0) as MStaffProjectPositionDto;
				if (position) {
					if (position.projectPositionId == ProjectPositionId.PL) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * プロジェクト登録権限有無.
		 *
		 * @return 権限有無.
		 */
		public function isAuthorisationProjectEntry():Boolean
		{
			if (isProjectPositionPM())	return true;
			if (isDepartmentHeadGA())	return true;
			return false;
		}

		/**
		 * プロジェクト状況登録権限有無.
		 *
		 * @return 権限有無.
		 */
		public function isAuthorisationProjectSituationEntry():Boolean
		{
// 2012.02.20 kawaguchi 状況報告は全員に許可
//			if (isProjectPositionPM())	return true;
//			if (isProjectPositionPL())	return true;
//			return false;
			return true;
		}

		/**
		 * 取引先登録権限有無.
		 *
		 * @return 権限有無.
		 */
		public function isAuthorisationCustomerEntry():Boolean
		{
			if (isProjectPositionPM())	return true;
			if (isDepartmentHeadGA())	return true;
			return false;
		}

		/**
		 * 社員が総務部長かどうか確認する.
		 *
		 * @return 確認結果.
		 */
		public function isDepartmentHeadGA():Boolean
		{
			if (this.staffDepartmentHead && this.staffDepartmentHead.length > 0) {
				for each(var department:Object in this.staffDepartmentHead) {
					if (department && department.departmentId) {
						if (department.departmentId == DepartmentId.GENERAL_AFFAIR) {
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * プロフィール更新権限有無.
		 *
		 * @return 権限有無.
		 */
		public function isAuthorisationProfile():Boolean
		{
			if (isStaffManagerialPosition())	return true;
			if (isDepartmentHeadGA())	return true;
			return false;
		}
		
		/**
		 * 社員が役員かどうか確認する.
		 *
		 * @return 確認結果.
		 */		
		public function isStaffManagerialPosition():Boolean
		{
			if (this.staffManagerialPosition && this.staffManagerialPosition.length > 0) {
				return true;
			}
			return false;
		}
		
		/**
		 * 表示項目表示可否.
		 *
		 * @return 権限ID.
		 */
		public function isDisplayItemsShow():int
		{
			if (isStaffManagerialPosition())	return AuthorityId.OFFICERS;
			if (isDepartmentHeadGA())	return AuthorityId.GENERAL_AFFAIRS_MANAGER;
			if (isProjectPositionPM())	return AuthorityId.PM;
			if (isProjectPositionPL())	return AuthorityId.PL;			
			return AuthorityId.STAFF;
		}		
	}
}