package services.generalAffair.service;

import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import enumerate.ProjectTypeId;

import services.project.entity.Project;

/**
 * 全社的業務を扱うサービスです。
 *
 * @author yasuo-k
 *
 */
public class WholeBusinessService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 全社的業務のリストを返します.
	 *
	 * @return 全社的業務のリスト.
	 */
	public List<Project> getWholeBusinessList() {
		List<Project> wholeBusinessList =
			jdbcManager.from(Project.class)
				.where(new SimpleWhere()
				.eq("projectType", ProjectTypeId.WHOLE_BUSINESS))
				.orderBy("projectCode")
				.getResultList();

		return wholeBusinessList;
	}
}