package services.accounting.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import services.accounting.dto.ProjectTransportationDto;
import services.accounting.dto.ProjectTransportationMonthlyDto;
import services.accounting.dxo.ProjectTransportationDxo;
import services.accounting.entity.ProjectTransportation;


/**
 * プロジェクト別交通費情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class ProjectTransportationDxoImpl implements ProjectTransportationDxo {

	/**
	 * プロジェクト別交通費情報エンティティリストからプロジェクト別交通費情報Dtoリストへ変換.
	 *
	 * @param src プロジェクト別交通費情報エンティティリスト.
	 * @return プロジェクト別交通費情報Dtoリスト.
	 */
	public List<ProjectTransportationDto> convert(List<ProjectTransportation> src)
	{
		List<ProjectTransportationDto> dst = new ArrayList<ProjectTransportationDto>();
		ProjectTransportationDto dto;
		for (ProjectTransportation entity : src) {

			int index = 0;;
			boolean flg = true;
			dto = null;

			// プロジェクトdtoリストに project が存在するかどうか確認する.
			for (index = 0; index < dst.size(); index++) {
				dto = dst.get(index);
				if (entity.projectId != null) {
					if (dto.objectId.equals(entity.projectId)) {
						flg = false;
						break;
					}
				}
				else {
					if (dto.objectId.equals(entity.staffId)) {
						flg = false;
						break;
					}
				}
			}
			// 存在しないときは 新規に作成する.
			if (flg) {
				dto = new ProjectTransportationDto();
				if (entity.projectId != null) {
					dto.objectId   = entity.projectId;
					dto.objectType = entity.projectType;
					dto.objectCode = entity.projectCode;
					dto.objectName = entity.projectName;
				}
				else {
					dto.objectId   = entity.staffId;
					dto.objectType = entity.workStatusId;
					dto.objectCode = entity.fullName;
					dto.objectName = entity.fullName;
				}
				dto.monthyList  = new ArrayList<ProjectTransportationMonthlyDto>();
			}

			// 月別交通費dtoを作成する.
			ProjectTransportationMonthlyDto monthlydto = new ProjectTransportationMonthlyDto();
			monthlydto.objectId  = dto.objectId;
			monthlydto.yyyymm    = entity.yyyymm;
			monthlydto.expense   = entity.expense;
			dto.monthyList.add(monthlydto);

			// プロジェクトdtoリストに追加する.
			if (flg) 	dst.add(dto);
			else		dst.set(index, dto);
		}
		return dst;
	}

}