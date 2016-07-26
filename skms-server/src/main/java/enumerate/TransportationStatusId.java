package enumerate;

/**
 * 交通費申請状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class TransportationStatusId {
	public static final int ENTERED		= 1;	// 作成
	public static final int APPLIED		= 2;	// 申請済
	public static final int APPROVED_PL	= 3;	// PL承認済
	public static final int APPROVED_PM	= 4;	// PM承認済
	public static final int APPROVED_AF	= 5;	// 経理承認済
	public static final int PAID		= 6;	// 支払済
	public static final int ACCEPTED	= 7;	// 受領済
	public static final int REJECTED	= 8;	// 差し戻し中
}

