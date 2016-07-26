package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import enumerate.ProjectPositionId;
import enumerate.TransportationStatusId;

import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationHistory;
import services.accounting.service.TransportationService;
import services.generalAffair.entity.MStaff;


/**
 * 交通費情報のDTOです。
 *
 */
public class TransportationDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * (entity)交通費申請IDです。
	 */
	public int transportationId;

	/**
	 * (entity)プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * (entity)社員IDです。
	 */
	public int staffId;

	/**
	 * (entity)登録日時です。
	 */
	public Date registrationTime;

	/**
	 * (entity)登録者IDです。
	 */
	public int registrantId;

	/**
	 * (entity)登録バージョンです。
	 */
	public int registrationVer;

	/**
	 * プロジェクト情報です。
	 */
	public ProjectDto project;

	/**
	 * 社員情報です。
	 */
	public MStaff staff;

	/**
	 * 交通費明細情報です。
	 */
	public List<TransportationDetailDto> transportationDetails;

	/**
	 * 交通費申請履歴情報です。
	 */
	public List<HistoryDto> transportationHistorys;

	/**
	 * 合計金額です。
	 */
	public String transportationTotal;

	/**
	 * 交通費申請状況種別名です。
	 */
	public String transportationStatusName;

	/**
	 * 更新・申請可否です。
	 */
	public boolean isEnabledApply = false;

	/**
	 * PL承認可否です。
	 */
	public boolean isEnabledApprovalPL = false;

	/**
	 * PM承認可否です。
	 */
	public boolean isEnabledApprovalPM = false;

	/**
	 * 経理承認可否です。
	 */
	public boolean isEnabledApprovalAF = false;

	/**
	 * 承認取り消し可否です。
	 */
	public boolean isEnabledApprovalCancel = false;

	/**
	 * 支払可否です。
	 */
	public boolean isEnabledPayment = false;

	/**
	 * 受領可否です。
	 */
	public boolean isEnabledAccept = false;

	/**
	 * 受領済みです。
	 */
	public boolean isAccepted = false;


	/**
	 * コンストラクタ
	 */
	public TransportationDto()
	{
		;
	}

	/**
	 * コンストラクタ Transportationを設定
	 */
	public TransportationDto(Transportation trans, MStaff staff)
	{
		// column
		this.transportationId = trans.transportationId;
		this.projectId        = trans.projectId;
		this.staffId          = trans.staffId;
		this.registrantId     = trans.registrantId;
		this.registrationTime = trans.registrationTime;
		this.registrationVer  = trans.registrationVer;
		// table
		this.staff            = trans.staff;
		this.project          = new ProjectDto(trans.projectInfo, staff);
	}


	/**
	 * 交通費申請情報 削除確認。
	 */
	public boolean isDelete() {
		return isUpdate();
	}

	/**
	 * 交通費申請情報 更新確認。
	 */
	public boolean isUpdate() {
		if (this.transportationId > 0)	return true;
		return false;
	}

	/**
	 * 交通費申請情報 新規登録確認。
	 */
	public boolean isNew() {
		if (!isUpdate())		return true;
		return false;
	}

	/**
	 * 申請状況の設定。
	 *
	 * @param transHistory  交通費申請履歴エンティティ
	 * @param type          データタイプ
	 * @param staff         社員情報エンティティ
	 */
	public void setStatus(TransportationHistory transHistory, int type, MStaff staff)
	{
		// 申請状況を設定する。
		this.transportationStatusName = transHistory.transportationStatus.transportationStatusName;

		// 申請データのとき.
		if (type == TransportationService.DATA_REAUEST)
		{
			// 申請状況フラグを設定する。
			switch (transHistory.transportationStatusId)
			{
				// 新規作成・差し戻しのとき
				case TransportationStatusId.ENTERED:
				case TransportationStatusId.REJECTED:
					this.isEnabledApply = true;
					break;

				// 申請済みのとき
				case TransportationStatusId.APPLIED:
					this.isEnabledApprovalPL = true;
					break;

				// PL承認済みのとき
				case TransportationStatusId.APPROVED_PL:
					this.isEnabledApprovalPM = true;
					break;

				// PM承認済みのとき
				case TransportationStatusId.APPROVED_PM:
					this.isEnabledApprovalAF = true;
					break;

				// AF承認済みのとき
				case TransportationStatusId.APPROVED_AF:
					this.isEnabledPayment = true;
					break;

				// 支払済みのとき
				case TransportationStatusId.PAID:
					this.isEnabledAccept = true;
					break;

				// 受領済みのとき
				case TransportationStatusId.ACCEPTED:
					this.isAccepted = true;
					break;
			}
		}
		// 通常承認データのとき.
		else if (type == TransportationService.DATA_APPROVAL)
		{
			// 申請状況フラグを設定する。
			switch (transHistory.transportationStatusId)
			{
				// 新規作成・差し戻しのとき
				case TransportationStatusId.ENTERED:
				case TransportationStatusId.REJECTED:
					this.isEnabledApply = true;
					break;

				// 申請済み・PL承認済み・PM承認済みのとき
				case TransportationStatusId.APPLIED:
				case TransportationStatusId.APPROVED_PL:
				case TransportationStatusId.APPROVED_PM:
					if (this.project == null) 	break;
					// PMのとき
					if (this.project.projectPositionId == ProjectPositionId.PM) {
						this.isEnabledApprovalPM = true;
						if (transHistory.transportationStatusId == TransportationStatusId.APPROVED_PM) {
							// PM承認済みのとき「承認取り消し」を有効にする。
							this.isEnabledApprovalPM = false;
							this.isEnabledApprovalCancel = true;
						}
					}
					// PLのとき
					else if (this.project.projectPositionId == ProjectPositionId.PL) {
						this.isEnabledApprovalPL = true;
						if (transHistory.transportationStatusId == TransportationStatusId.APPROVED_PL) {
							// PL承認済みのとき「承認取り消し」を有効にする。
							this.isEnabledApprovalPL = false;
							this.isEnabledApprovalCancel = true;
						}
					}
					break;

				// AF承認済みのとき
				case TransportationStatusId.APPROVED_AF:
					this.isEnabledPayment = true;
					break;

				// 支払済みのとき
				case TransportationStatusId.PAID:
					// 支払が自操作かどうか確認する.
					if (checkPreMyAction(transHistory, staff)) {
						this.isEnabledAccept = true;
					}
					break;

				// 受領済みのとき
				case TransportationStatusId.ACCEPTED:
					this.isAccepted = true;
					break;
			}

		}
		// 経理承認データのとき.
		else if (type == TransportationService.DATA_APPROVAL_AF)
		{
			// 申請状況フラグを設定する。
			switch (transHistory.transportationStatusId)
			{
				// 新規作成・差し戻しのとき
				case TransportationStatusId.ENTERED:
				case TransportationStatusId.REJECTED:
					this.isEnabledApply = true;
					break;

				// 申請済み・PL承認済み・PM承認済みのとき
				case TransportationStatusId.APPLIED:
				case TransportationStatusId.APPROVED_PL:
				case TransportationStatusId.APPROVED_PM:
					this.isEnabledApprovalAF = true;
					break;

				// AF承認済みのとき
				case TransportationStatusId.APPROVED_AF:
					this.isEnabledPayment = true;
					this.isEnabledApprovalCancel = true;
					break;

				// 支払済みのとき
				case TransportationStatusId.PAID:
					// 支払が自操作かどうか確認する.
					if (checkPreMyAction(transHistory, staff)) {
						this.isEnabledAccept = true;
					}
					break;

				// 受領済みのとき
				case TransportationStatusId.ACCEPTED:
					this.isAccepted = true;
					break;
			}
		}
	}

	/**
	 * 直前操作が自分かどうか確認する。
	 *
	 * @param transHistory  最新の交通費申請履歴エンティティ
	 * @param staff         社員情報エンティティ
	 * @return 確認結果
	 */
	private boolean checkPreMyAction(TransportationHistory transHistory, MStaff staff)
	{
		// 現状態が自操作によるものかどうか確認する.
		String thComment  = transHistory.comment;
		String stsComment = HistoryDto.COMMENT_LIST[transHistory.transportationStatusId];

		// 直前操作を確認する.
		if (thComment.indexOf(stsComment, 0) == 0) {
			if (transHistory.registrantId == staff.staffId) {
				return true;
			}
		}
		else {
			// 操作履歴をさかのぼり、自操作によるものかどうか確認する.
			for (int i = 1; i < this.transportationHistorys.size(); i++) {
				HistoryDto his = this.transportationHistorys.get(i);
				if (transHistory.transportationStatusId == his.transportationStatusId) {
					if (his.registrantId == staff.staffId) {
						return true;
					}
					break;
				}
			}
		}
		return false;
	}

}