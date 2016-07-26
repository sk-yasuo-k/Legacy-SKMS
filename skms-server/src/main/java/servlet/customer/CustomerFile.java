package servlet.customer;

import java.util.ArrayList;
import java.util.List;



/**
 * 取引先ファイル定義です.
 *
 * @author yasuo-k
 *
 */
public class CustomerFile {

	/*																			*/
	/* 取引先情報ファイル														*/
	/*																			*/
	/** ファイルPath */
	public final static String FILE_PATH = "./skmstmp";

	/** 取引先情報ファイル Prefix */
	public final static String CUSTOMER_EXCEL_PREFIX = "CustomerInfo";
	/** 取引先情報ファイル 区切り */
	public final static String CUSTOMER_EXCEL_DELIM  = "_";
	/** 取引先情報ファイル Suffix */
	public final static String CUSTOMER_EXCEL_SUFFIX = ".xlsx";


	/** 取引先情報 表示項目定義 */
	/** タイトル */
	private final static int      rowCustomer_title = 1;
	private final static int      colCustomer_title = 1;
	private final static String   titleCustomer     = "取引先情報";
	/** 表示項目 */
	private final static int      rowCustomer_data  = 2;
	private final static int      colCustomer_data  = 1;
	private final static Object[] dataCustomer_type	= {"顧客区分",			"customerType"};
	private final static Object[] dataCustomer_code	= {"顧客コード",		"customerCode"};
	private final static Object[] dataCustomer_name	= {"顧客名称",			"customerName"};
	private final static Object[] dataCustomer_alias= {"顧客略称",			"customerAlias"};
	private final static Object[] dataCustomer_last	= {"代表者 姓（漢字）",	"representativeLastName"};
	private final static Object[] dataCustomer_first= {"代表者 名（漢字）",	"representativeFirstName"};
	private final static Object[] dataCustomer_lastk= {"代表者 姓（かな）",	"representativeLastNameKana"};
	private final static Object[] dataCustomer_firstk={"代表者 名（かな）",	"representativeFirstNameKana"};
	private final static Object[] dataCustomer_web	= {"Webページ",			"customerHtml"};
	private final static Object[] dataCustomer_date	= {"取引開始日",		"customerStartDate"};
	private final static Object[] dataCustomer_bill	= {"支払サイト",		"billPayable"};
	private final static Object[] dataCustomer_note	= {"備考",				"note"};



	/** 担当者情報 表示項目定義 */
	/** タイトル */
	private final static int      rowMember_title   = 17;
	private final static int      colMember_title   = 1;
	private final static String   titleMember       = "担当者情報";
	/** 表示項目 */
	private final static int      rowMember_data    = 18;
	private final static int      colMember_data    = 1;
	private final static Object[] dataMember_last	= {"姓（漢字）",		"lastName"};
	private final static Object[] dataMember_first	= {"名（漢字）",		"firstName"};
	private final static Object[] dataMember_lastk	= {"姓（かな）",		"lastNameKana"};
	private final static Object[] dataMember_firstk = {"名（かな）",		"firstNameKana"};
	private final static Object[] dataMember_dept	= {"部署",				"department"};
	private final static Object[] dataMember_pos	= {"役職",				"position"};
	private final static Object[] dataMember_tel	= {"電話",				"telephone"};
	private final static Object[] dataMember_fax	= {"FAX",				"fax"};
	private final static Object[] dataMember_tel2	= {"携帯電話",			"telephone2"};
	private final static Object[] dataMember_mail	= {"Email",				"email"};
	private final static Object[] dataMember_adrno	= {"住所（郵便番号）",	"addressNo"};
	private final static Object[] dataMember_adr	= {"住所（所在地）",	"address"};
	private final static Object[] dataMember_note	= {"備考",				"note"};
	private final static int      max_membeR 		= 10;


	/*																			*/
	/* 取引先teplateファイル													*/
	/*																			*/
	/** ファイルPath */
	public final static String FILE_PATH_TEMPLATE = "./skmstemplate";

	/** 取引先templateファイル名 */
	public final static String CUSTOMER_TEMPLATE  = "TemplateCustomerInfo.xlsx";



	/**
	 * 取引先情報表示項目の取得.
	 *
	 * @return 表示項目リスト.
	 */
	public static List<Object[]> getDefineCustomer()
	{
		List<Object[]> list = new ArrayList<Object[]>();
		list.add(dataCustomer_type);
		list.add(dataCustomer_code);
		list.add(dataCustomer_name);
		list.add(dataCustomer_alias);
		list.add(dataCustomer_last);
		list.add(dataCustomer_first);
		list.add(dataCustomer_lastk);
		list.add(dataCustomer_firstk);
		list.add(dataCustomer_web);
		list.add(dataCustomer_date);
		list.add(dataCustomer_bill);
		list.add(dataCustomer_note);
		return list;
	}


	/**
	 * 担当者情報表示項目の取得.
	 *
	 * @return 表示項目リスト.
	 */
	public static List<Object[]> getDefineMember()
	{
		List<Object[]> list = new ArrayList<Object[]>();
		list.add(dataMember_last);
		list.add(dataMember_first);
		list.add(dataMember_lastk);
		list.add(dataMember_firstk);
		list.add(dataMember_dept);
		list.add(dataMember_pos);
		list.add(dataMember_tel);
		list.add(dataMember_fax);
		list.add(dataMember_tel2);
		list.add(dataMember_mail);
		list.add(dataMember_adrno);
		list.add(dataMember_adr);
		list.add(dataMember_note);
		return list;
	}

	/**
	 * 取引先情報タイトルの取得.
	 *
	 * @return タイトル.
	 */
	public static String getTitleCustomer()
	{
		return titleCustomer;
	}

	/**
	 * 担当者情報タイトルの取得.
	 *
	 * @return タイトル.
	 */
	public static String getTitleMember()
	{
		return titleMember;
	}


	/**
	 * 取引先情報タイトル表示位置の取得.
	 *
	 * @return rowindex
	 */
	public static int getRow_titleCustomer()
	{
		return rowCustomer_title;
	}

	/**
	 * 担当者情報タイトル表示位置の取得.
	 *
	 * @return rowindex
	 */
	public static int getRow_titleMember()
	{
		return rowMember_title;
	}


	/**
	 * 取引先情報タイトル表示位置の取得.
	 *
	 * @return colindex
	 */
	public static int getCol_titleCustomer()
	{
		return colCustomer_title;
	}

	/**
	 * 担当者情報タイトル表示位置の取得.
	 *
	 * @return colindex
	 */
	public static int getCol_titleMember()
	{
		return colMember_title;
	}


	/**
	 * 取引先情報表示位置の取得.
	 *
	 * @return rowindex
	 */
	public static int getRow_dataCustomer()
	{
		return rowCustomer_data;
	}

	/**
	 * 担当者情報表示位置の取得.
	 *
	 * @return rowindex
	 */
	public static int getRow_dataMember()
	{
		return rowMember_data;
	}


	/**
	 * 取引先情報表示位置の取得.
	 *
	 * @return colindex
	 */
	public static int getCol_dataCustomer()
	{
		return colCustomer_data;
	}

	/**
	 * 担当者情報表示位置の取得.
	 *
	 * @return colindex
	 */
	public static int getCol_dataMember()
	{
		return colMember_data;
	}


	/**
	 * 担当者上限.
	 *
	 * @return 上限値
	 */
	public static int getMaxMember()
	{
		return max_membeR;
	}
}