package enumerate;

/**
 * 勤務管理表手続状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class WorkingHoursStatusId {
	public static final int NONE			= 0;	// 未作成
	public static final int ENTERED			= 1;	// 作成済
	public static final int SUBMITTED		= 2;	// 提出済
	public static final int TN_APPROVED		= 3;	// TN承認済
	public static final int SL_APPROVED		= 4;	// SL承認済
	public static final int PL_APPROVED		= 5;	// PL承認済
	public static final int PM_APPROVED		= 6;	// PM承認済
	public static final int GA_APPROVED		= 7;	// 総務承認済
	public static final int REJECTED		= -1;	// 差し戻し中
}

