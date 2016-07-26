package subApplications.customer.logic
{
	import components.PopUpWindow;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.validators.Validator;

	import subApplications.customer.dto.CustomerDto;
	import subApplications.customer.dto.CustomerMemberDto;
	import subApplications.customer.web.CustomerMemberEntry;

	/**
	 * CustomerMemberEntryのLogicクラスです.
	 */
	public class CustomerMemberEntryLogic extends Logic
	{
		/** 引き継いだ顧客情報 */
		private var _customer:CustomerDto;

		/** 引き継いだ顧客担当者情報 */
		private var _member:CustomerMemberDto;

		/** 追加する顧客担当者情報 */
		private var _newMember:CustomerMemberDto;

		/** 更新する顧客担当者情報 */
		private var _updMember:CustomerMemberDto;

		/** 削除する顧客担当者情報 */
		private var _delMember:CustomerMemberDto;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CustomerMemberEntryLogic()
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
			// 引き継ぎデータを取得する.
			_customer = view.data.customer;
			_member   = view.data.member;
			onCreationCompleteHandler_setDisplayData();


			// 中央に表示されたとき validator を行なう.
			view.addEventListener(MoveEvent.MOVE, onWindowMove);
	    }

		/**
		 * 表示データの設定.
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			if (!_member) {
				view.btnDelete.enabled = false;
				view.btnDelete.visible = false;
				_member = CustomerMemberDto.newMember(_customer);
			}
			setDisplayData();
		}
		public function setDisplayData(member:CustomerMemberDto = null):void
		{
			if (!member)	member = _member;
			view.lastName.text      = member.lastName;
			view.firstName.text     = member.firstName;
			view.lastNameKana.text  = member.lastNameKana;
			view.firstNameKana.text = member.firstNameKana;
			view.department.text    = member.department;
			view.position.text      = member.position;
			view.telephone.text     = member.telephone;
			view.fax.text           = member.fax;
			view.telephone2.text    = member.telephone2;
			view.email.text         = member.email;
			view.addressNo.text     = member.addressNo;
			view.address.text       = member.address;
			view.note.text          = member.note;
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
			// mxml定義のvalidateチェックを行なう.
			var results:Array = Validator.validateAll(view.validateItems);
			if (results.length == 0)
				view.btnEntry.enabled = true;
			else
				view.btnEntry.enabled = false;
		}


		/**
		 * 登録ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:MouseEvent):void
		{
			Alert.show("設定してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 設定データを取得する.
			var member:CustomerMemberDto = createMember();

			// 担当者更新のとき
			if (view.btnDelete.visible) {
				_updMember = member;
			}
			// 新規登録のとき.
			else {
				_newMember = member;
			}

			// 顧客登録画面に戻る.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * 削除ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_delete_confirm(e:MouseEvent):void
		{
			Alert.show("削除設定してもよろしいですか？", "", 3, view, onButtonClick_delete_confirmResult);
		}
		protected function onButtonClick_delete_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_delete(e);
		}
		protected function onButtonClick_delete(e:Event):void
		{
			// 設定データを取得する.
			_delMember = createMember();

			// 顧客登録画面に戻る.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:MouseEvent):void
		{
			view.closeWindow();
		}

		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			if (view.authorize)		opneHelpWindow("CustomerMemberEntry");
			else					opneHelpWindow("CustomerMemberRef");
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
		 * 担当者の作成.
		 *
		 */
		private function createMember():CustomerMemberDto
		{
			// 設定データを取得する.
			var member:CustomerMemberDto = _member;
			member.lastName  = view.lastName.text.length > 0 ? view.lastName.text : null;
			member.firstName = view.firstName.text.length > 0 ? view.firstName.text : null;
			member.lastNameKana  = view.lastNameKana.text.length > 0 ? view.lastNameKana.text : null;
			member.firstNameKana = view.firstNameKana.text.length > 0 ? view.firstNameKana.text : null;
			member.department = view.department.text.length > 0 ? view.department.text : null;
			member.position   = view.position.text.length > 0 ? view.position.text : null;
			member.telephone  = view.telephone.text.length > 0 ? view.telephone.text : null;
			member.telephone2 = view.telephone2.text.length > 0 ? view.telephone2.text : null;
			member.fax        = view.fax.text.length > 0 ? view.fax.text : null;
			member.email      = view.email.text.length > 0 ? view.email.text : null;
			member.addressNo  = view.addressNo.text.length > 0 ? view.addressNo.text : null;
			member.address    = view.address.text.length > 0 ? view.address.text : null;
			member.note       = view.note.text.length > 0 ? view.note.text : null;
			member.setFullName();
			return member;
		}

		/**
		 * 追加担当者の取得.
		 *
		 * @return 顧客担当者情報.
		 */
		public function getNewMember():CustomerMemberDto
		{
			return _newMember;
		}

		/**
		 * 更新担当者の取得.
		 *
		 * @return 顧客担当者情報.
		 */
		public function getUpdateMember():CustomerMemberDto
		{
			return _updMember;
		}

		/**
		 * 削除担当者の取得.
		 *
		 * @return 顧客担当者情報.
		 */
		public function getDeleteMember():CustomerMemberDto
		{
			return _delMember;
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CustomerMemberEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CustomerMemberEntry
	    {
	        if (_view == null) {
	            _view = super.document as CustomerMemberEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CustomerMemberEntry):void
	    {
	        _view = view;
	    }
	}
}