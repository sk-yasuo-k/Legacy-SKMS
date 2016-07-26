package services.personnelAffair.skill.dxo;

import java.util.List;

import services.personnelAffair.skill.dto.MAuthorizedLicenceCategoryDto;
import services.personnelAffair.skill.entity.MAuthorizedLicenceCategory;

/**
 * 認定資格カテゴリーマスタDxoです。
 *
 * @author t-ito
 *
 */
public interface MAuthorizedLicenceCategoryDxo {

	public MAuthorizedLicenceCategory convert(MAuthorizedLicenceCategoryDto src);
	
	public MAuthorizedLicenceCategoryDto convert(MAuthorizedLicenceCategory src);
	
	public List<MAuthorizedLicenceCategory> convertList(List<MAuthorizedLicenceCategoryDto> src);
	
	public List<MAuthorizedLicenceCategoryDto> convertDtoList(List<MAuthorizedLicenceCategory> src);	
	
}
