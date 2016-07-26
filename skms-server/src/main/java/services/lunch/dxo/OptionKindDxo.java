package services.lunch.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.lunch.dto.OptionKindDto;
import services.lunch.entity.OptionKind;

public interface OptionKindDxo {

	public OptionKind convert(OptionKindDto src);
	
	public OptionKindDto convert(OptionKind src);
	
	public List<OptionKind> convertList(List<OptionKindDto> src);

	@ConversionRule("optionName : option.optionName")
	public List<OptionKindDto> convertDtoList(List<OptionKind> src);
	
}
