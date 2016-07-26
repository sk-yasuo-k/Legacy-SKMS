package services.accounting.dxo;

import java.util.List;

import dto.LabelDto;

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
public interface LabelDxo {

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト
	 * @return List<LabelDto> 交通費申請状況ラベルリスト
	 */
	public List<LabelDto> convertStatus(List<MTransportationStatus> src);

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト
	 * @return List<LabelDto> 交通費申請状況ラベルリスト
	 */
	public List<LabelDto> convertApprovalStatus(List<MTransportationStatus> src);

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト
	 * @return List<LabelDto> 交通費申請状況ラベルリスト
	 */
	public List<LabelDto> convertApprovalStatus_AF(List<MTransportationStatus> src);

	/**
	 * プロジェクト情報エンティティリストからプロジェクト名ラベルリストへ変換.
	 *
	 * @param  src プロジェクト情報エンティティ
	 * @return List<LabelDto> プロジェクト名ラベルリスト
	 */
	public List<LabelDto> convertProject(List<Project> src);


	/**
	 * 交通機関別マスタ情報エンティティから交通機関名ラベルリストへ変換.
	 *
	 * @param src 交通機関別マスタ情報エンティティリスト.
	 * @return 交通機関名ラベルリスト.
	 */
	public List<LabelDto> convertFacility(List<TransportationFacility> src);


	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト.
	 * @return List<LabelDto> 交通費申請状況ラベルリスト.
	 */
	public List<LabelDto> convertTransportationMonthly(List<MTransportationStatus> src);


	/**
	 * 通勤費手続状態エンティティリストから通勤費手続状態ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 通勤費手続状態ラベルリスト.
	 */
	public List<LabelDto> convertCommutationStatus(List<MCommutationStatus> src);


	// ----------------------------------------------------------------
	//      overhead 諸経費
	// ----------------------------------------------------------------
	/**
	 * 諸経費区分エンティティリストから諸経費区分ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費区分ラベルリスト.
	 */
	public List<LabelDto> convertOverhedType(List<MOverheadType> src);


	/**
	 * 設備種別エンティティリストから設備区分ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 設備区分ラベルリスト.
	 */
	public List<LabelDto> convertEquipmentKind(List<MEquipmentKind> src);


	/**
	 * 支払種別エンティティリストから支払種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 設備区分ラベルリスト.
	 */
	public List<LabelDto> convertPayment(List<MPayment> src);

	/**
	 * 勘定科目エンティティリストから勘定項目ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 勘定項目ラベルリスト.
	 */
	public List<LabelDto> convertAccountItem(List<MAccountItem> src);

	/**
	 * PC種別エンティティリストからPC種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> PC種別ラベルリスト.
	 */
	public List<LabelDto> convertPckind(List<MPcKind> src);

	/**
	 * 社員エンティティリストから社員ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 社員ラベルリスト.
	 */
	public List<LabelDto> convertStaff(List<MStaff> src);

	/**
	 * オフィスエンティティリストからオフィスラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> オフィスラベルリスト.
	 */
	public List<LabelDto> convertInstallationLocation(List<MOffice> src);

	/**
	 * クレジットカードエンティティリストからクレジットカードラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> クレジットカードラベルリスト.
	 */
	public List<LabelDto> convertCreditCard(List<MCreditCard> src);

	/**
	 * ジャンルエンティティリストからジャンルラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> ジャンルラベルリスト.
	 */
	public List<LabelDto> convertJanre(List<MJanre> src);



	/**
	 * 諸経費申請状況種別エンティティリストから諸経費申請状況種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費申請状況種別ラベルリスト.
	 */
	public List<LabelDto> convertOverheadRequestStatus(List<MOverheadStatus> src);

	/**
	 * 諸経費申請状況種別エンティティリストから諸経費申請状況種別ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 諸経費申請状況種別ラベルリスト.
	 */
	public List<LabelDto> convertOverheadApprovalStatus(List<MOverheadStatus> src);

	/**
	 * プロジェクトエンティティリストからプロジェクトラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> プロジェクトラベルリスト.
	 */
	public List<LabelDto> convertAllBusiness(List<Project> src);
}
