package services.generalAffair.address.dxo;

import java.util.List;
import org.seasar.extension.dxo.annotation.ConversionRule;
import services.generalAffair.address.dto.ChangeAddressApplyDto;
import services.generalAffair.address.entity.MStaffAddress;
import services.generalAffair.address.entity.StaffAddressHistory;


/**
 * 社員住所情報変換Dxo
 * 
 * 
 * @author t-ito
 *
 */

public interface ChangeAddressApplyDxo {
	
	/**
	 *住所変更申請履歴エンティティから社員住所情報Dtoリストへ変換.
	 *
	 * @param src  住所変更申請履歴エンティティ
	 * @return 社員住所情報Dtoリスト
	 */
	@ConversionRule(" addressStatusName : mStaffAddressStatus.staffAddressStatusName" +
			", addressActionName : mStaffAddressAction.staffaddressActionName" +
			", moveDate : mStaffAddress.moveDate" +
			", postalCode1 : mStaffAddress.postalCode1" +
			", postalCode2 : mStaffAddress.postalCode2" +
			", prefectureCode : mStaffAddress.prefectureCode" +
			", prefectureName : mStaffAddress.mPrefecture.name" +
			", ward : mStaffAddress.ward" +
			", wardKana : mStaffAddress.wardKana" +
			", houseNumber : mStaffAddress.houseNumber" +
			", houseNumberKana : mStaffAddress.houseNumberKana" +
			", homePhoneNo1 : mStaffAddress.homePhoneNo1" +
			", homePhoneNo2 : mStaffAddress.homePhoneNo2" +
			", homePhoneNo3 : mStaffAddress.homePhoneNo3" +
			", householderFlag : mStaffAddress.householderFlag" +
			", nameplate : mStaffAddress.nameplate" +
			", associateStaff : mStaffAddress.associateStaff" +
			", registrationTime : mStaffAddress.registrationTime" +
			", registrantId : mStaffAddress.registrantId" +
			", historyRegistrationTime : registrationTime" +
			", historyRegistrantId : registrantId")
	public List<ChangeAddressApplyDto> convert(List<StaffAddressHistory> src); 

	/**
	 * 社員住所情報Dtoから住所変更申請履歴エンティティへ変換.
	 *
	 * @param src 社員住所情報Dto
	 * @return 住所変更申請履歴エンティティ
	 */
	public StaffAddressHistory convertStaffAddressHistory(ChangeAddressApplyDto src); 

	/**
	 * 社員住所情報Dtoから社員住所マスタエンティティへ変換.
	 *
	 * @param src 都道府県マスタエンティティ
	 * @return 社員住所マスタエンティティ
	 */
	@ConversionRule("'prefectureCode' : ((prefectureCode <= 9) ? '0' + prefectureCode.toString() : prefectureCode.toString())")
	public MStaffAddress convertMtaffAddress(ChangeAddressApplyDto src); 
	
}