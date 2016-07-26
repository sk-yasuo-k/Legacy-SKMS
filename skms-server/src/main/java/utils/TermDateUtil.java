package utils;

import java.util.Calendar;
import java.util.Date;

/**
 * xx期を扱うときに使用する静的なクラスです。
 * 
 * @author yasuo-k
 * 
 */
public class TermDateUtil  {

	/** xx期の定義 */
	static int TERM_BEGINNING_YEAR  = 1984;				// 会社設立.
	static int TERM_BEGINNING_MONTH = 10;				// XX期開始月.

	/**
	 * 指定された日付の期を取得する.
	 *
	 * @param date  日付
	 * @return term xx期
	 */
	public static int getTerm(Date date)
	{
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int term = cal.get(Calendar.YEAR) - TERM_BEGINNING_YEAR;
		if (cal.get(Calendar.MONTH) + 1 >= TERM_BEGINNING_MONTH) {
			term++;
		}
		return term;
	}
}