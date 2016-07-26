package enumerate;

/**
 * 諸経費手続状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class OverheadStatusId {
	public static final int ENTERED			= 1;	// 作成済.
	public static final int APPLIED			= 2;	// 申請済.
	public static final int APPROVED_PM		= 3;	// PM承認済.
	public static final int APPROVED_GA		= 4;	// 総務承認済.
	public static final int PAID			= 5;	// 支払済.
	public static final int ACCEPTED		= 6;	// 受領済.
	public static final int REJECTED		= 7;	// 差し戻し中
}
