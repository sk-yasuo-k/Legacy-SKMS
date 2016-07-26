package services.accounting.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import dto.LabelDto;

import enumerate.OverheadStatusId;
import enumerate.PaymentId;
import enumerate.TransportationStatusId;

import services.accounting.dxo.LabelDxo;
import services.accounting.entity.MAccountItem;
import services.accounting.entity.MCreditCard;
import services.accounting.entity.MEquipmentKind;
import services.accounting.entity.MJanre;
import services.accounting.entity.MOffice;
import services.accounting.entity.MOverheadStatus;
import services.accounting.entity.MOverheadType;
import services.accounting.entity.MPayment;
import services.accounting.entity.MPcKind;
import services.accounting.entity.TransportationFacility;
import services.accounting.entity.MTransportationStatus;
import services.accounting.entity.MCommutationStatus;
import services.generalAffair.entity.MStaff;
import services.project.entity.Project;


/**
 * ラベルDxoです。
 *
 * @author yasuo-k
 *
 */
public class LabelDxoImpl implements LabelDxo {

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト	 * @return List<LabelDto> 交通費申請状況ラベルリスト	 */
	public List<LabelDto> convertStatus(List<MTransportationStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MTransportationStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.transportationStatusId;
			dto.label = status.transportationStatusName;
			// 初期設定：選択 受領済み以外.
			if (status.transportationStatusId != TransportationStatusId.ACCEPTED) {
				dto.selected = true;
			}
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト	 * @return List<LabelDto> 交通費申請状況ラベルリスト	 */
	public List<LabelDto> convertApprovalStatus(List<MTransportationStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MTransportationStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.transportationStatusId;
			dto.label = status.transportationStatusName;
			// 選択状態にする。申請済み・PL承認済み・PM承認済み・AF承認済み
			if (status.transportationStatusId == TransportationStatusId.APPROVED_PL ||
				status.transportationStatusId == TransportationStatusId.APPROVED_PM ||
				status.transportationStatusId == TransportationStatusId.APPROVED_AF ||
				status.transportationStatusId == TransportationStatusId.APPLIED) {
				dto.selected = true;
			}
			// 未選択・有効状態にする。支払済み・受領済み
			else if (status.transportationStatusId == TransportationStatusId.PAID   ||
					 status.transportationStatusId == TransportationStatusId.ACCEPTED) {
				dto.selected = false;
			}
			// 無効状態にする。上記以外
			else {
				dto.enabled = false;
			}
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト	 * @return List<LabelDto> 交通費申請状況ラベルリスト	 */
	public List<LabelDto> convertApprovalStatus_AF(List<MTransportationStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MTransportationStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.transportationStatusId;
			dto.label = status.transportationStatusName;
			// 選択状態にする。申請済み・PL承認済み・PM承認済み・AF承認済み
			if (status.transportationStatusId == TransportationStatusId.APPROVED_PL ||
				status.transportationStatusId == TransportationStatusId.APPROVED_PM ||
				status.transportationStatusId == TransportationStatusId.APPROVED_AF ||
				status.transportationStatusId == TransportationStatusId.APPLIED) {
				dto.selected = true;
			}
			// 未選択・有効状態にする。支払済み・受領済み
			else if (status.transportationStatusId == TransportationStatusId.PAID   ||
					 status.transportationStatusId == TransportationStatusId.ACCEPTED) {
				;
			}
			// 無効状態にする。上記以外
			else {
				dto.enabled = false;
			}
			dst.add(dto);
		}
		return dst;
	}


	/**
	 * プロジェクト情報エンティティリストからプロジェクト名ラベルリストへ変換.
	 *
	 * @param  src プロジェクト情報エンティティ
	 * @return List<LabelDto> プロジェクト名ラベルリスト	 */
	public List<LabelDto> convertProject(List<Project> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (Project project : src) {
			LabelDto dto = new LabelDto();
			dto.data  = project.projectId;
			dto.label = project.projectCode + " " + project.projectName;
			dst.add(dto);
		}
		return dst;
	}


	/**
	 * 交通機関別マスタ情報エンティティから交通機関名ラベルリストへ変換.
	 *
	 * @param src 交通機関別マスタ情報エンティティリスト.
	 * @return 交通機関名ラベルリスト.
	 */
	public List<LabelDto> convertFacility(List<TransportationFacility> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (TransportationFacility facility : src) {
			LabelDto dto = new LabelDto();
			dto.data  = facility.facilityId;
			dto.label = facility.facilityName;
			dst.add(dto);
		}
		return dst;
	}


	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト.
	 * @return List<LabelDto> 交通費申請状況ラベルリスト.
	 */
	public List<LabelDto> convertTransportationMonthly(List<MTransportationStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MTransportationStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.transportationStatusId;
			dto.label = status.transportationStatusName;
			// 選択・選択状態にする。支払済み・受領済み.
			if (status.transportationStatusId == TransportationStatusId.PAID   ||
				status.transportationStatusId == TransportationStatusId.ACCEPTED) {
				dto.selected = true;
			}
			dst.add(dto);
		}
		return dst;
	}


	/**
	 * 通勤費申請状況エンティティリストから通勤費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 通勤費申請状況エンティティリスト
	 * @return List<LabelDto> 通勤費申請状況ラベルリスト
	 */
	public List<LabelDto> convertCommutationStatus(List<MCommutationStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MCommutationStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.commutationStatusId;
			dto.label = status.commutationStatusName;
			dto.selected = true;
			dst.add(dto);
		}
		return dst;
	}


	// ----------------------------------------------------------------
	//      overhead 諸経費
	// ----------------------------------------------------------------
	/**
	 * 諸経費区分エンティティリストから諸経費区分ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費区分ラベルリスト.
	 */
	public List<LabelDto> convertOverhedType(List<MOverheadType> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MOverheadType type : src) {
			LabelDto dto = new LabelDto();
			dto.data  = type.overheadTypeId;
			dto.label = type.overheadTypeName;
			dst.add(dto);
		}
		return dst;
	}


	/**
	 * 設備種別エンティティリストから設備区分ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 設備区分ラベルリスト

	 */
	public List<LabelDto> convertEquipmentKind(List<MEquipmentKind> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MEquipmentKind equip : src) {
			LabelDto dto = new LabelDto();
			dto.data  = equip.equipmentKindId;
			dto.label = equip.equipmentKindName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 支払種別エンティティリストから支払種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 設備区分ラベルリスト.
	 */
	public List<LabelDto> convertPayment(List<MPayment> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MPayment payment : src) {
			LabelDto dto = new LabelDto();
			dto.data  = payment.paymentId;
			dto.label = payment.paymentName;
			dto.toolTip = payment.note;
			if (PaymentId.CASH == payment.paymentId)
				dto.selected = true;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 勘定科目エンティティリストから勘定項目ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 勘定項目ラベルリスト.
	 */
	public List<LabelDto> convertAccountItem(List<MAccountItem> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MAccountItem accountt : src) {
			LabelDto dto = new LabelDto();
			dto.data  = accountt.accountItemId;
			dto.label = accountt.accountItemName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * PC種別エンティティリストからPC種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> PC種別ラベルリスト.
	 */
	public List<LabelDto> convertPckind(List<MPcKind> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MPcKind pc : src) {
			LabelDto dto = new LabelDto();
			dto.data  = pc.pcKindId;
			dto.label = pc.pcKindName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 社員エンティティリストから社員ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 社員ラベルリスト.
	 */
	public List<LabelDto> convertStaff(List<MStaff> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MStaff staff : src) {
			LabelDto dto = new LabelDto();
			dto.data  = staff.staffId;
			dto.label = staff.staffName.fullName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * オフィスエンティティリストからオフィスラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> オフィスラベルリスト.
	 */
	public List<LabelDto> convertInstallationLocation(List<MOffice> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MOffice office : src) {
			LabelDto dto = new LabelDto();
			dto.data  = office.officeId;
			dto.label = office.officeName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * クレジットカードエンティティリストからクレジットカードラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> クレジットカードラベルリスト.
	 */
	public List<LabelDto> convertCreditCard(List<MCreditCard> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MCreditCard card : src) {
			LabelDto dto = new LabelDto();
			dto.data2  = card.creditCardNo;
			dto.label = card.creditCardName;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * ジャンルエンティティリストからジャンルラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> ジャンルラベルリスト.
	 */
	public List<LabelDto> convertJanre(List<MJanre> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MJanre obj : src) {
			LabelDto dto = new LabelDto();
			dto.data  = obj.janreId;
			dto.label = obj.janreName;
			dst.add(dto);
		}
		return dst;
	}



	/**
	 * 諸経費申請状況種別エンティティリストから諸経費申請状況種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費申請状況種別ラベルリスト.
	 */
	public List<LabelDto> convertOverheadRequestStatus(List<MOverheadStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MOverheadStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.overheadStatusId;
			dto.label = status.overheadStatusName;
			// 初期設定：選択 受領済み以外.
			if (status.overheadStatusId != OverheadStatusId.ACCEPTED) {
				dto.selected = true;
			}
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 諸経費申請状況種別エンティティリストから諸経費申請状況種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費申請状況種別ラベルリスト.
	 */
	public List<LabelDto> convertOverheadApprovalStatus(List<MOverheadStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MOverheadStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.overheadStatusId;
			dto.label = status.overheadStatusName;
			// 選択状態にする。申請済み・PM承認済み・AF承認済み.
			if (status.overheadStatusId == OverheadStatusId.APPROVED_PM ||
				status.overheadStatusId == OverheadStatusId.APPROVED_GA ||
				status.overheadStatusId == OverheadStatusId.APPLIED) {
				dto.selected = true;
			}
			// 未選択・有効状態にする。支払済み・受領済み.
			else if (status.overheadStatusId == OverheadStatusId.PAID   ||
					 status.overheadStatusId == OverheadStatusId.ACCEPTED) {
				dto.selected = false;
			}
			// 無効状態にする。上記以外/.
			else {
				dto.enabled = false;
			}
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * プロジェクトエンティティリストからプロジェクトラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> プロジェクトラベルリスト.
	 */
	public List<LabelDto> convertAllBusiness(List<Project> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (Project project : src) {
			LabelDto dto = new LabelDto();
			dto.data  = project.projectId;
			dto.label = project.projectCode + "　" + project.projectName;
			dst.add(dto);
		}
		return dst;
	}
}
