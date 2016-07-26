package subApplications.personnelAffair.logic
{
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.controls.*;
    import mx.core.IDataRenderer;
    import mx.events.*;
    import mx.managers.*;
    import mx.states.*;
    
    import subApplications.personnelAffair.web.Belonging;
    import subApplications.personnelAffair.web.DepartmentChangeDlg;
    import subApplications.personnelAffair.web.PlaceChangeDlg;
    
    import utils.CommonIcon;
    
	/**
	 * ChangeのLogicクラスです。

	 */
	public class BelongingLogic extends Logic
	{
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function BelongingLogic()
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
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 	「検索」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_btnSearch(e:MouseEvent):void
	    {
	    }
	    
		/**
		 * 	部署異動「追加」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkAddDepartmentChange(e:MouseEvent):void
	    {
			// 部署異動画面を作成する.
			openDepartmentChangeDlg();
	    }
	    
		/**
		 * 	部署異動「変更」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkUpdateDepartmentChange(e:MouseEvent):void
	    {
			// 部署異動画面を作成する.
			openDepartmentChangeDlg();
	    }
	    
		/**
		 * 	部署異動「削除」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkDeleteDepartmentChange(e:MouseEvent):void
	    {
			Alert.show("削除してもよろしいですか？",
			 "",
			  Alert.YES | Alert.NO,
			   view,
			    onClose_deleteDepartmentChangeAlert,
			    CommonIcon.questionIcon);
	    }
	    
		/**
		 * 	勤務地異動「追加」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkAddPlaceChange(e:MouseEvent):void
	    {
			// 勤務地異動画面を作成する.
			openPlaceChangeDlg();
	    }
	    
		/**
		 * 	勤務地異動「変更」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkUpdatePlaceChange(e:MouseEvent):void
	    {
			// 勤務地異動画面を作成する.
			openPlaceChangeDlg();
	    }
	    
		/**
		 * 	勤務地異動「削除」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkDeletePlaceChange(e:MouseEvent):void
	    {
			Alert.show("削除してもよろしいですか？",
			 "",
			  Alert.YES | Alert.NO,
			   view,
			    onClose_deletePlaceChangeAlert,
			    CommonIcon.questionIcon);
	    }
	    
		/**
		 * リンクボタン選択 検索条件の表示.
		 *
		 */
		public function onClick_linkShowSearchCondition(e:MouseEvent):void
		{
			view.vbxShowSearchCondition.width = 0;
			view.vbxShowSearchCondition.height = 0;
			view.vbxHideSearchCondition.percentWidth = 100;
			view.vbxHideSearchCondition.percentHeight = 100;
		}

		/**
		 * リンクボタン選択 閉じる.
		 *
		 */
		public function onClick_linkHideSearchCondition(e:MouseEvent):void
		{
			view.vbxShowSearchCondition.percentWidth = 100;
			view.vbxShowSearchCondition.percentHeight = 100;
			view.vbxHideSearchCondition.width = 0;
			view.vbxHideSearchCondition.height = 0;
		}

		/**
		 * placeChangeDlg(部署異動)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_departmentChangeDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK){
				// TODO:ここに定資格登録処理を記述
			}
		}
	    
		/**
		 * placeChangeDlg(勤務地異動)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_placeChangeDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK){
				// TODO:ここに定資格登録処理を記述
			}
		}
	    
	    /**
	     * 部署異動削除 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_deleteDepartmentChangeAlert(e:CloseEvent):void
		{
			// 「OK」ならば.
			if (e.detail == Alert.YES) {
				// TODO:資格削除処理
			}
		}

	    /**
	     * 勤務地異動削除 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_deletePlaceChangeAlert(e:CloseEvent):void
		{
			// 「OK」ならば.
			if (e.detail == Alert.YES) {
				// TODO:資格削除処理
			}
		}

	    
//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * PlaceChangeDlg(部署異動)のオープン.
		 *
		 */
		private function openDepartmentChangeDlg():void
		{
			// 部署異動画面を作成する.
			var pop:DepartmentChangeDlg = new DepartmentChangeDlg();
			PopUpManager.addPopUp(pop, view, true);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// 社員名をセット
			obj.staffName = "大野 純一";
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_placeChangeDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}
		
		/**
		 * PlaceChangeDlg(勤務地異動)のオープン.
		 *
		 */
		private function openPlaceChangeDlg():void
		{
			// 勤務地異動画面を作成する.
			var pop:PlaceChangeDlg = new PlaceChangeDlg();
			PopUpManager.addPopUp(pop, view, true);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// 社員名をセット
			obj.staffName = "大野 純一";
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_placeChangeDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:Belonging;

	    /**
	     * 画面を取得します

	     */
	    public function get view():Belonging
	    {
	        if (_view == null) {
	            _view = super.document as Belonging;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:Belonging):void
	    {
	        _view = view;
	    }

	}    
}