package subApplications.accounting.dto
{
	import com.googlecode.kanaxs.Kana;

	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.accounting.dto.TransportationDetailDto")]
	public class TransportationDetailDto
	{
		public function TransportationDetailDto()
		{
		}

//		/** 交通費申請 */
//		public var transportationDto:TransportationDto;

		/** 交通費申請ID */
		public var transportationId:int = -99;

		/** 交通費申請明細連 */
		public var transportationSeq:int;

		/** 交通費発生日 */
		public var transportationDate:Date;

		/** 業務 */
		public var task:String;

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

		/** 領収書No */
		public var receiptNo:String;

		/** 登録日時 */
		public var registrationTime:Date;

		/** 登録者ID */
		public var registrantId:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/** 削除フラグ */
		public var isDelete:Boolean = false;


		/**
		 * 経路詳細コピー.
		 */
		public function copyRouteDetail(route:RouteDetailDto):TransportationDetailDto
		{
			var dst:TransportationDetailDto = new TransportationDetailDto();
			dst.transportationDate = this.transportationDate;
			dst.task               = this.task;
			dst.destination        = route.destination;
			dst.facilityName       = route.facilityName;
			dst.departure          = route.departure;
			dst.arrival            = route.arrival;
			dst.via                = route.via;
			dst.roundTrip          = route.roundTrip;
			dst.oneWayExpense      = route.oneWayExpense;
			dst.expense            = route.expense;
			dst.note               = route.note;
			return dst;
		}

		/**
		 * 交通費明細情報をコピーする.
		 * ※交通費コピーで使用.
		 */
		 public function copyTransportation():TransportationDetailDto
		 {
		 	var dst:TransportationDetailDto = new TransportationDetailDto();
		 	// dst.transportationDate = コピーしない
			dst.task         = this.task;
			dst.destination  = this.destination;
			dst.facilityName = this.facilityName;
			dst.departure    = this.departure;
			dst.arrival      = this.arrival;
			dst.via          = this.via;
			dst.roundTrip    = this.roundTrip;
			dst.oneWayExpense= this.oneWayExpense;
			dst.expense      = this.expense;
			// dst.note         = コピーしない
			return dst;
		 }

		/**
		 * 交通費明細情報をコピーする.
		 * ※交通費明細Drag&Dropで使用.
		 */
		public function copy():TransportationDetailDto
		{
			var dst:TransportationDetailDto = new TransportationDetailDto();
			dst.transportationDate = this.transportationDate;
			dst.task         = this.task;
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

		/**
		 * 交通費明細情報をコピーする.
		 * ※交通費明細コピーで使用.
		 */
		public function copyTransportationDetail(date:Date):TransportationDetailDto
		{
			var dst:TransportationDetailDto = new TransportationDetailDto();
			dst.transportationDate = date;
			dst.task         = this.task;
			dst.destination  = this.destination;
			dst.facilityName = this.facilityName;
			dst.departure    = this.departure;
			dst.arrival      = this.arrival;
			dst.via          = this.via;
			dst.roundTrip    = this.roundTrip;
			dst.oneWayExpense= this.oneWayExpense;
			dst.expense      = this.expense;
			// dst.note         = コピーしない
			return dst;
		 }

		/**
		 * 登録時の入力値チェック.
		 */
		public function checkEntry():Boolean
		{
			// 入力値チェック.
			if (isValueDate(this.transportationDate))	return true;
			if (isValueString(this.task))				return true;
			if (isValueString(this.destination))		return true;
			if (isValueString(this.facilityName))		return true;
			if (isValueString(this.departure))			return true;
			if (isValueString(this.via))				return true;
			if (isValueString(this.arrival))			return true;
			//if (this.roundTripDisp != null)			return true;
			if (isValueString(this.oneWayExpense))		return true;
			if (isValueString(this.receiptNo))			return true;
			if (isValueString(this.note))				return true;

			// 登録済みチェック.
			isDelete = false;
			if (this.transportationId > 0) {
				isDelete = true;
				return true;
			}

			// 入力値なし.
			return false;
		}

		/**
		 * 一括入力値チェック.
		 */
		public function checkEntryBatch():Boolean
		{
			// 入力値チェック
			if (!isValueString(this.task))				return false;
			if (!isValueString(this.destination))		return false;
			if (!isValueString(this.facilityName))		return false;
			if (!isValueString(this.departure))			return false;
			//if (i!sValueString(this.via))				return false;
			if (!isValueString(this.arrival))			return false;
			//if (this.roundTripDisp != null)			return false;
			if (!isValueString(this.oneWayExpense))		return false;

			// 入力OK
			return true;
		}


		/**
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			var str:String = Kana.toHankakuCase(value);
			if (!(StringUtil.trim(str).length > 0))		return false;
			return true;
		}
		/**
		 * Date データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueDate(value:Date):Boolean {
			if (value == null)							return false;
			return true;
		}

		/**
		 * 申請時の入力値チェック.
		 */
		public function checkApply():Boolean
		{
			var isApply:Boolean = true;
			// 交通費発生日
			if (!checkApply_transDate()) {
				isApply = false;
			}
			// 業務
			if (!checkApply_task()) {
				isApply = false;
			}
			// 目的地
			if (!checkApply_destination()) {
				isApply = false;
			}
			// 交通機関
			if (!checkApply_facilityName()) {
				isApply = false;
			}
			// 発
			if (!checkApply_departure()) {
				isApply = false;
			}
			// 経由
			if (!checkApply_via()) {
				isApply = false;
			}
			// 着
			if (!checkApply_arrival()) {
				isApply = false;
			}
			//// 往復
			//if (!checkApply_roundTrip()) {
			//	isApply = false;
			//}
			// 金額.
			//if (!checkApply_expense()) {
			//	isApply = false;
			//}
			// 片道金額.
			if (!checkApply_oneWayExpense()) {
				isApply = false;
			}
			// 領収No.
			if (!checkApply_receiptNo()) {
				isApply = false;
			}
			// 備考
			if (!checkApply_note()) {
				isApply = false;
			}
			return isApply;
		}

		/**
		 * 交通費発生日の申請入力値チェック.
		 */
		public function checkApply_transDate():Boolean
		{
			if (isValueDate(this.transportationDate))	return true;
			return false;
		}

		/**
		 * 業務の申請入力値チェック.
		 */
		public function checkApply_task():Boolean
		{
			if (isValueString(this.task))	return true;
			return false;
		}

		/**
		 * 目的地の申請入力値チェック.
		 */
		public function checkApply_facilityName():Boolean
		{
			if (isValueString(this.facilityName))	return true;
			return false;
		}

		/**
		 * 交通機関の申請入力値チェック.
		 */
		public function checkApply_destination():Boolean
		{
			if (isValueString(this.destination))	return true;
			return false;
		}

		/**
		 * 発の申請入力値チェック.
		 */
		public function checkApply_departure():Boolean
		{
			if (isValueString(this.departure))	return true;
			return false;
		}

		/**
		 * 着の申請入力値チェック.
		 */
		public function checkApply_arrival():Boolean
		{
			if (isValueString(this.arrival))	return true;
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

		///**
		// * 往復の申請入力値チェック.
		// */
		//public function checkApply_roundTrip():Boolean
		//{
		//	if (isValueString(this.roundTrip))	return true;
		//	return false;
		//}
		//
		///**
		// * 金額の申請入力値チェック.
		// */
		//public function checkApply_expense():Boolean
		//{
		//	if (isValueString(this.expense)) {
		//		if (ObjectUtil.compare(StringUtil.trim(this.expense), "0") == 0) {
		//			return false;
		//		}
		//		return true;
		//	}
		//	return false;
		//}
		/**
		 * 片道金額の申請入力チェック.
		 */
		public function checkApply_oneWayExpense():Boolean
		{
			if (isValueString(this.oneWayExpense)) {
				if (ObjectUtil.compare(StringUtil.trim(this.oneWayExpense), "0") == 0) {
					return false;
				}
				return true;
			}
			return false;
		}

		/**
		 * 領収No.の申請入力値チェック.
		 */
		public function checkApply_receiptNo():Boolean
		{
			// 入力必須でない.
			return true;
		}

		/**
		 * 備考の申請入力値チェック.
		 */
		public function checkApply_note():Boolean
		{
			// 入力必須でない.
			return true;
		}

		/**
		 * 削除設定.
		 */
		public function setDelete():void
		{
		 	this.isDelete = true;
		 }

		/**
		 * 登録用データ変換.
		 */
		public function convertEntry():void
		{
// 2009.06.26 delete 編集するときに 数値しか扱えないようにしたため変換の必要なし.
//			if (this.expense) {
////				var cnvExpense:String = AccountingDataGrid.expenseSymbolOff(this.expense);
////				this.expense = cnvExpense;
//			}
		}

	}
}