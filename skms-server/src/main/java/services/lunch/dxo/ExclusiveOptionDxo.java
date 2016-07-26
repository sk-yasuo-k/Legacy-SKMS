package services.lunch.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.lunch.dto.ExclusiveOptionDto;
import services.lunch.entity.ExclusiveOption;

public interface ExclusiveOptionDxo {

	public ExclusiveOption convert(ExclusiveOptionDto src);
	
	public ExclusiveOptionDto convert(ExclusiveOption src);
	
	public List<ExclusiveOption> convertList(List<ExclusiveOptionDto> src);
	
	@ConversionRule("mOptionKindName : exclusiceMOptionKind.optionKindName")
	public List<ExclusiveOptionDto> convertDtoList(List<ExclusiveOption> src);
}
