package services.project.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * プロジェクト検索情報です.
 *
 * @author yasuo-k
 *
 */
public class ProjectSearchDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです.
	 */
	public int staffId;

	/**
	 * プロジェクトIDリストです.
	 */
	public List<Integer> projectIdItems;

	/**
	 * プロジェクトコードです.
	 */
	public String projectCode;

	/**
	 * プロジェクト名です.
	 */
	public String projectName;

	/**
	 * プロジェクトマネージャ 社員IDです.
	 */
	public int pmStaffId;

	/**
	 * プロジェクトメンバー名です.
	 */
	public String projectMemberName;

	/**
	 * 開始実績日 from です.
	 */
	public Date actualStartDateFrom;

	/**
	 * 開始実績日 to です.
	 */
	public Date actualStartDateTo;

	/**
	 * 開始実績日 未設定です.
	 */
	public boolean actualStartDateNone;

	/**
	 * 終了実績日 from です.
	 */
	public Date actualFinishDateFrom;

	/**
	 * 終了実績日 to です.
	 */
	public Date actualFinishDateTo;

	/**
	 * 終了実績日 未設定です.
	 */
	public boolean actualFinishDateNone;

}