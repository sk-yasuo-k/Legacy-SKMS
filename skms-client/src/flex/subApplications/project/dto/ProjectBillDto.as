package subApplications.project.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectBillDto")]
	public class ProjectBillDto
	{
		public function ProjectBillDto()
		{
		}
		/**
		 * プロジェクトIDです.
		 */
		public var projectId:int;

		/**
		 * 請求連番です.
		 */
		public var billNo:int;

		/**
		 * 請求日です.
		 */
		public var billDate:Date;

		/**
		 * 振込口座IDです.
		 */
		public var accountId:int;

		 /**
		  * 登録バージョンです.
		  */
		public var registrationVer:int;

		/**
		 * プロジェクト請求項目情報リストです.
		 */
		public var projectBillItems:ArrayCollection;

		/**
		 * プロジェクトその他請求項目情報リストです.
		 */
		public var projectBillOthers:ArrayCollection;


		/** 削除フラグ */
		public var isDelete:Boolean = false;



//		/**
//		 * 請求書情報の新規作成.
//		 */
//		public static function newBillForm(itemnum:int):ProjectBillDto
//		{
//			var dst:ProjectBillDto = new ProjectBillDto();
//			dst.projectBillItems = new ArrayCollection();
//			for (var i:int = 1 ; i < itemnum; i++) {
//				var item:ProjectBillItemDto = new ProjectBillItemDto();
//				item.itemNo = i.toString();
//				dst.projectBillItems.addItem(item);
//			}
//			return dst;
//		}
//
//		/**
//		 * 請求書情報の更新.
//		 */
//		public static function updBillForm(itemnum:int, bill:ProjectBillDto):ProjectBillDto
//		{
//			var dst:ProjectBillDto = ObjectUtil.copy(bill) as ProjectBillDto;
//			if (!dst.projectBillItems)
//				dst.projectBillItems = new ArrayCollection();
//
//			var num:int = dst.projectBillItems.length;
//			for (var i:int = num  ; (i + num) < itemnum; i++) {
//				var item:ProjectBillItemDto = new ProjectBillItemDto();
//				dst.projectBillItems.addItem(item);
//			}
//			return dst;
//		}

		/**
		 * 削除対象に設定.
		 */
		 public function setDelete():void
		 {
		 	this.isDelete = true;
		 }
	}
}