package services.lunch.dxo;

import java.util.List;

import services.generalAffair.entity.VCurrentStaffName;
import services.lunch.dto.VCurrentStaffNameDto;

public interface VCurrentStaffNameDxo {
	
	public VCurrentStaffNameDto convert(VCurrentStaffName src);

	public List<VCurrentStaffNameDto> convertList(List<VCurrentStaffName> src);
}
