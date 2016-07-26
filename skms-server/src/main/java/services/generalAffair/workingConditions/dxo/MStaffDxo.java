package services.generalAffair.workingConditions.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.generalAffair.entity.MStaff;
import services.generalAffair.workingConditions.dto.*;

public interface MStaffDxo {
	
	@ConversionRule("'staffFullName' : staffName.fullName")
	public List<MStaffDto> convert(List<MStaff> src);

}
