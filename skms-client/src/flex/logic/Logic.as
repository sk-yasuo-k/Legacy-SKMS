package logic
{
import flash.events.ContextMenuEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.core.IMXMLObject;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;

/**
 * 各Logicクラスで共通の機能を実装する
 */
public class Logic implements IMXMLObject {


    /** MXMLファイルを参照するクラス */
    private var _document:UIComponent;

    /** MXMLファイル上で指定されたid */
    private var _id:String;


    public function initialized(document:Object, id:String):void {
        _document = document as UIComponent;
        _id = id;

        _document.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteHandler, false, 0, true);
    }


    /**
     * 初期化処理
     *
     * @param event FlexEvent
     */
    protected function onCreationCompleteHandler(event:FlexEvent):void {

    }


    /**
     * document を取得する
     *
     * @return document
     */
    public final function get document():UIComponent {
        return _document;
    }


    /**
     * id を取得する
     *
     * @return id
     */
    public final function get id():String {
        return _id;
    }


	/** ヘルプ画面定義 */
	private static const HELPITEMS:Array = new Array({mode:"index",             html:"Index.html"},
													 {mode:"indexPL",           html:"Index_PL.html"},
													 {mode:"indexPM",           html:"Index_PM.html"},
													 {mode:"indexAF",           html:"Index_AF.html"},
													 {mode:"ProjectEntry",      html:"ProjectEntry.html"},
													 {mode:"ProjectBaseEntry",  html:"ProjectEntry.html#RANGE!C56"},
													 {mode:"ProjectBillEntry",  html:"ProjectEntry.html#RANGE!C92"},
													 {mode:"ProjectRef",        html:"ProjectReference.html"},
													 {mode:"ProjectSelect",     html:"ProjectSelect.html"},
													 {mode:"RouteSearch",       html:"RouteSearch.html"},
													 {mode:"RouteEntry",        html:"RouteEntry.html"},
													 {mode:"TransportApproval", html:"TransportationApproval.html"},
													 {mode:"TransportRequest",  html:"TransportationRequest.html"},
													 {mode:"TransportEntry",    html:"TransportationEntry.html"},
													 {mode:"StaffSetting",    	html:"StaffSetting.html"},
													 {mode:"CustomerEntry",     html:"CustomerEntry.html"},
													 {mode:"CustomerRef",       html:"CustomerReference.html"},
													 {mode:"CustomerInfoEntry", html:"CustomerEntry.html#RANGE!C57"},
													 {mode:"CustomerInfoRef",   html:"CustomerReference.html#RANGE!C50"},
													 {mode:"CustomerMemberEntry",html:"CustomerEntry.html#RANGE!C83"},
													 {mode:"CustomerMemberRef", html:"CustomerReference.html#RANGE!C73"},
													 {mode:"CustomerSortChange",html:"CustomerEntry.html#RANGE!C107"},
													 {mode:"CustomerInfoRead",  html:"CustomerEntry.html#RANGE!C136"},
													 {mode:"UnderConstruction", html:"UnderConstruction.html"}
													 )
	/**
	 * ヘルプ画面を表示する.
	 *
	 * @param mode 表示中の画面.
	 */
	public static function opneHelpWindow(mode:String = null):void
	{
		// 表示するヘルプHTMLを取得する.
		var directry:String = "./help/";
		var html:String = HELPITEMS[0].html;
		for (var i:int = 0; i < HELPITEMS.length; i++) {
			if (ObjectUtil.compare(mode, HELPITEMS[i].mode) == 0) {
				html = HELPITEMS[i].html;
				break;
			}
		}
		var url:String = directry + html;					// HTML.

		// ヘルプ画面を作成する.
		var winName:String = "ヘルプ";						// ウィンドウ名.
		var w:int  = 800;
		var h:int  = 400;
		var toolbar:int = 0;								// ツールバーの表示.
		var location:int = 1;								// 場所ツールバーの表示.
		var directories:int = 0;							// ユーザ設定のツールバーの表示.
		var status:int = 0;									// ステータスバーの表示.
		var menubar:int = 0;								// メニューバーの表示.
		var scrollbars:int = 1;								// スクロールバーの表示.
		var resizable:int = 1;								// リサイズ設定.
		var fullURL:String = "javascript:var myWin;" + "if(!myWin || myWin.closed)" + "{myWin = window.open('" + url + "','" + winName + "','" + "width=" + w + ",height=" + h  + ",toolbar=" + toolbar + ",location=" + location + ",directories=" + directories + ",status=" + status + ",menubar=" + menubar + ",scrollbars=" + scrollbars + ",resizable=" + resizable + ",top='+((screen.height/2)-(" + h/2 + "))+'" + ",left='+((screen.width/2)-(" + w/2 + "))+'" + "')}"
													 + "else{myWin.location.href='" + url + "';" + "myWin.focus();};void(0);";
		var u:URLRequest = new URLRequest(fullURL);
		navigateToURL(u,"_self");
	}

	/**
	 * ヘルプメニューの作成.
	 *
	 * @return コンテキストメニュー.
	 */
	protected function createContextMenu_win():ContextMenu
	{
		// コンテキストメニューを作成する.
		var contextMenu:ContextMenu = new ContextMenu();
		contextMenu.hideBuiltInItems();

		// コンテキストメニュー：ヘルプ.
		var cmItem:ContextMenuItem = new ContextMenuItem("ヘルプ");
		cmItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_help);
		cmItem.enabled = true;
		contextMenu.customItems.push(cmItem);
		// コンテキストメニューを返す.
		return contextMenu;
	}

	/**
	 * ヘルプメニュー選択.
	 *
	 * @param e ContextMenuEvent.
	 */
	 protected function onMenuSelect_help(e:ContextMenuEvent):void
	 {
	 }

}
}