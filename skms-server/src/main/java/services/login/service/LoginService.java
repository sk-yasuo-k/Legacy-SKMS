package services.login.service;

import org.seasar.extension.jdbc.JdbcManager;

import services.generalAffair.entity.MStaff;
import services.login.entity.LoginSession;

/**
 * プロジェクトを扱うアクションです。
 *
 * @author yasuo-k
 *
 */
public class LoginService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	public MStaff getLoginUserInfo(String sessionId) {
		if (sessionId != null && !sessionId.isEmpty()) {
			LoginSession loginSession = jdbcManager.from(LoginSession.class)
					.where("sessionId = ?", sessionId)
					.getSingleResult();

			// ログインセッションテーブルにレコードがあったならば
			if (loginSession != null) {
				MStaff staff = jdbcManager.from(MStaff.class)
						.where("loginName = ?", loginSession.loginName)
						.innerJoin("staffName")
						.leftOuterJoin("staffDepartment",
							"staffDepartment.updateCount" +
							" = (select Max(update_count)" +
							" from m_staff_department" +
							" where apply_date < NOW()" +
							" and cancel_date is null" +
							" and staff_id = staffName.staffId)")
						.leftOuterJoin("staffDepartmentHead",
							"staffDepartmentHead.updateCount" +
							" = (select Max(update_count)" +
							" from m_staff_department_head" +
							" where apply_date < NOW()" +
							" and cancel_date is null" +
							" and staff_id = staffName.staffId)")
						.leftOuterJoin("staffManagerialPosition",
							"staffManagerialPosition.updateCount" +
							" = (select Max(update_count)" +
							" from m_staff_managerial_position" +
							" where apply_date < NOW()" +
							" and cancel_date is null" +
							" and staff_id = staffName.staffId)")
						.leftOuterJoin("staffProjectPosition",
							"staffProjectPosition.updateCount" +
							" = (select Max(update_count)" +
							" from m_staff_project_position" +
							" where apply_date < NOW()" +
							" and cancel_date is null" +
							" and staff_id = staffName.staffId)")
						.leftOuterJoin("staffSetting")
						.getSingleResult();
	        	// TODO:単体動作時の暫定措置としてレコード削除処理をコメントアウト
				if (sessionId.length() > 3) {
					jdbcManager.delete(loginSession).execute();
				}
				return staff;
			}
		}
		return null;
	}

}