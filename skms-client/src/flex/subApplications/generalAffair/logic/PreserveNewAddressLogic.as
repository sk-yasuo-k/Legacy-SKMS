package subApplications.generalAffair.logic
{
	
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import subApplications.generalAffair.web.PreserveNewAddress;
	
	/**
	 * 保存登録確認ロジッククラスです.
	 */
	public class PreserveNewAddressLogic extends Logic
	{


		/** 引越日 */
		[Bindable]
		public var moveDate:String;

		/** 郵便番号1 */
		[Bindable]
		public var postalCode1:String;
		
		/** 郵便番号2 */
		[Bindable]
		public var postalCode2:String;

		/** 都道府県名 */
		[Bindable]
		public var prefectureName:String;
		
		/** 市区町村番地 */
		[Bindable]
		public var ward:String;		
		
		/** ビル */
		[Bindable]
		public var houseNumber:String;

		/** 市区町村(フリガナ) */
		[Bindable]
		public var wardKana:String;

		/** ビル(フリガナ) */
		[Bindable]
		public var houseNumberKana:String;

		/** 自宅電話番号1 */
		[Bindable]
		public var homePhoneNo1:String;

		/** 自宅電話番号2 */
		[Bindable]
		public var homePhoneNo2:String;
		
		/** 自宅電話番号3 */
		[Bindable]
		public var homePhoneNo3:String;

		/** 表札名 */
		[Bindable]
		public var nameplate:String;
		
		/** 世帯主 */
		[Bindable]
		public var householder:String;		

		/** 連絡のとりやすい社員 */
		[Bindable]
		public var associateStaff:String;


//--------------------------------------
//  Constructor
//--------------------------------------

		/**
		 * コンストラクタ.
		 */
		public function PreserveNewAddressLogic()
		{
			super();
		}


//--------------------------------------
//  Initialization
//--------------------------------------

	    /**
	     * onCreationCompleteHandler
	     * 
	     */
    	override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {
			moveDate        = view.data.moveDate;
			postalCode1     = view.data.postalCode1;
			postalCode2     = view.data.postalCode2;
			prefectureName  = view.data.prefectureName;
			ward            = view.data.ward;
			houseNumber     = view.data.houseNumber;
			wardKana        = view.data.wardKana;
			houseNumberKana = view.data.houseNumberKana;
			homePhoneNo1    = view.data.homePhoneNo1;
			homePhoneNo2    = view.data.homePhoneNo2;
			homePhoneNo3    = view.data.homePhoneNo3;
			nameplate       = view.data.nameplate;
			householder     = view.data.householder;
			associateStaff  = view.data.associateStaff;
	    	
	    	BindingUtils.bindProperty(view.moveDate, "text", this, "moveDate");
	 	    BindingUtils.bindProperty(view.postalCode1, "text", this, "postalCode1");   	
	    	BindingUtils.bindProperty(view.postalCode2, "text", this, "postalCode2");
	    	BindingUtils.bindProperty(view.prefectureName, "text", this, "prefectureName");
	    	BindingUtils.bindProperty(view.ward, "text", this, "ward");
	    	BindingUtils.bindProperty(view.houseNumber, "text", this, "houseNumber");
	    	BindingUtils.bindProperty(view.wardKana, "text", this, "wardKana");
	    	BindingUtils.bindProperty(view.houseNumberKana, "text", this, "houseNumberKana");
	    	BindingUtils.bindProperty(view.homePhoneNo1, "text", this, "homePhoneNo1");
	    	BindingUtils.bindProperty(view.homePhoneNo2, "text", this, "homePhoneNo2");
	    	BindingUtils.bindProperty(view.homePhoneNo3, "text", this, "homePhoneNo3");
	    	BindingUtils.bindProperty(view.nameplate, "text", this, "nameplate");
	    	BindingUtils.bindProperty(view.householder, "text", this, "householder");	    		    	
	    	BindingUtils.bindProperty(view.associateStaff, "text", this, "associateStaff");	
	    	    
	    }
	    


//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/** OKボタン処理 */
		public function onOkButtonClick(e:MouseEvent):void
		{			
			/** 画面のクローズを行う */
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);

		}
			
		/** Cancelボタン処理 */
		public function onCancelButtonClick(e:MouseEvent):void
		{
			/** 画面のクローズを行う */
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------

	    /** 画面 */
	    public var _view:PreserveNewAddress;

	    /**
	     * 画面を取得します

	     */
	    public function get view():PreserveNewAddress
	    {
	        if (_view == null) {
	            _view = super.document as PreserveNewAddress;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:PreserveNewAddress):void
	    {
	        _view = view;
	    }		
	}
}