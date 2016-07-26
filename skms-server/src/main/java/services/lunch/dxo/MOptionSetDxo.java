package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.MOptionSetDto;
import services.lunch.entity.MOptionSet;

public interface MOptionSetDxo {

	
	public MOptionSet convert(MOptionSetDto src);
	
	public MOptionSetDto convert(MOptionSet src);
	
	public List<MOptionSet> convertList(List<MOptionSetDto> src);
	
	public List<MOptionSetDto> convrtDtoList(List<MOptionSet> src);
}
