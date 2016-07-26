package services.project.service;

import java.util.TreeMap;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectDto;
import services.project.dto.ProjectSearchDto;
import services.project.dto.ProjectSituationDto;


/**
 * プロジェクトユーティリティです.
 *
 * @author yasuo-k
 *
 */
public class ProjectUtil {


	/** Exception メッセージ */
	private static final String EXCEPTION_MSG_DATA_NOT_SET     = "Data is not set.";
	private static final String EXCEPTION_MSG_DELETE_TRANSPORT = "The transportation application exists.";

//	/**
//	 * 例外を作成する.
//	 *
//	 * @param msg 例外メッセージ.
//	 * @return 例外.
//	 */
//	protected static Exception createException(String msg)
//	{
//		String message = "ProjectException : ";
//		if (msg != null)	message += "(" + msg + ")";
//		return new Exception(msg);
//	}

	/**
	 * データ未設定の例外を作成する.
	 *
	 * @param msg 例外内容.
	 * @return 例外.
	 */
	protected static Exception createNotSetException(String msg)
	{
		String error = "ProjectDataSetException : ";
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
		String error = "ProjectDeleteException : ";
		return new Exception(error + msg);
	}

	/**
	 * 交通費申請あり削除不可の例外を作成する.
	 *
	 * @param  map 例外内容.
	 * @return 例外.
	 */
	protected static Exception createDeleteExceptionTrans(TreeMap<Integer, String> map)
	{
		String msg   = "";
		String error = EXCEPTION_MSG_DELETE_TRANSPORT;
		for (Integer key : map.keySet()) {
			if (msg.length() > 0)	msg += ",";
			msg += map.get(key);
		}
		return createDeleteException(error + "(" + msg + ")");
	}


	/** 引数チェック:ログイン社員情報 */
	protected static void checkData_staff(MStaff staff) throws Exception
	{
		if (staff == null || !(staff.staffId > 0)) {
			throw createNotSetException("staff == null || !(staff.staffId > 0)");
		}
	}
	/** 引数チェック:プロジェクト情報 */
	protected static void checkData_project(ProjectDto project) throws Exception
	{
		if (project == null) {
			throw createNotSetException("project == null");
		}
	}
	/** 引数チェック:検索条件 */
	protected static void checkData_search(ProjectSearchDto search) throws Exception
	{
		if (search == null) {
			throw createNotSetException("search == null");
		}
	}
	/** 引数チェック:プロジェクト状況情報 */
	protected static void checkData_situation(ProjectSituationDto situation) throws Exception
	{
		if (situation == null) {
			throw createNotSetException("situation == null");
		}
	}
}
