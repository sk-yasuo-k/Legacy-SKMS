package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.OptionDto;
import services.lunch.entity.Option;

public interface OptionDxo {

	public Option convert(OptionDto src);
	
	public OptionDto convert(Option src);
	
	public List<Option> convertList(List<OptionDto> src);
	
	public List<OptionDto> convertDtoList(List<Option> src);
}
