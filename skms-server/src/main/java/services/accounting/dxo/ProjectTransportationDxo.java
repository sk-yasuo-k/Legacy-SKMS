package services.accounting.dxo;

import java.util.List;

import services.accounting.dto.ProjectTransportationDto;
import services.accounting.entity.ProjectTransportation;


/**
 * プロジェクト別交通費情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectTransportationDxo {

	/**
	 * プロジェクト別交通費情報エンティティリストからプロジェクト別交通費情報Dtoリストへ変換.
	 *
	 * @param src プロジェクト別交通費情報エンティティリスト.
	 * @return プロジェクト別交通費情報Dtoリスト.
	 */
	public List<ProjectTransportationDto> convert(List<ProjectTransportation> src);

}
