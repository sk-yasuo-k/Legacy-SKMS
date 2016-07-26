package subApplications.project.logic.custom
{
	import flash.system.System;
	
	import logic.Logic;
	
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	
	import subApplications.project.dto.ProjectDto;
	//import subApplications.project.dto.ProjectSituationDto;
	import subApplications.project.web.custom.ProjectDataGrid;

	/**
	 * ProjectDataGridのLogicクラスです.
	 */
	public class ProjectDataGridLogic extends Logic
	{
		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;

		/** プロジェクト完了色 */
		private var _completeColor:Number = -1;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectDataGridLogic()
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
		 * 列ヘッダソートイベント.
		 *
		 * @param e DataGridEvent
		 */
		public function onHeaderRelease(e:DataGridEvent):void
		{
			// ソートのあと背景色設定が呼ばれるよう、実行キューに追加する.
			view.callLater(setColorPattern);
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * プロジェクト完了色.
		 *
		 * @param color 完了色
		 */
		public function setCompleteColor(color:Number):void
		{
			_completeColor = color;
		}

		/**
		 * DataProvider設定.
		 *
		 */
		public function setDataProvider():void
		{
			// 背景色を設定する.
			setColorPattern();
		}

		/**
		 * 表示行数変更.
		 *
		 */
		public function changeRowCount():void
		{
			// 背景色を設定する.
			setColorPattern();
		}

		/**
		 * 行の色変更処理.
		 *
		 */
		private function setColorPattern():void
		{
			if (!(_completeColor > 0))	return;
			if (!(view.dataProvider))	return;

			// 初期値のカラーパターンを保持する.
			if (!_defaultColors) {
				_defaultColors = view.getStyle("alternatingItemColors");
			}

			var colors:Array = new Array();
			// 表の行数を取得する.
			var rowNum:int = view.dataProvider.length;
			var rowCnt:int = view.rowCount;
			// 初期表示・表示領域を拡大しているとき 初期値・現在の背景色で表示しようとするため.
			// 表示最大行数を ダミー値の 50 に設定しておく.
			//var rowMax:int = (rowNum > rowCnt) ? rowNum : rowCnt;
			var rowMax:int = 50 * ((int)(rowNum / 50) + 1);
			for (var i:int = 0; i < rowMax; i++){
				if (i < rowNum) {
					// データによって色を変更する.
					var project:ProjectDto = view.dataProvider.getItemAt(i) as ProjectDto;
					if (!project)	continue;
					if (project.comlete()){
						colors.push(_completeColor);			// プロジェクト完了.
					}
					else{
						colors.push(_defaultColors[i%2]);		// プロジェクト未完了.
					}
				}
				else {
					colors.push(_defaultColors[i%2]);
				}
			}
			view.setStyle("alternatingItemColors", colors);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectDataGrid;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectDataGrid
	    {
	        if (_view == null) {
	            _view = super.document as ProjectDataGrid;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:ProjectDataGrid):void
	    {
	        _view = view;
	    }
	}
}