package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィールプロジェクト情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select p.project_code,p.project_name" +
				",pm.*" +
				" from project_member as pm" +
				" inner join project p" +
				" on pm.project_id = p.project_id" +
				" where (pm.project_id,pm.staff_id) in" +
					"(select max(project_id),staff_id" +
					" from project_member" +
					" where (staff_id,actual_join_date) in" +
						"(select staff_id,max(actual_join_date)" +
						" from project_member" +
						" where actual_retire_date is null" +
						" group by staff_id)" +
					" group by staff_id)" +
				")")
public class ProfileProjectInfo implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * プロジェクトIDです。
	 */
	public int projectId;
	
	/**
	 * プロジェクトコードです。
	 */
	public String projectCode;
	
	/**
	 * プロジェクト名です。
	 */
	public String projectName;
}
