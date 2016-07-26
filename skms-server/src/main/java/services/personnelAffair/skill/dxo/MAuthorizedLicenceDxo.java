package services.personnelAffair.skill.dxo;

import java.util.List;

import services.personnelAffair.skill.dto.MAuthorizedLicenceDto;
import services.personnelAffair.skill.entity.MAuthorizedLicence;

/**
 * 認定資格マスタDxoです。
 *
 * @author t-ito
 *
 */
public interface MAuthorizedLicenceDxo {

	public MAuthorizedLicence convert(MAuthorizedLicenceDto src);
	
	public MAuthorizedLicenceDto convert(MAuthorizedLicence src);
	
	public List<MAuthorizedLicence> convertList(List<MAuthorizedLicenceDto> src);
	
	public List<MAuthorizedLicenceDto> convertDtoList(List<MAuthorizedLicence> src);
	
}
