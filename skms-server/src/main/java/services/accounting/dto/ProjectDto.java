package services.accounting.dto;

import java.io.Serializable;

import services.generalAffair.entity.MStaff;
import services.project.entity.Project;
import services.project.entity.ProjectMember;

/**
 * プロジェクト情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectDto implements Serializable {

	static final long serialVersionUID = 1L;

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

	/**
	 * プロジェクト役職IDです。
	 */
	public int projectPositionId;

	/**
	 * プロジェクト役職略名です。
	 */
	public String projectPositionAlias;

	/**
	 * プロジェクト役職名です。
	 */
	public String projectPositionName;

	/**
	 * コンストラクタ
	 */
	public ProjectDto(){
		;
	}

	/**
	 * コンストラクタ
	 */
	public ProjectDto(Project project, MStaff staff){
		this.projectId   = project.projectId;
		this.projectCode = project.projectCode;
		this.projectName = project.projectName;
		if (staff != null && project.projectMembers != null) {
			for (ProjectMember projectMember : project.projectMembers) {
				if (staff.staffId == projectMember.staffId && projectMember.projectPosition != null) {
					this.projectPositionId = projectMember.projectPositionId;
					this.projectPositionAlias = projectMember.projectPosition.projectPositionAlias;
					this.projectPositionName  = projectMember.projectPosition.projectPositionName;
					break;
				}
			}
		}
	}
}