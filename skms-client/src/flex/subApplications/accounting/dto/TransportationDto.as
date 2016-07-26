package subApplications.accounting.dto
{
	import dto.StaffDto;

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.logic.AccountingLogic;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.TransportationDto")]
	public class TransportationDto
	{
		public function TransportationDto()
		{
			;
		}

		/** 交通費申請ID */
		public var transportationId:int;

		/** プロジェクトID */
		public var projectId:int;

		/** 社員ID */
		public var staffId:int;

		/** 登録日時 */
		public var registrationTime:Date;

		/** 登録者ID */
		public var registrantId:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/** プロジェクト情報 */
		public var project:ProjectDto;

		/** 社員情報 */
		public var staff:StaffDto;

		/** 交通費申請明細リスト */
		public var transportationDetails:ArrayCollection

		/** 交通費申請履歴情報 */
		public var transportationHistorys:ArrayCollection;

		/** 合計金額 */
		public var transportationTotal:String;

		/** 交通費申請状況種別名 */
		public var transportationStatusName:String;

		/** 申請可否（内部処理で使用） */
		public var isEnabledApply:Boolean = false;

		/** PL承認可否（内部処理で使用） */
		public var isEnabledApprovalPL:Boolean = false;

		/** PM承認可否（内部処理で使用） */
		public var isEnabledApprovalPM:Boolean = false;

		/** 経理承認可否（内部処理で使用） */
		public var isEnabledApprovalAF:Boolean = false;

		/** 承認取り消し可否（内部処理で使用） */
		public var isEnabledApprovalCancel:Boolean = false;

		/** 支払可否（内部処理で使用） */
		public var isEnabledPayment:Boolean = false;

		/** 受領可否（内部処理で使用） */
		public var isEnabledAccept:Boolean = false;

		/** 受領済み（内部処理で使用） */
		public var isAccepted:Boolean = false;


		/**
		 * 交通費情報をコピーする.
		 *
		 * @return コピーした交通費情報.
		 */
		 public function copyTransportation():TransportationDto
		 {
		 	var transDto:TransportationDto = new TransportationDto();
		 	transDto.projectId = this.projectId;
		 	// TransportationDto.transportationDetailsのコピーを行なう.
		 	transDto.transportationDetails = new ArrayCollection()

			// 交通費明細情報をコピーする.
		 	if (!this.transportationDetails)	return transDto;
		 	for (var i:int = 0; i < this.transportationDetails.length; i++) {
				var transDetailDto:TransportationDetailDto = this.transportationDetails.getItemAt(i).copyTransportation();
				transDto.transportationDetails.addItem(transDetailDto);
		 	}
		 	return transDto;
		 }

		/**
		 * 登録用データを作成する.
		 *
		 * @param  entryList 交通費明細リスト.

		 * @return 登録用の交通費情報.
		 */
		public function entryTransportation(entryList:ArrayCollection, projectObj:Object = null):TransportationDto
		{
			// プロジェクトIDを設定する.
			if (projectObj)		this.projectId = projectObj.data;

			// 自オブジェクトをコピーする.
			var dst:TransportationDto = ObjectUtil.copy(this) as TransportationDto;

			// 交通費明細リストに入力データを設定する.
			dst.transportationDetails = new ArrayCollection();
			for each (var entryData:TransportationDetailDto in entryList) {
				// 未入力は登録対象外とする.
				if (!entryData || !entryData.checkEntry())	continue;
				entryData.convertEntry();
				dst.transportationDetails.addItem(entryData);
			}
			return dst;
		}

		/**
		 * 削除データを追加する.
		 *
		 * @param deleteList 交通費明細リスト.
		 */
		 public function addDeleteTransportationDetail(deleteList:ArrayCollection):void
		 {
		 	if (this.transportationDetails) {
		 		for each (var deleteData:TransportationDetailDto in deleteList) {
		 			// 削除データとしてリストに追加する.
		 			deleteData.setDelete();
					deleteData.convertEntry();
		 			this.transportationDetails.addItem(deleteData);
		 		}
		 	}
		 }

		/**
		 * 交通費の一致確認.
		 *
		 * @param true/false 一致/不一致.
		 */
		public static function compare(comp1:TransportationDto, comp2:TransportationDto):Boolean
		{
			if (ObjectUtil.compare(comp1.transportationId, comp2.transportationId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 交通費更新可能かどうかを確認する.
		 *
		 * @return msg エラーメッセージ.
		 */
		public function updateTransportation(mode:String):String
		{
			// 申請状況が取得できないとき.
			if (!(this.transportationHistorys && this.transportationHistorys.length > 0)) 	{
				return "担当者に連絡してください。";
			}

			// 受領済みは 更新不可.
			if (this.isAccepted && ObjectUtil.compare(mode, AccountingLogic.ACTION_ACCEPT_CANCEL) != 0) {
				return "受領済みのためデータ変更できません。";
			}

			// 各処理に応じた更新確認を行なう.
			var msg:String = "担当者に連絡してください。";
			var sufmsg:String = "";
			// モードによる更新可否を確認する.
			switch (mode) {
				// 承認・承認取り下げのとき.
				case AccountingLogic.ACTION_APPROVAL:
				case AccountingLogic.ACTION_APPROVAL_WITHDRAW:
					// 承認可能なとき.
					if (this.isEnabledApprovalPL ||
						this.isEnabledApprovalPM ||
						this.isEnabledApprovalAF ) {
						return null;
					}
					// 支払可能なとき.
					else if (this.isEnabledPayment) {
						// 承認取り下げのときだけ別メッセージを表示する.
						if (ObjectUtil.compare(mode, AccountingLogic.ACTION_APPROVAL_WITHDRAW) == 0) {
							return "承認取り消しのあと、承認取り下げを行なってください。";
						}
						else {
							return "承認済みです。";
						}
					}
					// 受領可能なとき.
					else if (this.isEnabledAccept) {
						return "支払処理済みです。";
					}
					// 承認取り消し可能なとき.
					else if (this.isEnabledApprovalCancel){
						// 承認取り下げのときだけ別メッセージを表示する.
						if (ObjectUtil.compare(mode, AccountingLogic.ACTION_APPROVAL_WITHDRAW) == 0) {
							return "承認取り消しのあと、承認取り下げを行なってください。";
						}
						else {
							return "承認済みです。";
						}
					}
					break;

				// 承認取り消しのとき.
				case AccountingLogic.ACTION_APPROVAL_CANCEL:
					// 承認取り消し可能なとき.
					if (this.isEnabledApprovalCancel){
						return null
					}
					// 承認可能なとき.
					else if (this.isEnabledApprovalPL ||
						this.isEnabledApprovalPM ||
						this.isEnabledApprovalAF ) {
						return "未承認です。";
					}
					// 支払可能なとき.
					else if (this.isEnabledPayment) {
						return "承認取り消しできません。"
					}
					// 受領可能なとき.
					else if (this.isEnabledAccept) {
						return "支払処理済みです。";
					}
					break;

				// 支払のとき.
				case AccountingLogic.ACTION_PAYMENT:
					// 承認可能なとき.
					if (this.isEnabledApprovalPL ||
						this.isEnabledApprovalPM ||
						this.isEnabledApprovalAF ) {
						return "未承認です。";
					}
					// 支払可能なとき.
					else if (this.isEnabledPayment) {
						return null;
					}
					// 受領可能なとき.
					else if (this.isEnabledAccept) {
						return "支払処理済みです。";
					}
					// 承認取り消し可能なとき.
					else if (this.isEnabledApprovalCancel){
						return "未承認です。";
					}
					break;

				// 支払取り消しのとき.
				case AccountingLogic.ACTION_PAYMENT_CANCEL:
					// 承認可能なとき.
					if (this.isEnabledApprovalPL ||
						this.isEnabledApprovalPM ||
						this.isEnabledApprovalAF ) {
						return "未支払のため支払取り消しできません。";
					}
					// 支払可能なとき.
					else if (this.isEnabledPayment) {
						return "未支払のため支払取り消しできません。";
					}
					// 受領可能なとき.
					else if (this.isEnabledAccept) {
						return null;
					}
					// 承認取り消し可能なとき.
					else if (this.isEnabledApprovalCancel){
						return "未支払のため支払取り消しできません。";
					}
					break;


				// 新規作成のとき.
				case AccountingLogic.ACTION_NEW:
					return null;
					break;

				// 更新・申請のとき.
				case AccountingLogic.ACTION_UPDATE:
				case AccountingLogic.ACTION_APPLY:
					// 申請可能なとき
					if (this.isEnabledApply) {
						if (ObjectUtil.compare(mode, AccountingLogic.ACTION_APPLY) == 0 &&
							!(this.transportationDetails && this.transportationDetails.length > 0) ) {
								return "明細が未登録のため申請できません。";
						}
						return null;
					}
					else {
						return "申請済みです。";
					}
					break;

				// 申請取り下げのとき.
				case AccountingLogic.ACTION_APPLY_WITHDRAW:
					// PL承認可能なとき.
					if (this.isEnabledApprovalPL) {
						return null;
					}
					// 申請可能なとき
					else if (this.isEnabledApply) {
						return "未申請のため申請取り下げできません。";
					}
					else {
						return "承認・経理担当者に取り下げ依頼のあと\n申請取り下げを行なってください。";
					}
					break;

				// 受領とき.
				case AccountingLogic.ACTION_ACCEPT:
					// 受領可能なとき.
					if (this.isEnabledAccept) {
						return null;
					}
					else {
						return "未支払のため受領できません。";
					}
					break;

				// 受領取り消しとき.
				case AccountingLogic.ACTION_ACCEPT_CANCEL:
					// 受領済みのとき.
					if (this.isAccepted) {
						return null;
					}
					else {
						return "未受領のため受領取り消しできません。";
					}
					break;

			}
			// エラーのとき.
			return msg + "(" + mode + ")";
		}

		/**
		 * 交通費情報が削除可能かどうか確認する.
		 */
		public function isEnabledDelete():Boolean
		{
			// 申請状況が取得できないとき.
			if (!(this.transportationHistorys && this.transportationHistorys.length > 0)) 	{
				return false;
			}

			// 申請状況を確認する.
			if (this.isEnabledApply)	return true;

			// 削除可否を返す.
			return false;
		}

		/**
		 * 交通費情報がコピー可能かどうか確認する.
		 */
		public function isEnabledCopy():Boolean
		{
			return true;
		}

		/**
		 * 交通費情報が変更可能かどうか確認する.
		 */
		 public function isEnabledUpdate():Boolean
		 {
			var msg:String = updateTransportation(AccountingLogic.ACTION_UPDATE);
			if (msg) 	return false;
			else		return true;
		 }
	}
}