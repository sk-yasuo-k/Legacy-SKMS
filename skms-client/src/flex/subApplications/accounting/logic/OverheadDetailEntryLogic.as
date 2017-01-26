package subApplications.accounting.logic
{

	import components.PopUpWindow;

	import dto.StaffDto;

	import enum.EquipmentKindId;
	import enum.OverheadTypeId;
	import enum.PaymentId;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.RadioButton;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.MoveEvent;
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.Validator;

	import subApplications.accounting.dto.EquipmentDto;
	import subApplications.accounting.dto.OverheadDetailDto;
	import subApplications.accounting.web.OverheadDetailEntry;


	/**
	 * 諸経費申請登録のLogicクラスです.
	 */
	public class OverheadDetailEntryLogic extends Logic
	{
		/** 更新対象の諸経費 */
		protected var _overheadD:OverheadDetailDto;

		/** モニタ使用定義 */
		[Bindable]
		public static var MONITOR_UNUSED:int = 1;
		[Bindable]
		public static var MONITOR_USE:int    = 2;

		/** 使用目的定義 */
		[Bindable]
		public static var USE_STAFF:int = 1;
		[Bindable]
		public static var USE_SHARE:int = 2;



//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function OverheadDetailEntryLogic()
		{
			super();
		}


//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {
			// 中央に表示されたとき validator を行なう.
			view.addEventListener(MoveEvent.MOVE, onWindowMove);

	    	view.visible = false;

			// 諸経費データを設定する.
			if (view.data.overhead) {
				_overheadD = view.data.overhead;
			}
			// その他データを設定する.
			view.cmbOverheadType.dataProvider  = view.data.overheadType;
			view.cmbEquipmentKind.dataProvider = view.data.equipmentKind;
			view.rpPaymentType.dataProvider    = view.data.paymentType;
			view.cmbPaymentCard.dataProvider   = view.data.creditCard;
			view.cmbAccountItem.dataProvider   = view.data.accountItem;
			view.cmbPcKind_pc.dataProvider        = view.data.pcKind;
			view.cmbManagementStaff_pc.dataProvider = view.data.staff;
			view.cmbManagementStaff_pcOther.dataProvider = view.data.staff;
			view.cmbManagementStaff_celp.dataProvider = view.data.staff;
			view.cmbManagementStaff_mbc.dataProvider = view.data.staff;
			view.cmbLocation_pc.dataProvider = view.data.installationLocation;
			view.cmbJanre_soft.dataProvider = view.data.janre;
			view.cmbJanre_book.dataProvider = view.data.janre;
			view.cmbJanre_dvd.dataProvider = view.data.janre;

			// 表示データを設定する.
			setEntryOverhead();

			// 勘定科目の表示を設定する.
			if (!view.authorizeApproval) {
				view.fmBase.removeChild(view.fmiAccountItem);
			}
			// 管理番号の表示を設定する.
			if (view.approval || view.approvalAf) {
				;
			}
			else {
				view.fmEquipmentPc.removeChild(view.fmiManagementNo_pc);
				view.fmEquipmentPcOther.removeChild(view.fmiManagementNo_pcOther);
				view.fmEquipmentCelP.removeChild(view.fmiManagementNo_celp);
				view.fmEquipmentMbc.removeChild(view.fmiManagementNo_mbc);
				view.fmEquipmentSoft.removeChild(view.fmiManagementNo_soft);
				view.fmEquipmentBook.removeChild(view.fmiManagementNo_book);
				view.fmEquipmentDvd.removeChild(view.fmiManagementNo_dvd);
			}

			// validate を行なう.
			 //Validator.validateAll(view.validateItems);
			 view.visible = true;
	    }



//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * Window移動イベント.
		 *
		 * @param e MoveEvent
		 */
		private function onWindowMove(e:MoveEvent):void
		{
			//trace ("move");
			// validateを行なう.
	    	view.removeEventListener(MoveEvent.MOVE, onWindowMove);
	    	Validator.validateAll(view.validateItems);
		}

		/**
		 * 諸経費区分リストの選択.
		 *
		 * @param event ListEvent.
		 */
		public function onChangeComboBox_overheadType(e:ListEvent):void
		{
			var item:Object = view.cmbOverheadType.selectedItem;
			switch (item.data) {
				// 食事.
				case OverheadTypeId.MEAL:
					view.currentState = "stsMeal";
					break;

				// その他.
				case OverheadTypeId.OTHER:
				// 非管理設備.
				case OverheadTypeId.NOT_MANAGEMENT_EQUIPMENT:
				// 研修.
				case OverheadTypeId.STUDY:
				// 宅配料金.
				case OverheadTypeId.DELIVERY:
					view.currentState = "stsOther";
					break;

				// 管理設備.
				case OverheadTypeId.MANAGEMENT_EQUIPMENT:
					view.currentState = "stsEquipment";
					break;

				// 上記以外.
				default:
					view.currentState = "";
					break;
			}

			// validate チェックを行なう.
			Validator.validateAll(view.validateItems);
		}

		/**
		 * 設備種別リストの選択.
		 *
		 * @param event ListEvent.
		 */
		public function onChangeComboBox_equipmentKind(e:ListEvent):void
		{
			var item:Object = view.cmbEquipmentKind.selectedItem;
			switch (item.data) {
				// PC..
				case EquipmentKindId.PC:
					view.currentState = "stsEquipmentPc";
					break;
				//  PC周辺機器.
				case EquipmentKindId.PC_OTHER:
					view.currentState = "stsEquipmentPcOther";
					break;
				//  携帯.
				case EquipmentKindId.MOBILE:
					view.currentState = "stsEquipmentCellularPhone";
					break;
				//  モバイルカード.
				case EquipmentKindId.MOBILE_CARD:
					view.currentState = "stsEquipmentMobileCard";
					break;

				// ソフトウェア.
				case EquipmentKindId.SOFTWARE:
					view.currentState = "stsEquipmentSoftware";
				break;

				// 書籍.
				case EquipmentKindId.BOOK:
					view.currentState = "stsEquipmentBook";
					break;

				// DVD.
				case EquipmentKindId.DVD:
					view.currentState = "stsEquipmentDvd";
					break;

				default:
					view.currentState = "";
					break;
			}

			// validate を行う.
			validate();
		}


		/**
		 * 設定ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:MouseEvent):void
		{
			// validate チェックを行なう.
			var results:Array = Validator.validateAll(view.validateItems);
			if (results && results.length > 0) {
				Alert.show("未入力の項目があります。\n入力してください。");
				return;
			}
			Alert.show("設定してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				if (_overheadD)
					view.closeWindow(PopUpWindow.ENTRY);
				else
					view.dispatchEvent(new Event("entryNew"));
			}
		}

//		/**
//		 * （新規）設定ボタンの押下.
//		 *
//		 * @param e MouseEvent
//		 */
//		public function onButtonClick_entryNew_confirm(e:MouseEvent):void
//		{
//			// validate チェックを行なう.
//			var results:Array = Validator.validateAll(view.validateItems);
//			if (results && results.length > 0) {
//				Alert.show("未入力の項目があります。\n入力してください。");
//			}
//			else {
//				Alert.show("設定してもよろしいですか？", "", 3, view, onButtonClick_entryNew_confirmResult);
//			}
//		}
//		protected function onButtonClick_entryNew_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) {
//				view.dispatchEvent(new Event("entryNew"));
//			}
//		}
//
//		/**
//		 * （変更）設定ボタンの押下.
//		 *
//		 * @param e MouseEvent
//		 */
//		public function onButtonClick_entryUpdate_confirm(e:MouseEvent):void
//		{
//			// validate チェックを行なう.
//			var results:Array = Validator.validateAll(view.validateItems);
//			if (results && results.length > 0) {
//				Alert.show("未入力の項目があります。\n入力してください。");
//			}
//			else {
//				Alert.show("設定してもよろしいですか？", "", 3, view, onButtonClick_entryUpdate_confirmResult);
//			}
//		}
//		protected function onButtonClick_entryUpdate_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) {
//				view.closeWindow(PopUpWindow.ENTRY);
//			}
//		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 諸経費情報の設定.
		 *
		 */
		private function setEntryOverhead():void
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				return;
			}

			if (_overheadD) {
				// 日付.
				view.overheadDate.selectedDate = _overheadD.overheadDate;
				// 金額.
				view.expense.text = _overheadD.expense;
				// 支払方法.
				for each (var item:RadioButton in view.rdPaymentType) {
					if (ObjectUtil.compare(item.value, _overheadD.paymentId) == 0) {
						item.selected = true;
					}
				}
				if (_overheadD.paymentId == PaymentId.CARD) {
					var clist:ArrayCollection = view.cmbPaymentCard.dataProvider as ArrayCollection;
					for each (var cobj:Object in clist) {
						if (ObjectUtil.compare(cobj.data2, _overheadD.paymentInfo) == 0) {
							view.cmbPaymentCard.selectedItem = cobj;
							break;
						}
					}
				}
				// 勘定科目.
				if (view.authorizeApproval) {
					var ailist:ArrayCollection = view.cmbAccountItem.dataProvider as ArrayCollection;
					for each (var aiobj:Object in ailist) {
						if (ObjectUtil.compare(aiobj.label, _overheadD.accountItemName) == 0) {
							view.cmbAccountItem.selectedItem = aiobj;
							break;
						}
					}
				}
				// 諸経費区分.
				var otist:ArrayCollection = view.cmbOverheadType.dataProvider as ArrayCollection;
				for each (var otobj:Object in otist) {
					if (ObjectUtil.compare(otobj.label, _overheadD.overheadTypeName) == 0) {
						view.cmbOverheadType.selectedItem = otobj;
						view.cmbOverheadType.dispatchEvent(new ListEvent(ListEvent.CHANGE));
						switch (view.currentState) {
							// 諸経費区分 その他.
							case "stsOther":
								view.contentContent.text = _overheadD.contentA;
								break;

							// 諸経費区分 食事.
							case "stsMeal":
								view.contentPurpose.text = _overheadD.contentA;
								view.contentShop.text    = _overheadD.contentB;
								view.contentPeople.text  = _overheadD.contentC;
								break;

							// 諸経費区分 管理設備.
							case "stsEquipment":
								// 設備情報を設定する.
								setEquipmentInfo(_overheadD.equipment);
								break;

							// 上記以外のとき.
							default:
								break;
						}
						break;
					}
				}
				// 備考.
				view.note.text = _overheadD.note;
			}

			// デフォルトデータを設定する.
			setDefault_managmentStaff(view.cmbManagementStaff_pc);
			setDefault_managmentStaff(view.cmbManagementStaff_pcOther);
			setDefault_managmentStaff(view.cmbManagementStaff_celp);
			setDefault_managmentStaff(view.cmbManagementStaff_mbc);
		}

		/**
		 * 設備情報の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentInfo(equip:EquipmentDto):void
		{
			// 設備種別.
			var eqlist:ArrayCollection = view.cmbEquipmentKind.dataProvider as ArrayCollection;
			for each (var eqobj:Object in eqlist) {
				if (ObjectUtil.compare(eqobj.data, equip.equipmentKindId) == 0) {
					view.cmbEquipmentKind.selectedItem = eqobj;
					view.cmbEquipmentKind.dispatchEvent(new ListEvent(ListEvent.CHANGE));
					break;
				}
			}
			switch (view.currentState) {
				// PC.
				case "stsEquipmentPc":
					setEquipmentPc(equip);
					break;
				// PC周辺機器.
				case "stsEquipmentPcOther":
					setEquipmentPcOther(equip);
					break;
				// 携帯.
				case "stsEquipmentCellularPhone":
					setEquipmentCellularPhone(equip);
					break;
				// モバイルカード.
				case "stsEquipmentMobileCard":
					setEquipmentMobileCard(equip);
					break;
				// ソフトウェア.
				case "stsEquipmentSoftware":
					setEquipmentSoftware(equip);
					break;
				// 書籍.
				case "stsEquipmentBook":
					setEquipmentBook(equip);
					break;
				// DVD.
				case "stsEquipmentDvd":
					setEquipmentDvd(equip);
					break;
			}
		}

		/**
		 * 設備情報 PC の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentPc(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_pc.text = equip.managementNo;
			}
			// メーカ.
			view.maker_pc.text = equip.maker;
			// 型番.
			view.equipmentNo_pc.text = equip.equipmentNo;
			// 製造番号.
			view.equipmentSerialNo_pc.text = equip.equipmentSerialNo
			// PC種別.
			var pclist:ArrayCollection = view.cmbPcKind_pc.dataProvider as ArrayCollection;
			for each (var pcobj:Object in pclist) {
				if (ObjectUtil.compare(pcobj.data, equip.pcKindId) == 0) {
					view.cmbPcKind_pc.selectedItem = pcobj;
					break;
				}
			}
			// 使用目的.
			if (ObjectUtil.compare(view.rdUseStaff_pc.label, equip.pcUse) == 0) {
				view.rdUseStaff_pc.selected = true;
			}
			else {
				view.useShare_pc.text = equip.pcUse;
				view.rdUseShare_pc.selected = true;
			}
			// 管理者.
			var mglist:ArrayCollection = view.cmbManagementStaff_pc.dataProvider as ArrayCollection;
			for each (var mgobj:Object in mglist) {
				if (ObjectUtil.compare(mgobj.data, equip.managementStaffId) == 0) {
					view.cmbManagementStaff_pc.selectedItem = mgobj;
					break;
				}
			}
			// 保証期限.
			view.guaranteedDate_pc.selectedDate = equip.guaranteedDate;
			// 購入日付・購入店.
			view.purchaseDate_pc.selectedDate = equip.purchaseDate;
			view.purchaseShop_pc.text = equip.purchaseShop;
			// モニタ.
			if (ObjectUtil.compare(view.rdMonitorUnuse_pc.label, equip.monitorUse) == 0) {
				view.rdMonitorUnuse_pc.selected = true;
			}
			else {
				view.monitorUse_pc.text = equip.monitorUse;
				view.rdMonitorUse_pc.selected = true;
			}
			// 設置場所.
			var lolist:ArrayCollection = view.cmbLocation_pc.dataProvider as ArrayCollection;
			var flg:Boolean = true;
			for each (var loobj:Object in lolist) {
				if (ObjectUtil.compare(loobj.label, equip.location) == 0) {
					flg = false;
					view.cmbLocation_pc.selectedItem = loobj;
					break;
				}
			}
			if (flg && equip.location) {
				lolist.addItem({label:equip.location, data:-1});
				view.cmbLocation_pc.selectedIndex = lolist.length;
			}


			// 備考.
			view.equipmentNote_pc.text = equip.note;
		}

		/**
		 * 設備情報 PC周辺機器 の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentPcOther(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_pcOther.text = equip.managementNo;
			}
			// メーカ.
			view.maker_pcOther.text = equip.maker;
			// 型番.
			view.equipmentNo_pcOther.text = equip.equipmentNo;
			// 機器名.
			view.equipmentName_pcOther.text = equip.equipmentName;
			// 製造番号.
			view.equipmentSerialNo_pcOther.text = equip.equipmentSerialNo
			// 使用目的.
			if (ObjectUtil.compare(view.rdUseStaff_pcOther.label, equip.pcUse) == 0) {
				view.rdUseStaff_pcOther.selected = true;
			}
			else {
				view.useShare_pcOther.text = equip.pcUse;
				view.rdUseShare_pcOther.selected = true;
			}
			// 管理者.
			var mglist:ArrayCollection = view.cmbManagementStaff_pcOther.dataProvider as ArrayCollection;
			for each (var mgobj:Object in mglist) {
				if (ObjectUtil.compare(mgobj.data, equip.managementStaffId) == 0) {
					view.cmbManagementStaff_pcOther.selectedItem = mgobj;
					break;
				}
			}
			// 保証期限.
			view.guaranteedDate_pcOther.selectedDate = equip.guaranteedDate;
			// 購入日付・購入店.
			view.purchaseDate_pcOther.selectedDate = equip.purchaseDate;
			view.purchaseShop_pcOther.text = equip.purchaseShop;

			// 備考.
			view.equipmentNote_pcOther.text = equip.note;
		}

		/**
		 * 設備情報 携帯 の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentCellularPhone(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_celp.text = equip.managementNo;
			}
			// メーカ.
			view.maker_celp.text = equip.maker;
			// 型番.
			view.equipmentNo_celp.text = equip.equipmentNo;
			// 製造番号.
			view.equipmentSerialNo_celp.text = equip.equipmentSerialNo
			// 管理者.
			var mglist:ArrayCollection = view.cmbManagementStaff_celp.dataProvider as ArrayCollection;
			for each (var mgobj:Object in mglist) {
				if (ObjectUtil.compare(mgobj.data, equip.managementStaffId) == 0) {
					view.cmbManagementStaff_celp.selectedItem = mgobj;
					break;
				}
			}
			// 保証期限.
			view.guaranteedDate_celp.selectedDate = equip.guaranteedDate;
			// 購入日付・購入店.
			view.purchaseDate_celp.selectedDate = equip.purchaseDate;
			view.purchaseShop_celp.text = equip.purchaseShop;

			// 備考.
			view.equipmentNote_celp.text = equip.note;
		}

		/**
		 * 設備情報 モバイルカード の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentMobileCard(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_mbc.text = equip.managementNo;
			}
			// メーカ.
			view.maker_mbc.text = equip.maker;
			// 型番.
			view.equipmentNo_mbc.text = equip.equipmentNo;
			// 製造番号.
			view.equipmentSerialNo_mbc.text = equip.equipmentSerialNo
			// 管理者.
			var mglist:ArrayCollection = view.cmbManagementStaff_mbc.dataProvider as ArrayCollection;
			for each (var mgobj:Object in mglist) {
				if (ObjectUtil.compare(mgobj.data, equip.managementStaffId) == 0) {
					view.cmbManagementStaff_mbc.selectedItem = mgobj;
					break;
				}
			}
			// 保証期限.
			view.guaranteedDate_mbc.selectedDate = equip.guaranteedDate;
			// 購入日付・購入店.
			view.purchaseDate_mbc.selectedDate = equip.purchaseDate;
			view.purchaseShop_mbc.text = equip.purchaseShop;

			// 備考.
			view.equipmentNote_mbc.text = equip.note;
		}

		/**
		 * 設備情報 ソフトウェア の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentSoftware(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_soft.text = equip.managementNo;
			}
			// タイトル.
			view.title_soft.text = equip.title;
			// メーカ.
			view.publisher_soft.text = equip.publisher;
			// 製造年.
			view.publicationYear_soft.text = String(equip.publicationYear);
			// 動作OS.
			view.operationOs_soft.text = equip.operationOs;
			// ライセンス.
			view.license_soft.text = equip.license;
			// ジャンル.
			var jlist:ArrayCollection = view.cmbJanre_soft.dataProvider as ArrayCollection;
			for each (var jobj:Object in jlist) {
				if (ObjectUtil.compare(jobj.data, equip.janreId) == 0) {
					view.cmbJanre_soft.selectedItem = jobj;
					break;
				}
			}
			// 所蔵場所.
			view.location_soft.text = equip.location;
			// 備考.
			view.equipmentNote_soft.text = equip.note;
		}

		/**
		 * 設備情報 書籍 の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentBook(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_book.text = equip.managementNo;
			}
			// タイトル.
			view.title_book.text = equip.title;
			// メーカ.
			view.publisher_book.text = equip.publisher;
			// 製造年.
			view.publicationYear_book.text = String(equip.publicationYear);
			// ジャンル.
			var jlist:ArrayCollection = view.cmbJanre_book.dataProvider as ArrayCollection;
			for each (var jobj:Object in jlist) {
				if (ObjectUtil.compare(jobj.data, equip.janreId) == 0) {
					view.cmbJanre_book.selectedItem = jobj;
					break;
				}
			}
			// 所蔵場所.
			view.location_book.text = equip.location;
			// 備考.
			view.equipmentNote_book.text = equip.note;
		}

		/**
		 * 設備情報 DVD の設定.
		 *
		 * @param equip 設備情報.
		 */
		private function setEquipmentDvd(equip:EquipmentDto):void
		{
			// 管理番号.
			if (view.approval || view.approvalAf) {
				view.managementNo_dvd.text = equip.managementNo;
			}
			// タイトル.
			view.title_dvd.text = equip.title;
			// メーカ.
			view.publisher_dvd.text = equip.publisher;
			// 製造年.
			view.publicationYear_dvd.text = String(equip.publicationYear);
			// ジャンル.
			var jlist:ArrayCollection = view.cmbJanre_dvd.dataProvider as ArrayCollection;
			for each (var jobj:Object in jlist) {
				if (ObjectUtil.compare(jobj.data, equip.janreId) == 0) {
					view.cmbJanre_dvd.selectedItem = jobj;
					break;
				}
			}
			// 所蔵場所.
			view.location_dvd.text = equip.location;
			// 備考.
			view.equipmentNote_dvd.text = equip.note;
		}

		/**
		 * 管理者のデフォルト設定.
		 *
		 * @param 管理者オブジェクト.
		 */
		private function setDefault_managmentStaff(target:ComboBox):void
		{
			var staff:StaffDto = Application.application.indexLogic.loginStaff;
			var slist:ArrayCollection = target.dataProvider as ArrayCollection;
			if (!target.selectedItem) {
				for each (var sobj:Object in slist) {
					if (ObjectUtil.compare(sobj.data, staff.staffId) == 0) {
						target.selectedItem = sobj;
					}
				}
			}
		}



		/**
		 * 登録データの取得.
		 *
		 * @return 諸経費データ.
		 */
		public function get entryOverhead():Object
		{
			var overhead:OverheadDetailDto = OverheadDetailDto.entry(_overheadD);

			// 日付.
			overhead.overheadDate = view.overheadDate.selectedDate;
			// 金額.
			overhead.expense      = view.expense.text;
			// 支払区分.
			if (view.rdPaymentTypeGrp.selection) {
				overhead.paymentId    = int(view.rdPaymentTypeGrp.selectedValue);
				overhead.paymentName  = view.rdPaymentTypeGrp.selection.label;
			}
			switch (view.rdPaymentTypeGrp.selectedValue) {
				case PaymentId.CARD:
					overhead.paymentInfo  = view.cmbPaymentCard.selectedItem.data2;
					break;
			}
			// 勘定科目.
			if (view.authorizeApproval && view.cmbAccountItem.selectedItem) {
				overhead.accountItemId   = view.cmbAccountItem.selectedItem.data;
				overhead.accountItemName = view.cmbAccountItem.selectedLabel;
			}
			// 諸経費区分.
			if (view.cmbOverheadType.selectedItem) {
				overhead.overheadTypeId   = view.cmbOverheadType.selectedItem.data;
				overhead.overheadTypeName = view.cmbOverheadType.selectedLabel;
			}
			// 諸経費区分.
			var preEquipInfo:String = view.cmbEquipmentKind.selectedLabel;
			switch (view.currentState) {
				case "stsOther":
					overhead.equipment= getEntryOverhead_notEquipment(overhead.equipment);;
					overhead.contentA = getText(view.contentContent);
					overhead.content  = overhead.contentA;
					break;

				case "stsMeal":
					overhead.equipment= getEntryOverhead_notEquipment(overhead.equipment);;
					overhead.contentA = getText(view.contentPurpose);
					overhead.contentB = getText(view.contentShop);
					overhead.contentC = getText(view.contentPeople);
					overhead.content  = overhead.contentA;
					if (overhead.contentB)
						overhead.content += "\n" + "→" + overhead.contentB;
					if (overhead.contentC)
						overhead.content += "(" + overhead.contentC + "人)";
					break;

				case "stsEquipmentPc":
					overhead.equipment= getEntryOverhead_equipmentPc(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.maker + "　" + overhead.equipment.equipmentNo;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentPcOther":
					overhead.equipment= getEntryOverhead_equipmentPcOther(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.maker + "　" + overhead.equipment.equipmentName;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentCellularPhone":
					overhead.equipment= getEntryOverhead_equipmentCellularPhone(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.maker + "　" + overhead.equipment.equipmentNo;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentMobileCard":
					overhead.equipment= getEntryOverhead_equipmentMobileCard(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.maker + "　" + overhead.equipment.equipmentNo;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentSoftware":
					overhead.equipment= getEntryOverhead_equipmentSoftware(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.title;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentBook":
					overhead.equipment= getEntryOverhead_equipmentBook(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.title;
					overhead.content  = overhead.contentA;
					break;

				case "stsEquipmentDvd":
					overhead.equipment= getEntryOverhead_equipmentDvd(overhead.equipment);
					overhead.contentA = preEquipInfo + " ： " + overhead.equipment.title;
					overhead.content  = overhead.contentA;
					break;
			}
			// 備考.
			overhead.note = getText(view.note);

			return overhead;
		}

		/**
		 * PC 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentPc(equip:EquipmentDto):EquipmentDto
		{
			var equipmentPc:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentPc.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentPc.managementNo = getText(view.managementNo_pc);
			// メーカ.
			equipmentPc.maker = getText(view.maker_pc);
			// 型番.
			equipmentPc.equipmentNo = getText(view.equipmentNo_pc);
			// 製造番号.
			equipmentPc.equipmentSerialNo = getText(view.equipmentSerialNo_pc);
			// PC種別.
			equipmentPc.pcKindId    = view.cmbPcKind_pc.selectedItem.data;
			// 使用目的.
			if (view.rdUseShare_pc.selected)
				equipmentPc.pcUse = getText(view.useShare_pc);
			else if (view.rdUseStaff_pc.selected)
				equipmentPc.pcUse = view.rdUseStaff_pc.label;
			// 管理者.
			equipmentPc.managementStaffId = view.cmbManagementStaff_pc.selectedItem.data;
			// 保証期限.
			equipmentPc.guaranteedDate = view.guaranteedDate_pc.selectedDate;
			// 購入日付・購入店.
			equipmentPc.purchaseDate = view.purchaseDate_pc.selectedDate;
			equipmentPc.purchaseShop = getText(view.purchaseShop_pc);
			// モニタ.
			if (view.rdMonitorUnuse_pc.selected)
				equipmentPc.monitorUse = view.rdMonitorUnuse_pc.label;
			else if (view.rdMonitorUse_pc.selected)
				equipmentPc.monitorUse = getText(view.monitorUse_pc);
			// 設置場所.
			if (view.cmbLocation_pc.selectedItem) {
				equipmentPc.location = view.cmbLocation_pc.selectedLabel;
			}
			else {
				equipmentPc.location = getText(view.cmbLocation_pc);
			}
			// 備考.
			equipmentPc.note = getText(view.equipmentNote_pc);

			return equipmentPc;
		}

		/**
		 * PC周辺機器 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentPcOther(equip:EquipmentDto):EquipmentDto
		{
			var equipmentPcOther:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentPcOther.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentPcOther.managementNo = getText(view.managementNo_pcOther);
			// メーカ.
			equipmentPcOther.maker = getText(view.maker_pcOther);
			// 型番.
			equipmentPcOther.equipmentNo = getText(view.equipmentNo_pcOther);
			// 機器名
			equipmentPcOther.equipmentName = getText(view.equipmentName_pcOther);
			// 製造番号.
			equipmentPcOther.equipmentSerialNo = getText(view.equipmentSerialNo_pcOther);
			// 使用目的.
			if (view.rdUseShare_pcOther.selected)
				equipmentPcOther.pcUse = getText(view.useShare_pcOther);
			else if (view.rdUseStaff_pcOther.selected)
				equipmentPcOther.pcUse = view.rdUseStaff_pcOther.label;
			// 管理者.
			equipmentPcOther.managementStaffId = view.cmbManagementStaff_pcOther.selectedItem.data;
			// 保証期限.
			equipmentPcOther.guaranteedDate = view.guaranteedDate_pcOther.selectedDate;
			// 購入日付・購入店.
			equipmentPcOther.purchaseDate = view.purchaseDate_pcOther.selectedDate;
			equipmentPcOther.purchaseShop = getText(view.purchaseShop_pcOther);
			// 備考.
			equipmentPcOther.note = getText(view.equipmentNote_pcOther);

			return equipmentPcOther;
		}

		/**
		 * 携帯 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentCellularPhone(equip:EquipmentDto):EquipmentDto
		{
			var equipmentCelp:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentCelp.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentCelp.managementNo = getText(view.managementNo_celp);
			// メーカ.
			equipmentCelp.maker = getText(view.maker_celp);
			// 型番.
			equipmentCelp.equipmentNo = getText(view.equipmentNo_celp);
			// 製造番号.
			equipmentCelp.equipmentSerialNo = getText(view.equipmentSerialNo_celp);
			// 管理者.
			equipmentCelp.managementStaffId = view.cmbManagementStaff_celp.selectedItem.data;
			// 保証期限.
			equipmentCelp.guaranteedDate = view.guaranteedDate_celp.selectedDate;
			// 購入日付・購入店.
			equipmentCelp.purchaseDate = view.purchaseDate_celp.selectedDate;
			equipmentCelp.purchaseShop = getText(view.purchaseShop_celp);
			// 備考.
			equipmentCelp.note = getText(view.equipmentNote_celp);

			return equipmentCelp;
		}

		/**
		 * モバイルカーど 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentMobileCard(equip:EquipmentDto):EquipmentDto
		{
			var equipmentMbc:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentMbc.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentMbc.managementNo = getText(view.managementNo_mbc);
			// メーカ.
			equipmentMbc.maker = getText(view.maker_mbc);
			// 型番.
			equipmentMbc.equipmentNo = getText(view.equipmentNo_mbc);
			// 製造番号.
			equipmentMbc.equipmentSerialNo = getText(view.equipmentSerialNo_mbc);
			// 管理者.
			equipmentMbc.managementStaffId = view.cmbManagementStaff_mbc.selectedItem.data;
			// 保証期限.
			equipmentMbc.guaranteedDate = view.guaranteedDate_mbc.selectedDate;
			// 購入日付・購入店.
			equipmentMbc.purchaseDate = view.purchaseDate_mbc.selectedDate;
			equipmentMbc.purchaseShop = getText(view.purchaseShop_mbc);
			// 備考.
			equipmentMbc.note = getText(view.equipmentNote_mbc);

			return equipmentMbc;
		}

		/**
		 * ソフトウェア 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentSoftware(equip:EquipmentDto):EquipmentDto
		{
			var equipmentSf:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentSf.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentSf.managementNo = getText(view.managementNo_soft);
			// タイトル.
			equipmentSf.title = getText(view.title_soft);
			// メーカ.
			equipmentSf.publisher = getText(view.publisher_soft);
			// 製造年.
			equipmentSf.publicationYear = int(getText(view.publicationYear_soft));
			// 動作OS.
			equipmentSf.operationOs = getText(view.operationOs_soft);
			// ライセンス.
			equipmentSf.license = getText(view.license_soft);
			// ジャンル.
			equipmentSf.janreId = view.cmbJanre_soft.selectedItem.data;
			// 所蔵場所.
			equipmentSf.location = getText(view.location_soft);
			// 備考.
			equipmentSf.note = getText(view.equipmentNote_soft);

			return equipmentSf;
		}

		/**
		 * 書籍 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentBook(equip:EquipmentDto):EquipmentDto
		{
			var equipmentBk:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentBk.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentBk.managementNo = getText(view.managementNo_book);
			// タイトル.
			equipmentBk.title = getText(view.title_book);
			// メーカ.
			equipmentBk.publisher = getText(view.publisher_book);
			// 製造年.
			equipmentBk.publicationYear = int(getText(view.publicationYear_book));
			// ジャンル.
			equipmentBk.janreId = view.cmbJanre_book.selectedItem.data;
			// 所蔵場所.
			equipmentBk.location = getText(view.location_book);
			// 備考.
			equipmentBk.note = getText(view.equipmentNote_book);

			return equipmentBk;
		}

		/**
		 * DVD 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_equipmentDvd(equip:EquipmentDto):EquipmentDto
		{
			var equipmentDvd:EquipmentDto = EquipmentDto.entry(equip);

			// 設備種別.
			equipmentDvd.equipmentKindId = view.cmbEquipmentKind.selectedItem.data;
			// 管理番号.
			if (view.approval || view.approvalAf)
				equipmentDvd.managementNo = getText(view.managementNo_dvd);
			// タイトル.
			equipmentDvd.title = getText(view.title_dvd);
			// メーカ.
			equipmentDvd.publisher = getText(view.publisher_dvd);
			// 製造年.
			equipmentDvd.publicationYear = int(getText(view.publicationYear_dvd));
			// ジャンル.
			equipmentDvd.janreId = view.cmbJanre_dvd.selectedItem.data;
			// 所蔵場所.
			equipmentDvd.location = getText(view.location_dvd);
			// 備考.
			equipmentDvd.note = getText(view.equipmentNote_dvd);

			return equipmentDvd;
		}

		/**
		 * PC 登録データの取得.
		 *
		 * @param 設備データ.
		 * @return 設備データ.
		 */
		private function getEntryOverhead_notEquipment(equip:EquipmentDto):EquipmentDto
		{
			var equipmentPc:EquipmentDto = EquipmentDto.entryNo(equip);
			return equipmentPc;
		}


		/**
		 * validateチェック.
		 *
		 * @return チェック結果.
		 */
		public function validate():Boolean
		{
			var results:Array = Validator.validateAll(view.validateItems);
			if (results && results.length > 0) 		return false;
			else 									return true;
		}

//		/**
//		 *
//		 *
//		 */
//		public function onInvalid_paymentType(e:ValidationResultEvent):void
//		{
//			var validator:Validator = e.currentTarget as Validator;
//			var items:Array = view.rdPaymentType;
//			for each (var item:RadioButton in items) {
//				item.errorString = validator.requiredFieldError;
//			}
//		}
//
//		public function onValid_paymentType(e:ValidationResultEvent):void
//		{
//			var validator:Validator = e.currentTarget as Validator;
//			var items:Array = view.rdPaymentType;
//			for each (var item:RadioButton in items) {
//				item.errorString = "";
//			}
//		}


		/**
		 * テキストデータの取得.
		 *
		 * @param control コントロール.
		 * @return データ.
		 */
		private function getText(control:Object):String
		{
			var text:String = control.text;
			if (StringUtil.trim(text).length > 0)	return text;
			else									return null;
		}



//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OverheadDetailEntry;

	    /**
	     * 画面を取得します
	     */
	    public function get view():OverheadDetailEntry
	    {
	        if (_view == null) {
	            _view = super.document as OverheadDetailEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:OverheadDetailEntry):void
	    {
	        _view = view;
	    }

	}
}

