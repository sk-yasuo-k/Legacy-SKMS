package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.OptionSetDto;
import services.lunch.entity.OptionSet;

public interface OptionSetDxo {

	public OptionSet convert(OptionSetDto src);
	
	public OptionSetDto convert(OptionSet src);
	
	public List<OptionSet> convetList(List<OptionSetDto> src);
	
	public List<OptionSetDto> convertDtoList(List<OptionSet> src);
}
