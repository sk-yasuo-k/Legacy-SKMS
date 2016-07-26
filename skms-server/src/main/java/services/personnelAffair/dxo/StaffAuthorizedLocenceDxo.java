package services.personnelAffair.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.entity.MStaffAuthorizedLicence;;

/**
 * 社員所持認定資格情報Dxo
 *
 * @author nobuhiro-s
 *
 */
public interface StaffAuthorizedLocenceDxo {
	
	/**
	 * 社員情報マスタエンティティから社員所持認定資格情報Dtoへ変換.
	 *
	 * @param src 社員所持認定資格情報マスタエンティティ
	 * @return 社員所持認定資格情報Dto
	 */
	@ConversionRule("categoryId : mAuthorizedLicence.mAuthorizedLicenceCategory.categoryId" +
			", categoryName : mAuthorizedLicence.mAuthorizedLicenceCategory.categoryName" +
			", licenceName : mAuthorizedLicence.licenceName")
	public List<StaffAuthorizedLicenceDto> convert(List<MStaffAuthorizedLicence> src);
	
	/**
	 * 社員所持認定資格情報Dtoから社員情報マスタエンティティへ変換.
	 *
	 * @param src 社員所持認定資格情報Dto 
	 * @return 社員所持認定資格情報マスタエンティティ
	 */
	public MStaffAuthorizedLicence convertCreate(StaffAuthorizedLicenceDto src);	
	
}

