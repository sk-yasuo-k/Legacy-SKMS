package enumerate;

/**
 * 勘定科目ID定義です.
 *
 * @author yasuo-k
 *
 */
public class AccountItemId {
	public static final int ENTERTAINMENT   		= 1;		// 交際費
	public static final int MEETING  				= 2;		// 会議費
	public static final int DUES					= 3;		// 議会費
	public static final int TRAINING				= 4; 		// 教育費
	public static final int SRATIONNARY				= 5;		// 事務用品費
	public static final int ADVERTISING				= 6;		// 広告宣伝費
	public static final int SUPPLIES				= 7;		// 消耗品費
	public static final int MISCELLANEOUS			= 8;		// 雑費
	public static final int BOOKS_AND_SUBSCRIPTION	= 9;		// 新聞図書費
	public static final int Equipment_AND_FIXTURES	=10;		// 工具・器具・備品
	public static final int SOFTWARE				=11;		// ソフトウェア


	public static boolean exist(int itemId)
	{
		if (1 <= itemId  && itemId <= 11)
			return true;
		else
			return false;
	}
}

