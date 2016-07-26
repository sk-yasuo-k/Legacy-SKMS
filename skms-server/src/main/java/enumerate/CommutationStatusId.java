package enumerate;

/**
 * 通勤費手続状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class CommutationStatusId {
	public static final int NONE				= 0;	// 未作成
	public static final int ENTERED			= 1;	// 作成済
	public static final int APPLIED			= 2;	// 申請済
	public static final int PM_APPROVED		= 6;	// PM承認済
	public static final int GA_APPROVED		= 7;	// 総務承認済
	public static final int REJECTED			= -1;	// 差し戻し中	
}
