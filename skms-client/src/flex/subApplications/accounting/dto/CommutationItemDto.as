package subApplications.accounting.dto
{
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.accounting.entity.CommutationItem")]
	
	
	public class CommutationItemDto
	{
		public function CommutationItemDto()
		{
		}

		/** 社員ID */
		public var staffId:int;

		/** 通勤費月コード */
		public var commutationMonthCode:String;

		/** 通勤費詳細連番 */
		public var detailNo:int;

		/** 通勤費項目連番 */
		public var itemNo:int;
		
		/** 目的地 */
		public var destination:String;

		/** 交通機関 */
		public var facilityName:String;

		/** 交通機関(会社名) */
		public var facilityCmpName:String;

		/** 出発地 */
		public var departure:String;

		/** 到着地 */
		public var arrival:String;

		/** 経由 */
		public var via:String;

		/** 金額 */
		public var expense:String;

		/**
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			if (!(StringUtil.trim(value).length > 0))	return false;
			return true;
		}
		
		/**
		 * 登録時の入力値チェック.
		 */
		public function checkEntry():Boolean
		{
		 	if (this.destination    && StringUtil.trim(this.destination).length > 0)	return true;
		 	if (this.facilityName && StringUtil.trim(this.facilityName).length > 0)	return true;
		 	if (this.facilityCmpName && StringUtil.trim(this.facilityCmpName).length > 0)	return true;
		 	if (this.departure && StringUtil.trim(this.departure).length > 0)	return true;
		 	if (this.arrival && StringUtil.trim(this.arrival).length > 0)	return true;
		 	if (this.via && StringUtil.trim(this.via).length > 0)	return true;
		 	if (this.expense && StringUtil.trim(this.expense).length > 0)	return true;
		 	return false;
		}

		/**
		  * 登録するデータの作成.
		  *
		  * @return 登録データリスト.
		  */
		public static function entry(list:ArrayCollection):ArrayCollection
		{
			var entrylist:ArrayCollection = new ArrayCollection();
		 	if (!list) return entrylist;
		 	for (var index:int = 0; index < list.length; index++) {
		 		var ci:CommutationItemDto = list.getItemAt(index) as CommutationItemDto;
		 		// 入力値があるとき 登録する.
		 		if (ci.checkEntry()) {
		 			entrylist.addItem(ci);
		 		}
		 	}
		 	return entrylist;
		}

		/**
		 * 申請時の入力値チェック.
		 */
		public function checkApply():Boolean
		{
			var isApply:Boolean = true;
			if (!checkApply_destination()) isApply = false;
			if (!checkApply_facilityName()) isApply = false;
			if (!checkApply_facilityCmpName()) isApply = false;
			if (!checkApply_departure()) isApply = false;
			if (!checkApply_arrival()) isApply = false;
			if (!checkApply_via()) isApply = false;
			if (!checkApply_expense()) isApply = false;
		 	return isApply;
		}

		/**
		 * 通勤先の申請入力値チェック.
		 */
		public function checkApply_destination():Boolean
		{
			if (isValueString(this.destination)) return true;
			return false;
		}

		/**
		 * 交通機関の申請入力値チェック.
		 */
		public function checkApply_facilityName():Boolean
		{
			if (isValueString(this.facilityName)) return true;
			return false;
		}

		/**
		 * 交通機関(会社名)の申請入力値チェック.
		 */
		public function checkApply_facilityCmpName():Boolean
		{
//			if (isValueString(this.facilityCmpName)) return true;
//			return false;
			return true;
		}
		
		/**
		 * 出発地の申請入力値チェック.
		 */
		public function checkApply_departure():Boolean
		{
			if (isValueString(this.departure))	return true;
			return false;
		}

		/**
		 * 到着地の申請入力値チェック.
		 */
		public function checkApply_arrival():Boolean
		{
			if (isValueString(this.arrival)) return true;
			return false;
		}
		
		/**
		 * 経由の申請入力値チェック.
		 */
		public function checkApply_via():Boolean
		{
			// 入力必須でない.
			return true;
		}

		/**
		 * 金額の申請入力チェック.
		 */
		public function checkApply_expense():Boolean
		{
			if (isValueString(this.expense)) {
				if (parseInt(this.expense) < 0) {
//				if (ObjectUtil.compare(StringUtil.trim(this.expense), "0") == 0) {
					return false;
				}
				return true;
			}
			return false;
		}
		
	}
}