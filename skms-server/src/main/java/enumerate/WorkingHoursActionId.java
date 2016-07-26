package enumerate;

/**
 * 勤務管理表手続動作ID定義です.
 *
 * @author yasuo-k
 *
 */
public class WorkingHoursActionId {
	public static final int ENTER				= 1;	// 作成
	public static final int SUBMIT				= 2;	// 提出
	public static final int SUBMIT_CANCEL		= 3;	// 提出取り消し
	public static final int TN_APPROVAL			= 4;	// TN承認
	public static final int TN_APPROVAL_CANCEL	= 5;	// TN承認取り消し
	public static final int TN_APPROVAL_REJECT	= 6;	// TN差し戻し
	public static final int SL_APPROVAL			= 7;	// SL承認
	public static final int SL_APPROVAL_CANCEL	= 8;	// SL承認取り消し
	public static final int SL_APPROVAL_REJECT	= 9;	// SL差し戻し
	public static final int PL_APPROVAL			= 10;	// PL承認
	public static final int PL_APPROVAL_CANCEL	= 11;	// PL承認取り消し
	public static final int PL_APPROVAL_REJECT	= 12;	// PL差し戻し
	public static final int PM_APPROVAL			= 13;	// PM承認
	public static final int PM_APPROVAL_CANCEL	= 14;	// PM承認取り消し
	public static final int PM_APPROVAL_REJECT	= 15;	// PM差し戻し
	public static final int GA_APPROVAL			= 16;	// 総務承認
	public static final int GA_APPROVAL_CANCEL	= 17;	// 総務承認取り消し
	public static final int GA_APPROVAL_REJECT	= 18;	// 総務差し戻し
}

