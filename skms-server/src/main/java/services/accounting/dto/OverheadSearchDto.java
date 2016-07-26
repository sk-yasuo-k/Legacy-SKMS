package services.accounting.dto;

import java.io.Serializable;
import java.util.List;

/**
 * 諸経費検索情報です.
 *
 * @author yasuo-k
 *
 */
public class OverheadSearchDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトリストです.
	 */
	public List<Integer> projectList;

	/**
	 * 所属プロジェクトの部下検索フラグです.
	 */
	public boolean subordinateOnly = false;

	/**
	 * 申請状態リストです.
	 */
    public List<Integer> statusList;

}