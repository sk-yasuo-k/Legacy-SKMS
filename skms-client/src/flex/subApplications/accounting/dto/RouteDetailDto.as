package subApplications.accounting.dto
{
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	import subApplications.accounting.web.custom.AccountingDataGrid;

	[Bindable]
	[RemoteClass(alias="services.accounting.dto.RouteDetailDto")]
	public class RouteDetailDto
	{
		public function RouteDetailDto()
		{
		}

		/** 経路ID */
		public var routeId:Number;

		/** 経路名 */
		public var routeSeq:int;

		/** 経路情報 */
		public var routeDto:RouteDto;

		/** 目的地 */
		public var destination:String;

		/** 交通機関 */
		public var facilityName:String;

		/** 出発地 */
		public var departure:String;

		/** 到着地 */
		public var arrival:String;

		/** 経由 */
		public var via:String;

		/** 往復フラグ */
		//public var roundTrip:String;
		public var roundTrip:Boolean;

		/** 片道金額 */
		public var oneWayExpense:String;

		/** 金額 */
		public var expense:String;

		/** 備考 */
		public var note:String;

		/** 登録日時 */
		public var registrationTime:Date;

		/** 登録者ID */
		public var registrantId:int;

		/** 表示順 */
		public var sortOrder:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/** 削除フラグ */
		public var isDelete:Boolean = false;


//		/**
//		 * 経路詳細作成.
//		 */
//		public static function createRoute(trans:TransportationDetailDto):RouteDetailDto
//		{
//			var dst:RouteDetailDto = new RouteDetailDto();
//			dst.destination		  = trans.destination;
//			dst.facilityName	  = trans.facilityName;
//			dst.departure		  = trans.departure;
//			dst.arrival			  = trans.arrival;
//			dst.via				  = trans.via;
//			dst.roundTrip		  = trans.roundTrip;
//			dst.expense			  = trans.expense;
//			// 備考は交通費明細に関する事項のため引き継がない.
//			//dst.note			  = this.note;
//			return dst;
//		}

//		/**
//		 * 経路詳細情報をコピーする.
//		 * ※経路詳細Drag&Dropで使用.
//		 */
//		public function copy():RouteDetailDto
//		{
//			var dst:RouteDetailDto = new RouteDetailDto();
//			dst.destination  = this.destination;
//			dst.facilityName = this.facilityName;
//			dst.departure    = this.departure;
//			dst.arrival      = this.arrival;
//			dst.via          = this.via;
//			dst.roundTrip    = this.roundTrip;
//			dst.expense      = this.expense;
//			dst.note         = this.note;
//			return dst;
//		 }

		/**
		 * 登録時の入力値チェック.
		 */
		public function checkEntry():Boolean {
			// 入力値チェック
			if (chkEntry_isValue())		return true;

			// 登録済みチェック.
			isDelete = false;
			if (this.routeDto) {
				isDelete = true;
				return true;
			}

			// 入力値なし.
			return false;
		}

		/**
		 * 登録時の入力値チェック.
		 */
		private function chkEntry_isValue():Boolean {
			// 入力値チェック.
			if (isValueString(this.destination))		return true;
			if (isValueString(this.facilityName))		return true;
			if (isValueString(this.departure))			return true;
			if (isValueString(this.via))				return true;
			if (isValueString(this.arrival))			return true;
			//if (this.roundTripDisp != null)			return true;
			if (isValueString(this.oneWayExpense))		return true;
			if (isValueString(this.note))				return true;

			// 入力値なし.
			return false;
		}

		/**
		 * 入力有無のチェック.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			if (!(StringUtil.trim(value).length > 0))	return false;
			return true;
		}

		/**
		 * 削除設定.
		 */
		 public function setDelete():void {
		 	this.isDelete = true;
		 }

		/**
		 * 登録用データ変換.
		 */
		public function convertEntry():void
		{
			// 交通機関 未設定は "" のため null に設定する.
			if (!isValueString(this.facilityName)) {
				this.facilityName = null;
			}
// 2009.06.26 delete 編集するときに 数値しか扱えないようにしたため変換の必要なし.
//			// 数値 \x,xxx を xxxx に変換する.
//			if (this.expense) {
//				var cnvExpense:String = AccountingDataGrid.expenseSymbolOff(this.expense);
//				this.expense = cnvExpense;
//			}
		}

		/**
		 * 詳細経路の一致確認.
		 *
		 * @param true/false 一致/不一致.
		 */
		public static function compare(comp1:RouteDetailDto, comp2:RouteDetailDto):Boolean
		{
			if (!comp1 || !comp2)	return false;
			if (ObjectUtil.compare(comp1.routeId,  comp2.routeId ) == 0 &&
				ObjectUtil.compare(comp1.routeSeq, comp2.routeSeq) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 経路詳細作成.
		 *
		 * @param trans 詳細経路.
		 */
		public static function newRouteDetail(routeId:Number, trans:TransportationDetailDto = null):RouteDetailDto
		{
			var dst:RouteDetailDto = new RouteDetailDto();
			dst.routeId = routeId;
			if (trans) {
				dst.destination	 = trans.destination;
				dst.facilityName = trans.facilityName;
				dst.departure	 = trans.departure;
				dst.arrival		 = trans.arrival;
				dst.via			 = trans.via;
				dst.roundTrip	 = trans.roundTrip;
				dst.oneWayExpense= trans.oneWayExpense;
				dst.expense		 = trans.expense;
				dst.note		 = trans.note;
			}
			return dst;
		}

		/**
		 * 経路詳細情報をコピーする.
		 * ※経路詳細Drag&Dropで使用.
		 */
		public function copy(routeId:Number = -1):RouteDetailDto
		{
			if (routeId < 0)	routeId = this.routeId;
			var dst:RouteDetailDto = RouteDetailDto.newRouteDetail(routeId);
			dst.destination  = this.destination;
			dst.facilityName = this.facilityName;
			dst.departure    = this.departure;
			dst.arrival      = this.arrival;
			dst.via          = this.via;
			dst.roundTrip    = this.roundTrip;
			dst.oneWayExpense= this.oneWayExpense;
			dst.expense      = this.expense;
			dst.note         = this.note;
			return dst;
		 }

	}
}