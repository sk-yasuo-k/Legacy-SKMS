package services.generalAffair.dto;

import java.io.Serializable;
import java.util.Date;


/**
 * 社員別勤務管理集計検索情報です.
 *
 * @author yasuo-k
 *
 */
public class StaffWorkingHoursSearchDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトコードです.
	 */
	public String projectCode;

	/**
	 * プロジェクト名です.
	 */
	public String projectName;

	/**
	 * 社員氏名です.
	 */
	public String staffName;

	/**
	 * 集計期間 開始 です.
	 */
    public Date startDate;

	/**
	 * 集計期間 終了 です.
	 */
    public Date finishtDate;


    /**
     * プロジェクト検索かどうかの確認.
     *
     * @return 確認結果.
     */
    public boolean checkProjectSearch()
    {
    	if (this.projectCode != null || this.projectName != null)	return true;
    	return false;
    }

}