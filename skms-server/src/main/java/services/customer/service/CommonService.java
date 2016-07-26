package services.customer.service;

import java.util.List;
import java.util.TreeMap;

import org.apache.log4j.Logger;
import org.seasar.extension.jdbc.JdbcManager;

import services.customer.dto.CustomerDto;
import services.customer.dto.CustomerSearchDto;
import services.customer.dxo.CustomerDxo;
import services.customer.dxo.CustomerMemberDxo;
import services.generalAffair.entity.MStaff;


/**
 * 客先を扱うサービスです.
 *
 * @author yasuo-k
 *
 */
public class CommonService {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * ログです.
	 */
	public Logger logger;

	/**
	 * 顧客情報変換Dxoです.
	 */
	public CustomerDxo customerDxo;

	/**
	 * 顧客担当者情報変換Dxoです.
	 */
	public CustomerMemberDxo customerMemberDxo;


	/** Exception メッセージ */
	private static final String EXCEPTION_MSG_DATA_NOT_SET    = "Data is not set.";
	private static final String EXCEPTION_MSG_DELETE_PROJECT = "The project application exists.";
	private static final String EXCEPTION_MSG_EXIST_CUSTOMERCODE = "The specified CustomerCode exists.";

	/**
	 * データ未設定の例外を作成する.
	 *
	 * @param msg 例外内容.
	 * @return 例外.
	 */
	protected static Exception createNotSetException(String msg)
	{
		String error = "CostomerDataSetException : ";
		String message = EXCEPTION_MSG_DATA_NOT_SET;
		message += "(" + msg + ")";
		return new Exception(error + message);
	}

	/**
	 * 削除不可の例外を作成する.
	 *
	 * @param msg 例外内容.
	 * @return 例外.
	 */
	protected static Exception createDeleteException(String msg)
	{
		String error = "CostomerDeleteException : ";
		return new Exception(error + msg);
	}

	/**
	 * プロジェクトあり削除不可の例外を作成する.
	 *
	 * @param  map 例外内容.
	 * @return 例外.
	 */
	protected static Exception createDeleteExceptionProject(TreeMap<Integer, String> map)
	{
		String msg   = "";
		String error = EXCEPTION_MSG_DELETE_PROJECT;
		for (Integer key : map.keySet()) {
			if (msg.length() > 0)	msg += ",";
			msg += map.get(key);
		}
		return createDeleteException(error + "(" + msg + ")");
	}

	/**
	 * 顧客コード重複の例外を作成する.
	 *
	 * @param  cCode 新顧客コード.
	 * @return 例外.
	 */
	protected static Exception createExistDataException_customerCode(String cCode)
	{
		String error = "ExistDataException : ";
		String errorD = EXCEPTION_MSG_EXIST_CUSTOMERCODE;
		String msg   = errorD + "(" + cCode + ")";
		return new Exception(error + msg);
	}


	/** 引数チェック:ログイン社員情報 */
	protected void checkData_staff(MStaff staff) throws Exception
	{
		if (staff == null || !(staff.staffId > 0)) {
			throw createNotSetException("staff == null || !(staff.staffId > 0)");
		}
	}
	/** 引数チェック:顧客情報 */
	protected void checkData_customer(CustomerDto customer) throws Exception
	{
		if (customer == null) {
			throw createNotSetException("customer == null");
		}
	}
	/** 引数チェック:顧客情報リスト */
	protected void checkData_customerList(List<CustomerDto> customerList) throws Exception
	{
		if (customerList == null) {
			throw createNotSetException("customerList == null");
		}
	}
	/** 引数チェック:検索条件 */
	protected void checkData_search(CustomerSearchDto search) throws Exception
	{
		if (search == null) {
			throw createNotSetException("search == null");
		}
	}
	/** 引数チェック:顧客区分 */
	protected void checkData_customerType(String customerType) throws Exception
	{
		if (customerType == null) {
			throw createNotSetException("customerType == null");
		}
	}
}
