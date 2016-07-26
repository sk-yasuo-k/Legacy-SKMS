package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.MenuOrderOptionDto;
import services.lunch.entity.MenuOrderOption;

public interface MenuOrderOptionDxo {

	public MenuOrderOption convert(MenuOrderOptionDto src);
	
	public MenuOrderOptionDto convert(MenuOrderOption src);
	
	public List<MenuOrderOption> convertList(List<MenuOrderOptionDto> src);
	
	public List<MenuOrderOptionDto> convertDtoList(List<MenuOrderOption> src);
}
