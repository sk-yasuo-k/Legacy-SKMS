package enumerate;

/**
 * 通勤費手続動作ID定義です.
 *
 * @author yasuo-k
 *
 */

public class CommutationActionId {
	public static final int ENTER					= 1;	// 作成
	public static final int APPLY					= 2;	// 申請
	public static final int APPLY_CANCEL			= 3;	// 申請取り消し
	public static final int PM_APPROVAL			= 13;	// PM承認
	public static final int PM_APPROVAL_CANCEL	= 14;	// PM承認取り消し
	public static final int PM_APPROVAL_REJECT	= 15;	// PM差し戻し
	public static final int GA_APPROVAL			= 16;	// 総務承認
	public static final int GA_APPROVAL_CANCEL	= 17;	// 総務承認取り消し
	public static final int GA_APPROVAL_REJECT	= 18;	// 総務差し戻し
}
