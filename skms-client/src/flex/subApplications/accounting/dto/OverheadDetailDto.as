package subApplications.accounting.dto
{
	import mx.utils.ObjectUtil;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.OverheadDetailDto")]
	public class OverheadDetailDto
	{
		public function OverheadDetailDto()
		{
			;
		}

		/**
		 * 諸経費申請IDです.
		 */
		public var overheadId:int;

		/**
		 * 諸経費申請明細連番です.
		 */
		public var overheadNo:int;

	    /**
		 * 諸経費発生日です.
		 */
		public var overheadDate:Date;

		/**
		 * 諸経費区分IDです.
		 */
		public var overheadTypeId:int;

		/**
		 * 諸経費区分です.
		 */
		public var overheadTypeName:String;

		/**
		 * 内訳です.
		 */
		public var content:String;

		/**
		 * 内訳要素その1です.
		 */
		public var contentA:String;

		/**
		 * 内訳要素その2です.
		 */
		public var contentB:String;

		/**
		 * 内訳要素その3です.
		 */
		public var contentC:String;

		/**
		 * 勘定科目IDです.
		 */
		public var accountItemId:int;

		/**
		 * 勘定科目名です.
		 */
		public var accountItemName:String;

		/**
		 * 支払IDです.
		 */
		public var paymentId:int;

		/**
		 * 支払名です.
		 */
		public var paymentName:String;

		/**
		 * 支払情報です.
		 */
		public var paymentInfo:String;

		/**
		 * 金額です.
		 */
		public var expense:String;

		/**
		 * 領収書番号です.
		 */
		public var receiptNo:String;

		/**
		 * 備考です.
		 */
		public var note:String;

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
		 * 設備情報です.
		 */
		public var equipment:EquipmentDto;

		/**
		 * 削除フラグです.
		 */
		public var isDelete:Boolean;


		/**
		 * 一覧データの更新.
		 */
		public function update(overhead:Object):void
		{
			if (!(overhead as OverheadDetailDto))	return;
			//this.overheadId:int;
			//this.overheadNo:int;
			this.overheadDate     = overhead.overheadDate;
			this.overheadTypeId   = overhead.overheadTypeId;
			this.overheadTypeName = overhead.overheadTypeName;
			this.content          = overhead.content;
			this.contentA         = overhead.contentA;
			this.contentB         = overhead.contentB;
			this.contentC         = overhead.contentC;
			this.accountItemId    = overhead.accountItemId;
			this.accountItemName  = overhead.accountItemName;
			this.paymentId        = overhead.paymentId;
			this.paymentName      = overhead.paymentName;
			this.paymentInfo      = overhead.paymentInfo;
			this.expense          = overhead.expense;
			//this.receiptNo:String;
			this.note             = overhead.note;
			//this.registrationTime:Date;
			//this.registrantId:int;
			//this.registrationVer:int;
			//this.isDelete:Boolean;
			this.equipment        = overhead.equipment;
		}

		/**
		 * インスタンス作成.
		 *
		 * @return インスタンス.
		 */
		private static function create():OverheadDetailDto
		{
			var dst:OverheadDetailDto = new OverheadDetailDto();
			var nMax:int = 20000; var nMin:int = 10000;
			var ran:int  = Math.floor(Math.random()*(nMax-nMin+1))+nMin;
			dst.overheadId = ran>0 ? (0-ran) : ran;

			nMax = 60000; nMin = 50000;
			ran = Math.floor(Math.random()*(nMax-nMin+1))+nMin;
			dst.overheadNo = ran>0 ? (0-ran) : ran;

			return dst;
		}

		/**
		 * 一致確認.
		 *
		 * @return true/false 一致/不一致.
		 */
		public static function compare(comp1:Object, comp2:Object):Boolean
		{
			if (!comp1 || !comp2)	return false;
			if (!(comp1 is OverheadDetailDto))	return false;
			if (!(comp2 is OverheadDetailDto))	return false;
			if (ObjectUtil.compare(comp1.overheadId, comp2.overheadId) == 0 &&
				ObjectUtil.compare(comp1.overheadNo, comp2.overheadNo) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 複製用データの作成.
		 * OverheadDto.copy から呼ばれる.
		 */
		 public static function copy(overhead:OverheadDetailDto):OverheadDetailDto
		 {
		 	var dst:OverheadDetailDto = new OverheadDetailDto();
		 	//dst.overheadDate
		 	dst.overheadTypeId		= overhead.overheadTypeId;
		 	dst.overheadTypeName	= overhead.overheadTypeName;
		 	dst.content				= overhead.content;
		 	dst.contentA 		 	= overhead.contentA;
		 	dst.contentB			= overhead.contentB;
		 	dst.contentC			= overhead.contentC;
		 	dst.accountItemId		= overhead.accountItemId;
		 	dst.accountItemName 	= overhead.accountItemName;
		 	dst.paymentId			= overhead.paymentId;
		 	dst.paymentName			= overhead.paymentName;
		 	dst.paymentInfo			= overhead.paymentInfo;
		 	dst.expense				= overhead.expense;
		 	//dst.receiptNo
		 	dst.note				= overhead.note;
		 	dst.equipment			= EquipmentDto.copy(overhead.equipment);
		 	return dst;
		 }

		/**
		 * 登録用データの作成.
		 */
		 public static function entry(overhead:OverheadDetailDto):OverheadDetailDto
		 {
		 	if (overhead)	return ObjectUtil.copy(overhead) as OverheadDetailDto;
			else			return create()
		 }

	}
}