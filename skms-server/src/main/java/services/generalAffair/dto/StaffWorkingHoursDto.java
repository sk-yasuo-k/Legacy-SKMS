package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;


/**
 * 社員別勤務管理集計情報です.
 *
 * @author yasuo-k
 *
 */
public class StaffWorkingHoursDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです.
	 */
	public int staffId;

	/**
	 * 社員氏名です.
	 */
	public String staffName;

	/**
	 * 就労状況種別IDです.
	 */
	public int workStatusId;

	/**
	 * 月別集計リストです.
	 */
	public List<StaffWorkingHoursMonthlyDto> monthlyList;

}