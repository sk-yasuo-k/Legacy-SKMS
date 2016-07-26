package services.personnelAffair.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.entity.MAuthorizedLicence;;

/**
 * 認定資格情報ラベルDxo
 *
 * @author nobuhiro-s
 *
 */
public interface AuthorizedLocenceLabelDxo {
	
	/**
	 * 認定資格マスタエンティティから認定資格情報ラベルDtoへ変換.
	 *
	 * @param src 認定資格マスタエンティティ
	 * @return 認定資格情報ラベルDto
	 */
	@ConversionRule("categoryName : mAuthorizedLicenceCategory.categoryName," +
					"monthlySum : mInformationAllowance.monthlySum")
	public List<StaffAuthorizedLicenceDto> convert(List<MAuthorizedLicence> src); 
}

