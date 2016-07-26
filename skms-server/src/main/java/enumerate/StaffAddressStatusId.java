package enumerate;

/**
 * 社員住所変更手続状況ID定義です.
 *
 * @author yasuo-k
 *
 */
public class StaffAddressStatusId {
	public static final int NONE				= 0;	// 未作成
	public static final int ENTERED			= 1;	// 作成済
	public static final int SUBMITTED			= 2;	// 提出済
	public static final int GA_APPROVED		= 7;	// 総務承認済
	public static final int REJECTED			= -1;	// 差し戻し中	
}
