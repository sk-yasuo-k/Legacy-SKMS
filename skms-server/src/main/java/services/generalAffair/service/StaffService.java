package services.generalAffair.service;

import java.util.List;
import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.MStaff;

/**
 * 社員を扱うサービスです。
 *
 * @author yasuo-k
 *
 */
public class StaffService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 社員情報を取得します。
	 *
	 * @param  staffId 
	 * @return 部長一覧
	 */
	public MStaff getStaffInfo(int staffId)
	{
		
		// 社員情報」の取得
		MStaff staff = jdbcManager
			.from(MStaff.class)
			.innerJoin("staffName", new SimpleWhere().eq("staffId", staffId))
			.leftOuterJoin("staffSetting")
			.getSingleResult();
		
		return staff;
	}

	/**
	 * 部長一覧を取得します。
	 *
	 * @param  departmentId 
	 * @return 部長一覧
	 */
	public List<MStaff> getDepartmentHeadList(int departmentId)
	{
		
		// 部長一覧の取得
		List<MStaff> departmentHeadList = jdbcManager
			.from(MStaff.class)
			.innerJoin("staffName")
			.innerJoin("staffDepartmentHead",
					"staffDepartmentHead.departmentId = ?", departmentId)
			.leftOuterJoin("staffSetting")
			.getResultList();
		
		return departmentHeadList;
	}
	
	public List<MStaff> getStaffList()
	{
		List<MStaff> StaffList = jdbcManager
			.from(MStaff.class)
			.getResultList();
		
		return StaffList;
	}
}