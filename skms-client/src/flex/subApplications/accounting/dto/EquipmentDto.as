package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.EquipmentDto")]
	public class EquipmentDto
	{
		public function EquipmentDto()
		{
			;
		}

		/**
		 * 設備IDです.
		 */
		public var equipmentId:int;

		/**
		 * 管理番号です.
		 */
		public var managementNo:String;

		/**
		 * 設備種別IDです.
		 */
		public var equipmentKindId:int;

		/**
		 * メーカです.
		 */
		public var maker:String;

		/**
		 * 設備名です.
		 */
		public var equipmentName:String;

		/**
		 * 型番です.
		 */
		public var equipmentNo:String;

		/**
		 * 製造番号です.
		 */
		public var equipmentSerialNo:String;

		/**
		 * 使用目的です.
		 */
		public var pcUse:String;

		/**
		 * 管理社員IDです.
		 */
		public var managementStaffId:Number;

		/**
		 * 管理プロジェクトIDです.
		 */
		public var managementProjectId:Number;

		/**
		 * 購入日付です.
		 */
		public var purchaseDate:Date;

		/**
		 * 購入店です.
		 */
		public var purchaseShop:String;

		/**
		 * 保証期限です.
		 */
		public var guaranteedDate:Date;

		/**
		 * PC種別IDです.
		 */
		public var pcKindId:Number;

		/**
		 * PC種別名です.
		 */
		public var pcKindName:String;

		/**
		 * モニタ使用です.
		 */
		public var monitorUse:String;


		/**
		 * タイトルです。
		 */
		public var title:String;

		/**
		 * 著者です。
		 */
		public var author:String;

		/**
		 * 出版年です。
		 */
		public var publicationYear:Number;

		/**
		 * 出版社です。
		 */
		public var publisher:String;

		/**
		 * ジャンルIDです。
		 */
		public var janreId:Number;

		/**
		 * ライセンスです。
		 */
		public var license:String;

		/**
		 * 動作OSです。
		 */
		public var operationOs:String;


		/**
		 * 設置場所 / 所蔵場所です.
		 */
		public var location:String;

		/**
		 * 備考です.
		 */
		public var note:String


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
		 * 削除フラグです.
		 */
		public var isDelete:Boolean;


		/**
		 * 諸経費IDです.
		 */
		public var overheadId:int;

		/**
		 * 諸経費連番です.
		 */
		public var overheadNo:int;


		/**
		 * 複製用データの作成.
		 * OverheadDto.copy から呼ばれる.
		 */
		 public static function copy(equip:EquipmentDto):EquipmentDto
		 {
		 	if (!equip)		return null;
		 	var dst:EquipmentDto = new EquipmentDto();
		 	//dst.equipmentId
		 	//dst.managementNo
		 	dst.equipmentKindId			= equip.equipmentKindId;
		 	dst.maker					= equip.maker;
		 	dst.equipmentName			= equip.equipmentName;
		 	dst.equipmentNo				= equip.equipmentNo;
		 	dst.equipmentSerialNo		= equip.equipmentSerialNo;
		 	dst.pcUse					= equip.pcUse;
		 	dst.managementStaffId		= equip.managementStaffId;
			dst.managementProjectId		= equip.managementProjectId;
		 	//dst.purchaseDate
			dst.purchaseShop			= equip.purchaseShop;
			//dst.guaranteedDate			= equip.guaranteedDate;
			dst.pcKindId				= equip.pcKindId;
			dst.monitorUse 				= equip.monitorUse;

			dst.title					= equip.title;
			dst.author					= equip.author;
			dst.publicationYear			= equip.publicationYear;
			dst.publisher				= equip.publisher;
			dst.janreId					= equip.janreId;
			dst.license 				= equip.license;
			dst.operationOs				= equip.operationOs;

			dst.location				= equip.location;
			dst.note					= equip.note;
		 	return dst;
		 }


		/**
		 * 登録用データの作成.
		 */
		 public static function entry(equip:EquipmentDto):EquipmentDto
		 {
		 	var dst:EquipmentDto = new EquipmentDto;
		 	if (equip) {
				dst.equipmentId = equip.equipmentId;
				dst.registrationVer = equip.registrationVer;
			 	dst.isDelete = false;
		 	}
		 	return dst;
		 }

		/**
		 * 削除用データの作成.
		 */
		 public static function entryNo(equip:EquipmentDto):EquipmentDto
		 {
		 	if (!equip)
		 		return null;

		 	equip.isDelete = true;
		 	return equip;
		 }
	}
}