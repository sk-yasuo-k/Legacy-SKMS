package subApplications.project.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectDto")]
	public class ProjectDto
	{
		public function ProjectDto()
		{
		}
		/**
		 * プロジェクトIDです.
		 */
		public var projectId:int;

		/**
		 * プロジェクトコードです.
		 */
		public var projectCode:String;

		/**
		 * プロジェクト名です.
		 */
		public var projectName:String;

		/**
		 * 顧客IDです.
		 */
		public var customerId:Object;

		/**
		 * 顧客区分です.
		 */
		public var customerType:String;

		/**
		 * 顧客番号です.
		 */
		public var customerNo:String;

		/**
		 * 顧客名称です.
		 */
		public var customerName:String;

		/**
		 * 顧客略称です.
		 */
		public var customerAlias:String;

		/**
		 * 客先注文番号です.
		 */
		public var orderNo:String;

		/**
		 * 客先注文名称です.
		 */
		public var orderName:String;

		/**
		 * プロジェクトメンバー情報です.
		 */
		public var projectMembers:ArrayCollection;

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
		 * 備考です.
		 */
		public var note:String;

		/**
		 * PMです.
		 */
		public var projectManager:ProjectMemberDto;

		/**
		 * プロジェクト請求リストです。
		 */
		public var projectBills:ArrayCollection;

		/**
		 * プロジェクト請求リストです。
		 */
		public var projectSituations:ArrayCollection;

		//追加 @auther maruta
		/**
		 * 報告日です。
		 */
		public var reportingDate:Date;
		
		  
		/**
		 * プロジェクトの一致確認.
		 *
		 * @return true/false 一致/不一致.
		 */
		public static function compare(comp1:ProjectDto, comp2:ProjectDto):Boolean
		{
			if (ObjectUtil.compare(comp1.projectId, comp2.projectId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * プロジェクトの完了確認.
		 *
		 * @return true/false 完了/未完了.
		 */
		public function comlete():Boolean
		{
			if ((this.planedStartDate && this.planedFinishDate) &&
				(this.actualStartDate && this.actualFinishDate) ){
					return true;
			}
			return false;
		}

		/**
		 * プロジェクトのコピー.
		 *
		 * @return プロジェクト.
		 */
		public static function copy(project:ProjectDto):ProjectDto
		{
			var dst:ProjectDto = ObjectUtil.copy(project) as ProjectDto;
			dst.projectId   = -99;										// プロジェクトID初期化.
			dst.projectCode = project.projectCode.substring(0, 5 + 1);	// 受注連番を除いてコピー.
			dst.planedStartDate  = null;								// 予定日初期化.
			dst.planedFinishDate = null;
			dst.actualStartDate  = null;								// 実績日初期化.
			dst.actualFinishDate = null;
			if (dst.projectMembers) {
				for (var i:int = 0; i < dst.projectMembers.length; i++) {
					dst.projectMembers.getItemAt(i).projectId   = -99;
					dst.projectMembers.getItemAt(i).planedStartDate  = null;
					dst.projectMembers.getItemAt(i).planedFinishDate = null;
					dst.projectMembers.getItemAt(i).actualStartDate  = null;
					dst.projectMembers.getItemAt(i).actualFinishDate = null;
				}
			}

			// 請求書はコピーしない.
			dst.projectBills = new ArrayCollection();

			return dst;
		}

	}
}