package services.personnelAffair.profile.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.profile.dto.BasicPayDto;
import services.personnelAffair.profile.dto.ProfileDetailDto;
import services.personnelAffair.profile.dto.ProfileDto;
import services.personnelAffair.profile.entity.MBasicPay;
import services.personnelAffair.profile.entity.ProfileDetail;
import services.personnelAffair.profile.entity.ProfileInfo;

/**
 * プロフィール情報変換Dxoです。
 * 
 * @author yoshinori-t
 * 
 */
public interface ProfileInfoDxo {

	/**
	 * プロフィール情報エンティティからプロフィール情報Dtoへ変換.
	 *
	 * @param src プロフィール情報エンティティリスト
	 * @return プロフィール情報Dtoリスト
	 */
	@ConversionRule("'sexName' : ((sex == 1) ? '男' : " +
								"((sex == 2) ? '女' : " +
								"''))" +
					",'bloodGroupName' : ((bloodGroup == 1) ? 'A' : " +
										"((bloodGroup == 2) ? 'B' : " +
										"((bloodGroup == 3) ? 'O' : " +
										"((bloodGroup == 4) ? 'AB' : " +
										//追加 @auther okamoto
										"((bloodGroup == 9) ? '不明' :" +
										"'')))))" +
					",'address1' : ((profileAddressInfo != null) ? " +
									"profileAddressInfo.prefectureName + profileAddressInfo.ward : '')" +
					",'address2' : ((profileAddressInfo != null) ? " +
									"profileAddressInfo.houseNumber : '')" +
					",'academicBackground' : ((profileAcademicBackground != null) ? " +
									"profileAcademicBackground.content : '')" +									
					",'totalExperienceYears' : ((profileJoinInfo != null) ? " +
												"profileJoinInfo.serviceYears + beforeExperienceYears : " +
												"beforeExperienceYears)" +
					",'departmentHead' : ((profileDepartmentHeadInfo != null) ? " +
												"((profileDepartmentHeadInfo.departmentId == 1) ? '技術開発部長' : " +
												"((profileDepartmentHeadInfo.departmentId == 2) ? '総務部長' : " +
												"'')) : '')" +
				    ",'projectPosition' : ((profileProjecyPositionInfo != null) ? " +
												"profileProjecyPositionInfo.projectPositionAlias : '')" +
				    ",'managerialPosition' : ((profileManagerialPositionInfo != null) ? " +
												"profileManagerialPositionInfo.managerialPositionAlias : '')" +												
					",'basicClassName' : ((profileQualificationInfo != null) ? " +
										"((profileQualificationInfo.basicClassNo == 1) ? 'Ⅰ' : " +
										"((profileQualificationInfo.basicClassNo == 2) ? 'Ⅱ' : " +
										"((profileQualificationInfo.basicClassNo == 3) ? 'Ⅲ' : " +
										"((profileQualificationInfo.basicClassNo == 4) ? 'Ⅳ' : " +
										"'')))) : '')")
	public List<ProfileDto> convert(List<ProfileInfo> src);

	/**
	 * プロフィール情報エンティティからプロフィール情報Dtoへ変換.
	 *
	 * @param src プロフィール情報エンティティ
	 * @return プロフィール情報Dto
	 */
	@ConversionRule("'sexName' : ((sex == 1) ? '男' : " +
								"((sex == 2) ? '女' : " +
								"''))" +
					",'bloodGroupName' : ((bloodGroup == 1) ? 'A' : " +
										"((bloodGroup == 2) ? 'B' : " +
										"((bloodGroup == 3) ? 'O' : " +
										"((bloodGroup == 4) ? 'AB' : " +
										//追加 @auther okamoto
										"((bloodGroup == 9) ? '不明' :" +
										"'')))))" )	
	public ProfileDto convertData(ProfileInfo src);
	
	/**
	 * プロフィール詳細エンティティからプロフィール詳細Dtoへ変換.
	 *
	 * @param src プロフィール詳細エンティティ
	 * @return プロフィール詳細Dto
	 */	
	public ProfileDetailDto convertProfileDetail(ProfileDetail src);

	
	/**
	 * 基本給エンティティから基本給マスタDtoへ変換.
	 *
	 * @param src 基本給エンティティ
	 * @return 基本給マスタDto
	 */	
	public List<BasicPayDto> convertBasicPayDto(List<MBasicPay> src);	
}
