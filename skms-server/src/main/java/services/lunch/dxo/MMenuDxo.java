package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.MMenuDto;
import services.lunch.entity.MMenu;

public interface MMenuDxo {

	public MMenu convert(MMenuDto src);
	
	public MMenuDto convert(MMenu src);
	
	public List<MMenu> convertList(List<MMenuDto> src);
	
	public List<MMenuDto> convertDtoList(List<MMenu> src);
}
