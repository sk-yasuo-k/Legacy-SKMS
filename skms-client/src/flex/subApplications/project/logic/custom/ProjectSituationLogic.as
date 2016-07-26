package subApplications.project.logic.custom
{
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;

	import subApplications.project.dto.ProjectSituationDto;
	import subApplications.project.web.custom.ProjectSituation;

	import utils.CommonIcon;
	import utils.LabelUtil;


	/**
	 * ProjectSituationのLogicクラスです.
	 */
	public class ProjectSituationLogic extends Logic
	{
		/** プロジェクト状況リスト */
		private var _situationList:ArrayCollection;

		/** 更新対象のプロジェクト状況リスト */
		private var _updateSituation:ProjectSituationDto;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectSituationLogic()
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
		 * プロジェクト状況 前の状況ボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkPrevious(e:MouseEvent):void
		{
			// 現在の状況Indexを取得する.
			var index:int = Number(view.lblAllCount.text) - Number(view.lblCurrentNo.text);

			// 前の状況を設定する.
			setCurrentSituation(index + 1);

		}

		/**
		 * プロジェクト状況 次の状況ボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkNext(e:MouseEvent):void
		{
			// 現在の状況Indexを取得する.
			var index:int = Number(view.lblAllCount.text) - Number(view.lblCurrentNo.text);

			// 次の状況を設定する.
			setCurrentSituation(index - 1);
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * プロジェクト状況リストの設定.
		 *
		 * @param list 状況リスト.
		 */
		public function set referenceSituations(list:ArrayCollection):void
		{
			_situationList = list;
			setCurrentSituation();
		}

		/**
		 * プロジェクト状況 更新データの設定.
		 *
		 * @param value プロジェクト状況.
		 */
		public function set updateSituation(value:ProjectSituationDto):void
		{
			_updateSituation = value;
			setUpdateSituation();
		}

		/**
		 * プロジェクト状況 新規データの設定.
		 *
		 * @param value プロジェクト状況.
		 */
		public function set newSituation(value:ProjectSituationDto):void
		{
			_updateSituation = value;
			setNewSituation();
		}

		/**
		 * 登録するプロジェクト状況.
		 *
		 * @return プロジェクト状況.
		 */
		public function get entrySituation():ProjectSituationDto
		{
			_updateSituation.situation = view.txtSituation.text;
			return _updateSituation;
		}


		/**
		 * 現在のプロジェクト状況設定.
		 *
		 * @param index プロジェクト状況Index.
		 */
		private function setCurrentSituation(index:int = 0):void
		{
			var situation:ProjectSituationDto = _situationList.getItemAt(index) as ProjectSituationDto;
			view.txtSituation.text = situation.situation;
			view.lblRegistrationTime.text = convertRegistrationTime(situation);
			view.lblRegistrationName.text = convertRegistrationName(situation);
			view.lblCurrentNo.text = String(_situationList.length - index);
			view.lblAllCount.text  = String(_situationList.length);

			// nextアイコンを設定する.
			if (index > 0) {
				view.linkNext.enabled = true;
				view.linkNext.setStyle("icon", CommonIcon.nextIcon);
			}
			else {
				view.linkNext.enabled = false;
				view.linkNext.setStyle("icon", CommonIcon.nextDisabledIcon);
			}

			// previousアイコンを設定する.
			if (index < _situationList.length - 1) {
				view.linkPrevious.enabled = true;
				view.linkPrevious.setStyle("icon", CommonIcon.previousIcon);
			}
			else {
				view.linkPrevious.enabled = false;
				view.linkPrevious.setStyle("icon", CommonIcon.previousDisabledIcon);
			}
		}

		/**
		 * 更新対象のプロジェクト状況設定.
		 *
		 */
		private function setUpdateSituation():void
		{
			view.txtSituation.text = _updateSituation.situation;
			view.lblRegistrationTime.text = convertRegistrationTime(_updateSituation);
			view.lblRegistrationName.text = convertRegistrationName(_updateSituation);
		}

		/**
		 * 新規追加のプロジェクト状況設定.
		 *
		 */
		private function setNewSituation():void
		{
			view.txtSituation.text = _updateSituation.situation;
			view.lblRegistrationName.text = Application.application.indexLogic.loginStaff.staffName.fullName;
		}

		/**
		 * 登録日取得.
		 *
		 * @param situation プロジェクト状況情報.
		 */
		private function convertRegistrationTime(situation:ProjectSituationDto):String
		{
			if (!situation)		return "－";
			var label:String = LabelUtil.date(situation.registrationTime);
			if (label == "")	return "－";
			return label;
		}

		/**
		 * 登録者取得.
		 *
		 * @param situation プロジェクト状況情報.
		 */
		private function convertRegistrationName(situation:ProjectSituationDto):String
		{
			if (!situation)		return "－";
			if (!situation.registrationName)	return "－";
			if (!(StringUtil.trim(situation.registrationName).length > 0))	return "－";
			return situation.registrationName;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectSituation;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectSituation
	    {
	        if (_view == null) {
	            _view = super.document as ProjectSituation;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:ProjectSituation):void
	    {
	        _view = view;
	    }
	}
}