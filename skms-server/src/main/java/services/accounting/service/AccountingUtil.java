package services.accounting.service;

import java.util.List;


import services.accounting.dto.OverheadDto;
import services.accounting.dto.OverheadSearchDto;
import services.accounting.dto.ProjectTransportationMonthlySearchDto;
import services.accounting.dto.RouteDetailDto;
import services.accounting.dto.RouteDto;
import services.accounting.dto.TransportationDetailDto;
import services.accounting.dto.TransportationDto;
import services.generalAffair.entity.MStaff;


/**
 * 経理ユーティリティです。
 *
 * @author yasuo-k
 *
 */
public class AccountingUtil {

	/** データタイプ：通常申請 */
	public static final int DATA_REQUEST     = 1;
	/** データタイプ：通常承認 */
	public static final int DATA_APPROVAL    = 2;
	/** データタイプ：経理承認 */
	public static final int DATA_APPROVAL_AF = 3;

	/** 交通費集計基準：発生日で集計 */
	public static final int BASE_OCCUR_DATE  = 1;
	/** 交通費集計基準：支払日で集計 */
	public static final int BASE_PAY_DATE    = 2;

	/** Exception メッセージ */
	private static final String EXCEPTION_MSG_DATA_NOT_SET ="データ未設定";

	/** Exception作成 */
	protected static Exception createException(String func, String msg)
	{
		String message = "AccountingException." + func + " : ";
		message += EXCEPTION_MSG_DATA_NOT_SET;
		if (msg != null)	message += "(" + msg + ")";
		return new Exception(message);
	}
	protected static Exception createException(String msg)
	{
		String message = "AccountingException : ";
		message += EXCEPTION_MSG_DATA_NOT_SET;
		if (msg != null)	message += "(" + msg + ")";
		return new Exception(message);
	}


	/** 引数チェック:ログイン社員情報 */
	protected static void checkData_staff(MStaff staff) throws Exception
	{
		if (staff == null || !(staff.staffId > 0)) {
			throw createException("staff == null || !(staff.staffId > 0)");
		}
	}
	/** 引数チェック:プロジェクトIDリスト */
	protected static void checkData_projectList(List<Integer> projectList) throws Exception
	{
		if (projectList == null) {
			throw createException("projectList == null");
		}
	}
	/** 引数チェック:状態IDリスト */
	protected static void checkData_statusList(List<Integer> statusList) throws Exception
	{
		if (statusList == null) {
			throw createException("statusList == null");
		}
	}
	/** 引数チェック:交通費情報 */
	protected static void checkData_transDto(TransportationDto transDto) throws Exception
	{
		if (transDto == null) {
			throw createException("transDto == null");
		}
	}
	/** 引数チェック:交通費情報リスト */
	protected static void checkData_transDtoList(List<TransportationDto> transDtoList) throws Exception
	{
		if (transDtoList == null || !(transDtoList.size() > 0)) {
			throw createException("transDtoList == null || !(transDtoList.size() > 0)");
		}
	}
	/** 引数チェック:交通費明細情報リスト */
	protected static void checkData_transDetailDtoList(List<TransportationDetailDto> transDetailDtoList) throws Exception
	{
		if (transDetailDtoList == null || !(transDetailDtoList.size() > 0)) {
			throw createException("transDetailDtoList == null || !(transDetailDtoList.size() > 0)");
		}
	}
	/** 引数チェック:理由 */
	protected static void checkData_reason(String reason) throws Exception
	{
		if (reason == null || !(reason.trim().length() > 0)) {
			throw createException("reason == null || !(reason.trim().length() > 0)");
		}
	}
	/** 引数チェック:経路情報 */
	protected static void checkData_routeDto(RouteDto routeDto) throws Exception
	{
		if (routeDto == null) {
			throw createException("routeDto == null");
		}
	}
	/** 引数チェック:経路情報リスト */
	protected static void checkData_routeDtoList(List<RouteDto> routeDtoList) throws Exception
	{
		if (routeDtoList == null || !(routeDtoList.size() > 0)) {
			throw createException("routeDtoList == null || !(routeDtoList.size() > 0)");
		}
	}
	/** 引数チェック:経路詳細情報リスト */
	protected static void checkData_routeDetailDtoList(List<RouteDetailDto> routeDetailDtoList) throws Exception
	{
		if (routeDetailDtoList == null || !(routeDetailDtoList.size() > 0)) {
			throw createException("routeDetailDtoList == null || !(routeDetailDtoList.size() > 0)");
		}
	}
	/** 引数チェック:交通費集計検索条件情報 */
	protected static void checkData_search(ProjectTransportationMonthlySearchDto search) throws Exception
	{
		if (search == null) {
			throw createException("search == null");
		}
		else if (search.startDate == null || search.finishDate == null) {
			throw createException("search.startDate == null || search.finishtDate == null");
		}
		else if (search.statusList == null || !(search.statusList.size() > 0)) {
			throw createException("search.statusList == null || !(search.statusList.size() > 0)");
		}
	}

	// ----------------------------------------------------------
	//     諸経費
	// ----------------------------------------------------------
	/** 引数チェック:諸経費情報 */
	protected static void checkData_overhead(OverheadDto overhead) throws Exception
	{
		if (overhead == null) {
			throw createException("overhead == null");
		}
	}
	/** 引数チェック:諸経費検索条件情報 */
	protected static void checkData_search(OverheadSearchDto search) throws Exception
	{
		if (search == null) {
			throw createException("search == null");
		}
		else if (search.projectList == null || !(search.projectList.size() > 0)) {
			throw createException("search.projectList == null || !(search.projectList.size() > 0)");
		}
		else if (search.statusList == null || !(search.statusList.size() > 0)) {
			throw createException("search.statusList == null || !(search.statusList.size() > 0)");
		}
	}
}
