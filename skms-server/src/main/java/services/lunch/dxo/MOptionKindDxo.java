package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.MOptionKindDto;
import services.lunch.entity.MOptionKind;

public interface MOptionKindDxo {

	public MOptionKind convert(MOptionKindDto src);
	
	public MOptionKindDto convert(MOptionKind src);
	
	public List<MOptionKind> convertList(List<MOptionKindDto> src);
	
	public List<MOptionKindDto> convertDtoList(List<MOptionKind> src);
}
