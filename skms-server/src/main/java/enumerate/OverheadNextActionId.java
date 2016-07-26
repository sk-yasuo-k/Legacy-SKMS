package enumerate;

/**
 * 諸経費手続状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class OverheadNextActionId {
	public static final int COPY				=-2;	// 複製.
	public static final int DELETE				=-1;	// 削除.
	public static final int UPDATE				= 1;	// 変更
	public static final int APPLY				= 2;	// 申請.
	public static final int APPLY_CANCEL		= 3;	// 申請取り消し.
	public static final int APPROVAL_PM			= 4;	// PM承認.
	public static final int APPROVAL_CANCEL_PM	= 5;	// PM承認取り消し.
	public static final int APPROVAL_REJECT_PM	= 6;	// PM差し戻し.
	public static final int APPROVAL_GA			= 7;	// 総務承認.
	public static final int APPROVAL_CANCEL_GA	= 8;	// 総務承認取り消し.
	public static final int APPROVAL_REJECT_GA	= 9;	// 総務差し戻し.
	public static final int PAY					=10;	// 支払.
	public static final int PAY_CANCEL			=11;	// 支払取り消し.
	public static final int ACCEPT				=12;	// 受領.
	public static final int ACCEPT_CANCEL		=13;	// 受領取り消し.
}
