package services.generalAffair.workingConditions.service;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.workingConditions.dto.MStaffDto;
import services.generalAffair.workingConditions.dxo.MStaffDxo;

public class WorkingConditionsService {
	
	public JdbcManager jdbcManager;
	
	public MStaffDxo mStaffDxo;
	
	/**
	 * スタッフ一覧取得
	 * @return スタッフ一覧
	 */
	public List<MStaffDto> getStaffNameList()	{
		//権限関係を付与する際にMStaffがある方が便利なので現状は意味無いが
		//MStaffを主テーブルにする。
		List<MStaff> src = jdbcManager
							.from(MStaff.class)
							.innerJoin("staffName")
							.orderBy("staffId")
							.getResultList();
		List<MStaffDto> result = mStaffDxo.convert(src);
		
		return result;		
	}
	
	/**
	 * 社員集計データ取得
	 * @param 集計月
	 * @return 社員集計データ
	 */
	public List<WorkingHoursMonthly> getStaffWorkingHoursMonthlyList(Date date){
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		
		String whereValue = sdf.format(date);
		
		List<WorkingHoursMonthly> result = jdbcManager
											.from(WorkingHoursMonthly.class)
											.innerJoin("staffName")
											.where(new SimpleWhere().eq("workingMonthCode", whereValue))
											.orderBy("staffId")
											.getResultList();
				
		return result;
	}

}
