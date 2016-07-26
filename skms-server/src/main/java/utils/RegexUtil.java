package utils;

/**
 * 正規表現を扱うときに使用する静的なクラスです。
 * 
 * @author yoshinori-t
 * 
 */
public class RegexUtil {
	
	/**
	 * メタ文字変換配列
	 */
	private static final String[][] arrMetaWord = {
			 {"\\\\",	"\\\\\\\\"}	// ￥文字は最初に変換を実施
			,{"\\.",	"\\\\\\."}
			,{"\\^",	"\\\\\\^"}
			,{"\\[",	"\\\\\\["}
			,{"\\]",	"\\\\\\]"}
			,{"\\*",	"\\\\\\*"}
			,{"\\+",	"\\\\\\+"}
			,{"\\?",	"\\\\\\?"}
			,{"\\|",	"\\\\\\|"}
			,{"\\(",	"\\\\\\("}
			,{"\\)",	"\\\\\\)"}
	};
	
	/**
	 * 指定された文字列のメタ文字に「￥」を付加した文字列を返却する
	 * 
	 * @param regex 変換対象の文字列
	 * @return メタ文字に「￥」を付加した文字列
	 */
	public static String replaceMetaWord(String regex)
	{
		String dst = regex;
		for ( int i = 0; i < arrMetaWord.length; i++ )
		{
			dst = dst.replaceAll(arrMetaWord[i][0], arrMetaWord[i][1]);
		}
		return dst;
	}
}
