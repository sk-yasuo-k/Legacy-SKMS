package subApplications.customer.logic
{
	import components.PopUpWindow;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.IDataRenderer;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.validators.Validator;

	import subApplications.customer.dto.CustomerDto;
	import subApplications.customer.dto.CustomerMemberDto;
	import subApplications.customer.web.CustomerEntry;
	import subApplications.customer.web.CustomerMemberEntry;

	/**
	 * CustomerEntryのLogicクラスです.
	 */
	public class CustomerEntryLogic extends Logic
	{
		/** 引き継いだ顧客情報 */
		private var _customer:CustomerDto;

		/** 表示中の顧客担当者情報リスト */
		private var _displayMemberList:ArrayCollection = new ArrayCollection();

		/** 担当解除する顧客担当者情報リスト */
		private var _deleteMemberList:ArrayCollection = new ArrayCollection();

		/** 顧客番号リスト */
		private var _customerNoList:ArrayCollection = new ArrayCollection([{customerType:"C", customerNo:""},
																		   {customerType:"E", customerNo:""}
																		   ]);

		/** 一覧reloadフラグ */
		private var _reload:Boolean = false;

		/** 担当者入力エラー */
		private const ERROR_MEMBER:String = "errorMembers";

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CustomerEntryLogic()
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

			// 引き継ぎデータを取得する.
			_customer = view.data.customer;
			onCreationCompleteHandler_setDisplayData();

	    }

		/**
		 * 表示データの設定.
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			// 画面データを作成する.
			if (!_customer)
				_customer = new CustomerDto();
			view.customerTypeGrp.selectedValue = _customer.customerType;
			view.customerType.text          = _customer.customerType;
			view.customerNo.text            = _customer.customerNo;
			view.customerName.text          = _customer.customerName;
			view.customerAlias.text         = _customer.customerAlias;
			view.lastName.text              = _customer.representativeLastName;
			view.firstName.text             = _customer.representativeFirstName;
			view.lastNameKana.text          = _customer.representativeLastNameKana;
			view.firstNameKana.text         = _customer.representativeFirstNameKana;
			view.customerHtml.text          = _customer.customerHtml;
			view.customerStartDate.selectedDate = _customer.customerStartDate;
			view.billPayable.text = _customer.billPayable;
			if (_customer.customerMembers && _customer.customerMembers.length > 0)
				_displayMemberList = _customer.customerMembers;
			makeComponent_customerMembers(_displayMemberList);
			view.note.text                  = _customer.note;


			// 登録権限があるとき顧客コードを発行する.
			if (view.authorize) {
				// 顧客番号リストを作成する.
				for (var index:int = 0; index < _customerNoList.length; index++) {
					// 顧客番号Itemを取得する.
					var item:Object = _customerNoList.getItemAt(index);

					// 顧客区分が一致しているならば 番号を設定する.
					if (ObjectUtil.compare(_customer.customerType, item.customerType) == 0) {
						item.customerNo = _customer.customerNo;
					}

					// 番号が未設定ならば 次に採番する顧客番号を取得する.
					if (!item.customerNo || ObjectUtil.compare(item.customerNo, "") == 0) {
						requestCustomerCode(item.customerType);
					}
					_customerNoList.setItemAt(item, index);
				}
			}
		}


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * validateチェック.
		 *
		 * @param e Event
		 */
		public function onValidateCheck(e:Event):void
		{
			// 初回validateが実行されていないときは validateチェックしない.
			if (view.hasEventListener(MoveEvent.MOVE))	return;

			// mxml定義のvalidateチェックを行なう.
			var results:Array = Validator.validateAll(view.validateItems);
			var errobj:Object = view.formCustomerMembers.getChildByName(ERROR_MEMBER);
			if (results.length == 0 && !errobj)
				view.btnEntry.enabled = true;
			else
				view.btnEntry.enabled = false;

		}


		/**
		 * 顧客区分変更イベント.
		 *
		 * @param e Event
		 */
		public function onChange_customerTypeGrp(e:Event):void
		{
			// 顧客番号を取得する.
			view.customerNo.text = getCustomerNo(e.currentTarget.selectedValue);

			// validateチェックする.
			onValidateCheck(e);
		}


		/**
		 * 担当者のクリックイベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_customerMember(e:MouseEvent):void
		{
			// 担当者を取得する.
			var memberId:String = e.currentTarget.id;
			for (var index:int = 0; index < _displayMemberList.length; index++) {
				var dispMember:CustomerMemberDto = _displayMemberList.getItemAt(index) as CustomerMemberDto;
				if (ObjectUtil.compare(memberId, dispMember.customerMemberId.toString()) == 0 ) {
					// 担当者情報登録P.U.を表示する.
					open_customerMemberEntry(onClose_customerMemberUpdate, dispMember);
					break;
				}
			}
		}

		/**
		 * 担当者追加のクリックイベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_customerNewMember(e:MouseEvent):void
		{
			// 担当者情報登録P.U.を表示する.
			open_customerMemberEntry(onClose_customerMemberEntry);
		}


		/**
		 * 担当者情報更新P.U.のクローズイベント.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_customerMemberUpdate(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				// 更新メンバーを取得する.
				var pop:CustomerMemberEntry = e.currentTarget as CustomerMemberEntry;
				var popMember:CustomerMemberDto;
				if (pop.updateMember)	popMember = pop.updateMember;
				else					popMember = pop.deleteMember;

				// メンバーリストから更新メンバを取得する.
				for (var index:int = 0; index < _displayMemberList.length; index++) {
					var member:CustomerMemberDto = _displayMemberList.getItemAt(index) as CustomerMemberDto;
					if (CustomerMemberDto.compare(member, popMember)) {
						// 更新のとき.
						if (pop.updateMember) {
							_displayMemberList.setItemAt(popMember, index);
						}
						// 解除のとき.
						else {
							_displayMemberList.removeItemAt(index);
							_deleteMemberList.addItem(popMember);
						}
					}
				}
				// 担当者リストを更新する.
				updateComponent_customerMembers(_displayMemberList);
			}
		}

		/**
		 * 担当者情報登録P.U.のクローズイベント.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_customerMemberEntry(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				// 登録メンバーを取得する.
				var pop:CustomerMemberEntry = e.currentTarget as CustomerMemberEntry;
				var popMember:CustomerMemberDto = pop.newMember;

				// メンバーリストに追加する.
				_displayMemberList.addItem(popMember);

				// 担当者リストを更新する.
				updateComponent_customerMembers(_displayMemberList);
			}
		}


		/**
		 * 「登録」ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 登録.
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 登録データを取得する.
			_customer.customerType = view.customerTypeGrp.selectedValue as String;
			_customer.customerNo   = view.customerNo.text;
			_customer.customerName = view.customerName.text;
			_customer.customerAlias= view.customerAlias.text.length > 0 ? view.customerAlias.text : null;
			_customer.representativeLastName = view.lastName.text;
			_customer.representativeFirstName= view.firstName.text;
			_customer.representativeLastNameKana = view.lastNameKana.text;
			_customer.representativeFirstNameKana= view.firstNameKana.text;
			_customer.customerHtml = view.customerHtml.text.length > 0 ? view.customerHtml.text : null;
			_customer.customerStartDate = view.customerStartDate.selectedDate;
			_customer.billPayable  = view.billPayable.text.length > 0 ? view.billPayable.text : null;
			_customer.note         = view.note.text.length > 0 ? view.note.text : null;
			// 担当者を作成する.
			_customer.customerMembers = CustomerMemberDto.createMembers(_displayMemberList, _deleteMemberList);

			// 登録する.
			view.srv.getOperation("createCustomer").send(Application.application.indexLogic.loginStaff, _customer);
		}

		/**
		 * 「次の取引先情報へ」ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_next_confirm(e:Event):void
		{
			Alert.show("表示中の情報は破棄されますがよろしいですか？", "", 3, view, onButtonClick_next_confirmResult);
		}
		protected function onButtonClick_next_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_next(e);				// 登録.
		}
		protected function onButtonClick_next(e:Event):void
		{
			view.closeWindow(PopUpWindow.NEXT);
		}

		/**
		 * 「終了」ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_stop_confirm(e:Event):void
		{
			Alert.show("終了してもよろしいですか？", "", 3, view, onButtonClick_stop_confirmResult);
		}
		protected function onButtonClick_stop_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_stop(e);				// 登録.
		}
		protected function onButtonClick_stop(e:Event):void
		{
			view.closeWindow(PopUpWindow.STOP);
		}

		/**
		 * ヘルプボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			if (view.authorize) opneHelpWindow("CustomerInfoEntry");
			else				opneHelpWindow("CustomerInfoRef");
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:Event):void
		{
			if (_reload)		view.closeWindow(PopUpWindow.ENTRY);
			else				view.closeWindow();
		}


		/**
		 * createCustomer処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_createCustomer(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * getCustomerCode処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getCustomerCode(e:ResultEvent):void
		{
			var error:Boolean = true;
			var customerCode:String = e.result as String;
			if (customerCode && customerCode.length >= 3) {
				// 顧客番号を顧客番号リストに設定する.
				for (var index:int = 0; index < _customerNoList.length; index++) {
					// 顧客番号Itemを取得する.
					var item:Object = _customerNoList.getItemAt(index);

					// 顧客コードの1文字目が顧客区分と一致するか確認する.
					if (customerCode.indexOf(item.customerType) == 0) {
						item.customerNo = customerCode.substring(1);
						_customerNoList.setItemAt(item, index);
						error = false;
						break;
					}
				}
			}

			if (error) {
				CustomerLogic.alert_xxxx("顧客コード発行");
				view.closeWindow();
			}
			else {
				// 顧客区分が設定されていたら番号を取得する.
				if (view.customerType.text) {
					view.customerNo.text = getCustomerNo(view.customerType.text);
				}
			}
		}

		/**
		 * createCustomerの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_createCustomer(e:FaultEvent):void
		{
			//trace ("fault! createCustomer()" + " : " + e.toString());
			// 重複エラー.
			if (CustomerLogic.isExistFault(e)) {
				var newCode:String = CustomerLogic.getExistFault_customerCode(e);
				if (newCode && newCode.length >= 3) {
					// 重複エラーメッセージを表示する.
					CustomerLogic.alert_existCustomerCode(view.customerCode.text, newCode);

					// 顧客番号リストに新番号を設定する.
					var event:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, newCode);
					onResult_getCustomerCode(event);
				}
				else {
					// エラーメッセージを表示する.
					CustomerLogic.alert_xxxx("取引先情報登録");
				}
			}
			// 排他エラー.
			else if (CustomerLogic.isConflictFault(e)) {
				// 排他エラーメッセージを表示する.
				CustomerLogic.alert_conflictCustomer();
			}
			// その他エラー.
			else {
				// エラーメッセージを表示する.
				CustomerLogic.alert_xxxx("取引先情報登録");
			}
		}

		/**
		 * getCustomerCodeの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getCustomerCode(e:FaultEvent):void
		{
			trace ("fault! getCustomerCode()" + " : " + e.toString());
			CustomerLogic.alert_xxxx("顧客コード発行");
			view.closeWindow();
		}

//--------------------------------------
//  Function
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
	    	onValidateCheck(e as Event);
		}


		/**
		 * 顧客担当者情報登録P.U.の表示.
		 *
		 * @param closeFunction  P.U.クローズ関数.
		 * @param customerMember 登録する顧客担当情報.
		 */
		private function open_customerMemberEntry(closeFunction:Function, customerMember:CustomerMemberDto = null):void
		{
			// window を作成する.
			var pop:CustomerMemberEntry = new CustomerMemberEntry();
			pop.authorize = view.authorize;

			// 引き継ぐデータを作成する.
			var obj:Object = makeSucceedData(_customer, customerMember);

			// window を表示する.
			PopUpWindow.displayWindow(pop, view, obj);

			// window close イベントを登録する.
			pop.addEventListener(CloseEvent.CLOSE, closeFunction);
		}

		/**
		 * 引き継ぎデータの作成（担当者情報登録）.
		 *
		 * @param customer 顧客情報.
		 * @param member   顧客担当者情報.
		 */
		private function makeSucceedData(customer:CustomerDto, member:CustomerMemberDto = null):Object
		{
			var obj:Object = new Object();
			obj.customer   = ObjectUtil.copy(customer);
			obj.member     = ObjectUtil.copy(member);
			return obj;
		}


		/**
		 * 顧客コードの取得.
		 *
		 * @param customerType 顧客区分.
		 */
		 private function requestCustomerCode(customerType:String):void
		 {
			view.srv.getOperation("getCustomerCode").send(customerType);
		 }

		/**
		 * 顧客番号の取得.
		 *
		 * @param customerType 顧客区分.
		 * @return 顧客番号.
		 */
		 private function getCustomerNo(customerType:String):String
		 {
			// 顧客番号リストから取得する.
			for (var index:int = 0; index < _customerNoList.length; index++) {
				var item:Object = _customerNoList.getItemAt(index);
				if (ObjectUtil.compare(customerType, item.customerType) == 0) {
					return item.customerNo;
				}
			}
			return "";
		 }


		/**
		 * 担当者コンポーネントの作成.
		 *
		 * @param members 担当者リスト.
		 */
		 private function makeComponent_customerMembers(members:ArrayCollection):void
		 {
		 	// Grid の col row に相当するIndex を定義する.
			var labelIndex:int = 0;
			var hboxIndex:int  = 0;

			// 担当者コンポーネントを作成する.
			var currentHBox:HBox = new HBox();
			view.formCustomerMembers.addChildAt(currentHBox, hboxIndex);

			// 担当者をコンポーネントに追加する.
		 	if (members) {
			 	for (var index:int = 0; index < members.length; index++) {
			 		// メンバを取得する.
			 		var member:CustomerMemberDto = members.getItemAt(index) as CustomerMemberDto;

			 		// ラベルを追加する.
			 		var label:Label   = new Label();
			 		label.id   = member.getCustomerMemberIdToString();
			 		label.text = member.getFullName();
			 		label.buttonMode    = true;
			 		label.useHandCursor = true;
			 		label.mouseChildren = false;
			 		label.setStyle("styleName", "LabelLink");
			 		label.addEventListener(MouseEvent.CLICK, onClick_customerMember);
			 		currentHBox.addChildAt(label, labelIndex);

			 		// Label の width を取得するには validateNow() が必要のため呼び出す.
			 		currentHBox.validateNow();
			 		// 備考よりも担当者リストの幅が大きくなったら、新規Boxを準備する.
			 		if (currentHBox.measuredMinWidth + label.textWidth > view.note.width) {
			 			// 追加した Label を削除する.
			 			currentHBox.removeChildAt(labelIndex);

			 			// 新規 Box を作成する.
			 			labelIndex = 0;
			 			hboxIndex++;
						currentHBox = new HBox();
						view.formCustomerMembers.addChildAt(currentHBox, hboxIndex);

			 			// 削除した Label を追加する.
						currentHBox.addChildAt(label, labelIndex);
			 		}
			 		labelIndex++;
			 	}
		 	}

			// 共通データを追加する
			if (view.authorize) {
				var newButton:Button = new Button();
				newButton.label = "担当者を追加する";
				newButton.setStyle("styleName", "ButtonLink");
				newButton.addEventListener(MouseEvent.CLICK, onClick_customerNewMember);
				currentHBox.addChildAt(newButton, labelIndex);

				// 備考よりも担当者リストが小さいかどうか確認する.
				currentHBox.validateNow();
				if (currentHBox.measuredWidth + newButton.width > view.note.width) {
					// 削除する.
					currentHBox.removeChildAt(labelIndex);
					// 新規Boxを作成する.
					labelIndex = 0;
					hboxIndex++;
					currentHBox = new HBox();
					view.formCustomerMembers.addChildAt(currentHBox, hboxIndex);
					// 追加する.
					currentHBox.addChildAt(newButton, labelIndex);
				}


		 		// 取引先情報ファイルを読み込んだとき 必須項目・入力形式ミスの可能性があるため.
		 		// 入力データが正しいかどうか確認する.
				if (view.batchentry && members) {
					var errmember:String = "";
					for (var k:int = 0; k < members.length; k++) {
						var chkmember:CustomerMemberDto = members.getItemAt(k) as CustomerMemberDto;

						// 入力データ確認のため 担当者mxmlのvalidate を使用する.
						var pop:CustomerMemberEntry = new CustomerMemberEntry();
						pop.authorize = view.authorize;
						PopUpManager.addPopUp(pop, view, true);
						var obj:Object = makeSucceedData(_customer, null);
						IDataRenderer(pop).data = obj;
						if (!pop.checkData(chkmember)) {
							errmember += "「" + chkmember.getFullName() + "」";
						}
						PopUpManager.removePopUp(pop);
					}

					if (errmember.length > 0) {
				 		// エラーメッセージを追加する.
				 		var errBox:HBox = new HBox();
				 		errBox.name = ERROR_MEMBER;
				 		var errLabel:Label = new Label();
				 		errLabel.text = "※" + errmember + "に入力エラーがあります。";
				 		errLabel.setStyle("styleName", "LabelError");
				 		errBox.addChild(errLabel);
				 		view.formCustomerMembers.addChild(errBox);
					}
				}
			}
			else {
				if (currentHBox.numChildren == 0) {
			 		var noneLabel:Label   = new Label();
			 		noneLabel.text = "未定";
			 		currentHBox.addChild(noneLabel);
				}
			}
		 }

		/**
		 * 担当者コンポーネントの更新.
		 *
		 * @param members 担当者リスト.
		 */
		 private function updateComponent_customerMembers(members:ArrayCollection):void
		 {
		 	view.formCustomerMembers.removeAllChildren();
		 	makeComponent_customerMembers(members);
		 }


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CustomerEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CustomerEntry
	    {
	        if (_view == null) {
	            _view = super.document as CustomerEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CustomerEntry):void
	    {
	        _view = view;
	    }
	}
}