package subApplications.project.dto
{
	import com.googlecode.kanaxs.Kana;

	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.project.dto.ProjectBillItemDto")]
	public class ProjectBillItemDto
	{
		public function ProjectBillItemDto()
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
		 * 請求項目連番です。
		 */
		public var itemNo:String;

		/**
		 * 注文Noです。
		 */
		public var orderNo:String;

		/**
		 * 件名です。
		 */
		public var title:String;

		/**
		 * 請求額です。
		 */
		public var billAmount:String;


		/** 削除フラグ */
		public var isDelete:Boolean = false;


		/**
		 * 入力データの確認.
		 *
		 * @return 結果.
		 */
		 public function checkEntry():Boolean
		 {
			if (isValueString(this.orderNo))		return true;
			if (isValueString(this.title))			return true;
			if (isValueString(this.billAmount))		return true;
			return false;
		 }

		/**
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean
		{
			if (value == null)							return false;
			var str:String = Kana.toHankakuCase(value);
			if (!(StringUtil.trim(str).length > 0))		return false;
			return true;
		}

		 /**
		  * 登録するデータの作成.
		  *
		  * @return 登録データリスト.
		  */
		 public static function entry(list:ArrayCollection):ArrayCollection
		 {
		 	var entrylist:ArrayCollection = new ArrayCollection();
		 	if (!list)		return entrylist;
		 	for (var index:int = 0; index < list.length; index++) {
		 		var bill:ProjectBillItemDto = list.getItemAt(index) as ProjectBillItemDto;
//		 		// 数値に変換する.
//		 		bill.billAmount = format.format(bill.billAmount);

		 		// 入力値があるとき 登録する.
		 		if (bill.checkEntry()) {
		 			entrylist.addItem(bill);
		 		}
		 		// 入力値がないとき 削除する.
		 		else if (bill.projectId > 0 && !bill.checkEntry()) {
		 			bill.isDelete = true;
		 			entrylist.addItem(bill);
		 		}
		 	}
		 	return entrylist;
		 }

		 /**
		  * 複製するデータの作成.
		  *
		  * @return 複製データリスト.
		  */
		 public static function copy(list:ArrayCollection):ArrayCollection
		 {
		 	var entrylist:ArrayCollection = new ArrayCollection();
		 	if (!list)		return entrylist;
		 	for (var index:int = 0; index < list.length; index++) {
		 		var bill:ProjectBillItemDto = list.getItemAt(index) as ProjectBillItemDto;
//		 		// 数値に変換する.
//		 		bill.billAmount = format.format(bill.billAmount);

		 		// 入力値があるとき 登録する.
		 		if (bill.checkEntry()) {
		 			var newbill:ProjectBillItemDto = new ProjectBillItemDto();
		 			newbill.orderNo    = bill.orderNo;
		 			newbill.title      = bill.title;
		 			newbill.billAmount = bill.billAmount;
		 			entrylist.addItem(newbill);
		 		}
		 	}
		 	return entrylist;
		 }
	}
}