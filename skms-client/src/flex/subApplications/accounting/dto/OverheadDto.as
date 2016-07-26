package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.OverheadDto")]
	public class OverheadDto
	{
		public function OverheadDto()
		{
			;
		}

		/**
		 * 諸経費申請IDです.
		 */
		public var overheadId:int;

		/**
		 * プロジェクトIDです.
		 */
		public var projectId:int;

		/**
		 * プロジェクト名です.
		 */
		public var projectName:String;

		/**
		 * プロジェクトコードです.
		 */
		public var projectCode:String;

		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * 社員名です.
		 */
		public var staffName:String;

		/**
		 * 諸経費申請状態IDです.
		 */
		public var overheadStatusId:int;

		/**
		 * 諸経費申請状態名です.
		 */
		public var overheadStatusName:String;

		/**
		 * 諸経費申請履歴情報です.
		 */
		public var overheadHistorys:ArrayCollection;

		/**
		 * 諸経費申請実行可否リストです.
		 */
		public var overheadNextActions:ArrayCollection;

		/**
		 * 諸経費明細情報です.
		 */
		public var overheadDetails:ArrayCollection;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int;

		/**
		 * 登録バージョンです.
		 */
		public var registrationVer:int;


		/**
		 * 登録用データの作成.
		 */
		public static function create(overhead:OverheadDto, project:Object):OverheadDto
		{
			var dst:OverheadDto = new OverheadDto();
			if (overhead) {
				dst.overheadId = overhead.overheadId;
				dst.staffId    = overhead.staffId;
				dst.registrationVer = overhead.registrationVer;
			}
			dst.projectId  = project.projectId;
			dst.overheadDetails = new ArrayCollection();
			return dst;
		}

		/**
		 * データ比較.
		 */
		public static function compare(comp1:Object, comp2:Object):Boolean
		{
			if (ObjectUtil.compare(comp1.overheadId, comp2.overheadId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 複製用データの作成.
		 */
		 public static function copy(overhead:OverheadDto):OverheadDto
		 {
		 	var dst:OverheadDto = new OverheadDto();
			dst.overheadDetails = new ArrayCollection();
			for each (var detail:OverheadDetailDto in overhead.overheadDetails)
			{
				var cnv:OverheadDetailDto = OverheadDetailDto.copy(detail);
				dst.overheadDetails.addItem(cnv);
			}
			dst.projectId		= overhead.projectId;
			dst.projectCode		= overhead.projectCode;
			dst.projectName		= overhead.projectName;
		 	return dst;
		 }
	}
}