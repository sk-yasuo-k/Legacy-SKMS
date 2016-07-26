package servlet.generalAffair;
/*
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
*/
import java.io.*;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.transaction.Status;
import javax.transaction.UserTransaction;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
/*
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
*/
//追加
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

//import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.framework.container.S2Container;
import org.seasar.framework.container.SingletonS2Container;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.org.apache.xml.internal.serializer.OutputPropertiesFactory;

import enumerate.WorkingHoursActionId;
import enumerate.WorkingHoursStatusId;

import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.WorkingHoursDaily;
import services.generalAffair.entity.WorkingHoursHistory;
import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.service.WorkingHoursService;

/**
 * 勤務管理表ファイルのインポートを扱うアクションです。

 *
 * @author yasuo-k
 *
 */
public class WorkingHoursFileImport extends HttpServlet{

	static final long serialVersionUID = 1L;

	/**
	 * ファイルアップロード.
	 *
	 * @param req  HttpServletRequest
	 * @param resp HttpServletResponse
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		try {
			// S2Containerオブジェクトの取得
			S2Container container = SingletonS2Container.getComponent(S2Container.class);
			// ユーザートランザクションオブジェクトを取得する.
			UserTransaction uTx = (UserTransaction)container.getComponent(UserTransaction.class); 
			// トランザクションの開始
			uTx.begin();
			int rowNum = 0;
			int cellNum = 0;
			
//			HSSFRow  row = null;
//			HSSFCell cell = null;
			
			//追加 @auther okamoto
			Row row = null;
			Cell cell = null;
			
			// ログイン社員ID
			int loginStaffId = Integer.parseInt((String)req.getParameter("loginStaffId"));
			// 管理者モード
			Boolean isManagementMode = Boolean.parseBoolean((String)req.getParameter("isManagementMode"));
			// 総務承認済状態にするかどうか
			Boolean doApproval = Boolean.parseBoolean((String)req.getParameter("doApproval"));
			// 上書き確認有無
			Boolean doOverwriteConfirmation = Boolean.parseBoolean((String)req.getParameter("doOverwriteConfirmation"));
			
			// response の content-type を設定する.
			resp.setContentType("text/xml; charset=UTF-8");
			PrintWriter out = resp.getWriter();
	
			//DOM Documentのインスタンスを生成するBuilderクラスのインスタンスを取得する.
			DocumentBuilderFactory bfactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = bfactory.newDocumentBuilder();
	
			//ビルダーからDOMを取得する
			Document document = builder.newDocument();
			// XMLのルートを設定する.
			Element root = document.createElement("root");
	
			try {
				// JdbcManagerオブジェクトの取得
				JdbcManager jdbcManager = SingletonS2Container.getComponent(JdbcManager.class);
				// WorkingHoursServiceオブジェクトの取得
				WorkingHoursService workingHoursService = SingletonS2Container.getComponent(WorkingHoursService.class);
				
				// マルチパートリクエストでないならば
				if (!ServletFileUpload.isMultipartContent(req)) {
					// 結果タグを追加する.
					Element result = document.createElement("result");
					result.setTextContent("-1");
					root.appendChild(result);
					// メッセージタグを追加する.
					Element message = document.createElement("message");
					message.setTextContent("不正なリクエストです。");
					root.appendChild(message);
					return;
				}

				// ServletFileUpload を生成する.
				DiskFileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);

				// データを取得する.
				List<FileItem> list = upload.parseRequest(req);
				Iterator<FileItem> iterator = list.iterator();

				FileItem item = null;
				while (iterator.hasNext()) {
					item = iterator.next();
					if (item.getName() != null) break;
				}

				InputStream fin = null;
//				POIFSFileSystem poi = null;
				
//				HSSFWorkbook workbook = null;
				//追加 @auther okamoto
				Workbook workbook = null;
				try {
					// アップロードファイルを取得する.
					fin = item.getInputStream();
//					poi = new POIFSFileSystem(fin);
					// ワークブックを読み込む.
//					workbook = new HSSFWorkbook(poi);
					
					//追加 @auther okamoto
					workbook = WorkbookFactory.create(fin);
					if (workbook == null) {
						// 結果タグを追加する.
						Element result = document.createElement("result");
						result.setTextContent("-1");
						root.appendChild(result);
						// メッセージタグを追加する.
						Element message = document.createElement("message");
						message.setTextContent("正規の勤務管理表ファイルではありません。");
						root.appendChild(message);
						return;
					}
				} catch(Exception e) {
					// 結果タグを追加する.
					Element result = document.createElement("result");
					result.setTextContent("-1");
					root.appendChild(result);
					// メッセージタグを追加する.
					Element message = document.createElement("message");
					message.setTextContent("正規の勤務管理表ファイルではありません。");
					root.appendChild(message);
					return;
				}
				
				// 最初のシートのみ処理対象とする.
				int sheetindex = 0;

				// シートを読み込む.
//				HSSFSheet sheet = workbook.getSheetAt(sheetindex);

				//追加 @auther okamoto
				Sheet sheet = workbook.getSheetAt(sheetindex);
				
				// 「総括」の文字列を取得する。
				row = sheet.getRow(rowNum=0);
				cell = row.getCell(cellNum=0);

				if (cell == null || !cell.toString().equals("総括")) {
					// 結果タグを追加する.
					Element result = document.createElement("result");
					result.setTextContent("-1");
					root.appendChild(result);
					// メッセージタグを追加する.
					Element message = document.createElement("message");
					message.setTextContent("正規の勤務管理表ファイルではありません。");
					root.appendChild(message);
					return;
				}

				// 勤務月を取得する.
				row = sheet.getRow(rowNum=1);
				cell = row.getCell(cellNum=6);
				Date date = cell.getDateCellValue();
				
				if (date == null) {
					// 結果タグを追加する.
					Element result = document.createElement("result");
					result.setTextContent("-1");
					root.appendChild(result);
					// メッセージタグを追加する.
					Element message = document.createElement("message");
					String msg = String.format("勤務月[%s]が不正です。", cell.toString());
					message.setTextContent(msg);
					root.appendChild(message);
					return;
				}
				Calendar cal = Calendar.getInstance();
				cal.setTime(date);
				// 勤務月.
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
				String workingMonthCode = sdf.format(date);
				
				// 氏名を取得する。
				row = sheet.getRow(rowNum=1);
				cell = row.getCell(cellNum=13);
				String fullName = cell.toString();

				// 社員マスタから社員情報の取得
				MStaff staff = jdbcManager.from(MStaff.class)
					.innerJoin("staffName", "staffName.lastName || staffName.firstName like translate(?, ' 　','')", fullName+"%")
					.getSingleResult();
				
				if (staff == null) {
					// 結果タグを追加する.
					Element result = document.createElement("result");
					result.setTextContent("-1");
					root.appendChild(result);
					// メッセージタグを追加する.
					Element message = document.createElement("message");
					String msg = String.format("氏名[%s]が社員マスタに存在しません。", fullName);
					message.setTextContent(msg);
					root.appendChild(message);
					return;
				}
				
				// 管理者モードでないならば
				if(!isManagementMode) {
					// 自分の勤務管理表以外ならば
					if (loginStaffId != staff.staffId) {
						// 結果タグを追加する.
						Element result = document.createElement("result");
						result.setTextContent("-1");
						root.appendChild(result);
						// メッセージタグを追加する.
						Element message = document.createElement("message");
						String msg = String.format("あなたの勤務管理表ではありません。", fullName);
						message.setTextContent(msg);
						root.appendChild(message);
						return;
					}
				}
				WorkingHoursMonthly workingHoursMonthly = new WorkingHoursMonthly();
				// 社員ID
				workingHoursMonthly.staffId = staff.staffId;
				// 勤務月コード
				workingHoursMonthly.workingMonthCode = workingMonthCode;

				// 勤務管理表手続状態の取得
				WorkingHoursHistory whh
					= workingHoursService.getCurrentWorkingHoursStatus(staff.staffId, workingMonthCode);
				// 勤務管理表作成済ならば
				if (whh != null) {
					// 作成済、差し戻し中以外ならば
					if (whh.workingHoursStatusId != WorkingHoursStatusId.ENTERED
						&& whh.workingHoursStatusId != WorkingHoursStatusId.REJECTED) {
						// 管理モードでないなら
						if (!isManagementMode || !doApproval) {
							// 結果タグを追加する.
							Element result = document.createElement("result");
							result.setTextContent("-1");
							root.appendChild(result);
							// メッセージタグを追加する.
							Element message = document.createElement("message");
							String msg = String.format("勤務管理表は%sですのでアップロードできません。", whh.workingHoursStatus.workingHoursStatusName);
							message.setTextContent(msg);
							root.appendChild(message);
							return;
						}
					// 上書き確認ありならば
					} else if (doOverwriteConfirmation){
						// 結果タグを追加する.
						Element result = document.createElement("result");
						result.setTextContent("1");
						root.appendChild(result);
						return;
					}
				}
				
				// 登録者ID
				workingHoursMonthly.registrantId = loginStaffId;
				
				// 日別勤務時間
				workingHoursMonthly.workingHoursDailies = new ArrayList<WorkingHoursDaily>();
				// 勤務日の時分秒を切り捨てる。
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), 1, 0, 0, 0);
				// 月の末日を取得
				Calendar lastDate = Calendar.getInstance();
				lastDate.setTime(cal.getTime());
				lastDate.set(Calendar.DATE, lastDate.getActualMaximum(Calendar.DATE));

				int rowIndex = 5;
				while(0 >= cal.compareTo(lastDate)) {
					WorkingHoursDaily workingHoursDaily = new WorkingHoursDaily();
					// 社員ID
					workingHoursDaily.staffId = staff.staffId;
					// 勤務月コード
					workingHoursDaily.workingMonthCode = workingMonthCode;
					// 勤務日
					workingHoursDaily.workingDate = cal.getTime();
					
					row = sheet.getRow(rowNum=rowIndex);
					// 時差勤務開始時刻
					cell = row.getCell(cellNum=2);
					workingHoursDaily.staggeredStartTime = getTimestamp(cal, cell);
					
					// 開始時刻
					cell = row.getCell(cellNum=3);
					workingHoursDaily.startTime = getTimestamp(cal, cell);

					// 終了時刻
					cell = row.getCell(cellNum=4);
					workingHoursDaily.quittingTime = getTimestamp(cal, cell);

					// 開始時刻が終了時刻以降ならば
					if (workingHoursDaily.startTime != null && workingHoursDaily.quittingTime != null)
					{
						if (!workingHoursDaily.quittingTime.after(workingHoursDaily.startTime))
						{
							long nxtDt = workingHoursDaily.quittingTime.getTime() + (24 * 60 * 60 * 1000);
							workingHoursDaily.quittingTime.setTime(nxtDt);
						}
					}
					
					// 差引時間
					cell = row.getCell(cellNum=5);
					workingHoursDaily.balanceHours = getFloatValue(cell);

					// 私用時間
					cell = row.getCell(cellNum=6);
					workingHoursDaily.privateHours = getFloatValue(cell);

					// 勤務時間
					cell = row.getCell(cellNum=7);
					workingHoursDaily.workingHours = getFloatValue(cell);

					// 休憩時間
					cell = row.getCell(cellNum=8);
					workingHoursDaily.recessHours = getFloatValue(cell);

					// 実働時間
					cell = row.getCell(cellNum=9);
					workingHoursDaily.realWorkingHours = getFloatValue(cell);

					// 勤休コード
					cell = row.getCell(cellNum=10);
					workingHoursDaily.absenceCode = (int)getFloatValue(cell);

					// 控除数
					cell = row.getCell(cellNum=12);
					workingHoursDaily.deductionCount = getFloatValue(cell);

					// 勤休・遅刻事由
					cell = row.getCell(cellNum=14);
					workingHoursDaily.note = cell != null ? cell.toString() : null;

					// 休日出勤
					cell = row.getCell(cellNum=19);
					float hwt = (float)getFloatValue(cell);
					if (hwt == 1.0)
					{
						workingHoursDaily.holidayWorkType = 1;
					}
					else if (hwt == 0.5)
					{
						workingHoursDaily.holidayWorkType = 2;
					}

					// 深夜勤務
					cell = row.getCell(cellNum=20);
					workingHoursDaily.nightWorkFlg = (int)getFloatValue(cell) == 1;

					// 勤務管理表オブジェクトに追加
					workingHoursMonthly.workingHoursDailies.add(workingHoursDaily);
					// 日付のインクリメント
					cal.add(Calendar.DATE, 1);
					rowIndex++;
				}
				// 月間合計の行位置設定
				row = sheet.getRow(rowNum=36);
				
				// 差引時間
				cell = row.getCell(cellNum=5);
				workingHoursMonthly.balanceHours = getFloatValue(cell);
				
				// 私用時間
				cell = row.getCell(cellNum=6);
				workingHoursMonthly.privateHours = getFloatValue(cell);

				// 勤務時間
				cell = row.getCell(cellNum=7);
				workingHoursMonthly.workingHours = getFloatValue(cell);

				// 休憩時間
				cell = row.getCell(cellNum=8);
				workingHoursMonthly.recessHours = getFloatValue(cell);

				// 実働時間
				cell = row.getCell(cellNum=9);
				workingHoursMonthly.realWorkingHours = getFloatValue(cell);

				// 控除数
				cell = row.getCell(cellNum=12);
				workingHoursMonthly.deductionCount = getFloatValue(cell);

				// 休日出勤日数
				cell = row.getCell(cellNum=19);
				workingHoursMonthly.holidayWorkCount = (int)getFloatValue(cell);

				// 深夜勤務日数
				cell = row.getCell(cellNum=20);
				workingHoursMonthly.nightWorkCount = (int)getFloatValue(cell);
				
				// 欠勤日数の行位置設定
				row = sheet.getRow(rowNum=38);
				cell = row.getCell(cellNum=20);
				// 欠勤日数
				workingHoursMonthly.absenceCount = (int)getFloatValue(cell);
				// 無断欠勤日数の行位置設定
				row = sheet.getRow(rowNum=39);
				cell = row.getCell(cellNum=20);
				// 無断欠勤日数
				workingHoursMonthly.absenceWithoutLeaveCount = (int)getFloatValue(cell);
				
				// 有給繰越日数
				row = sheet.getRow(rowNum=37);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.lastPaidVacationCount = getFloatValue(cell);
				// 有給発生日数は0とする
				workingHoursMonthly.givenPaidVacationCount = 0;
				// 有給使用日数
				row = sheet.getRow(rowNum=38);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.takenPaidVacationCount = getFloatValue(cell);
				// 有給今月残日数
				row = sheet.getRow(rowNum=39);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.currentPaidVacationCount = getFloatValue(cell);

				// 代休繰越日数
				row = sheet.getRow(rowNum=40);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.lastCompensatoryDayOffCount = (int)getFloatValue(cell);
				// 代休発生日数
				row = sheet.getRow(rowNum=41);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.givenCompensatoryDayOffCount = (int)getFloatValue(cell);
				// 代休使用日数
				row = sheet.getRow(rowNum=42);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.takenCompensatoryDayOffCount = (int)getFloatValue(cell);
				// 代休今月残日数
				row = sheet.getRow(rowNum=43);
				cell = row.getCell(cellNum=3);
				workingHoursMonthly.currentCompensatoryDayOffCount = (int)getFloatValue(cell);
				
				// 更新ならば現在の更新バージョンを取得する。
//				if (whh != null) {
					WorkingHoursMonthly whm
						= workingHoursService.getWorkingHoursMonthly(staff.staffId, workingMonthCode);
					if (whm != null) workingHoursMonthly.registrationVer = whm.registrationVer;
//				}
				// 勤務管理表の登録
				workingHoursService.updateWorkingHoursMonthly(workingHoursMonthly);
				
				// 勤務管理表手続状態の取得
				whh	= workingHoursService.getCurrentWorkingHoursStatus(staff.staffId, workingMonthCode);
				
				// 総務承認まで実施するならば
				if (doApproval) {
					WorkingHoursHistory workingHoursHistory = new WorkingHoursHistory();
					workingHoursHistory.staffId = staff.staffId;
					workingHoursHistory.workingMonthCode = workingMonthCode;
					workingHoursHistory.workingHoursStatusId = WorkingHoursStatusId.SUBMITTED;
					workingHoursHistory.workingHoursActionId = WorkingHoursActionId.SUBMIT;
					workingHoursHistory.registrantId = loginStaffId;
					workingHoursHistory.registrantName = "システム";
					workingHoursHistory.updateCount = whh.updateCount + 1;
					workingHoursService.insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

					// 勤務管理表手続状態の取得
					whh	= workingHoursService.getCurrentWorkingHoursStatus(staff.staffId, workingMonthCode);
					
					workingHoursHistory = new WorkingHoursHistory();
					workingHoursHistory.staffId = staff.staffId;
					workingHoursHistory.workingMonthCode = workingMonthCode;
					workingHoursHistory.workingHoursStatusId = WorkingHoursStatusId.GA_APPROVED;
					workingHoursHistory.workingHoursActionId = WorkingHoursActionId.GA_APPROVAL;
					workingHoursHistory.registrantId = loginStaffId;
					workingHoursHistory.registrantName = "システム";
					workingHoursHistory.updateCount = whh.updateCount + 1;
					workingHoursService.insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);
				}
				// タグを追加する.
				Element element = document.createElement("result");
				element.setTextContent("0");
				root.appendChild(element);
				// トランザクションのコミット
				uTx.commit();
			}
			catch (Exception e) {
				// 結果タグを追加する.
				Element result = document.createElement("result");
				result.setTextContent("-1");
				root.appendChild(result);
				// メッセージタグを追加する.
				Element message = document.createElement("message");
				String msg = String.format("%d行%d列のデータ[%s]の形式が不正です。", rowNum+1, cellNum+1, cell != null? cell.toString() : "");
				message.setTextContent(msg);
				root.appendChild(message);
				return;
			}
			finally {
				try {
					// rootタグを追加する.
					document.appendChild(root);
		
					// DOMの内容をクライアントに出力する.
					TransformerFactory tfactory = TransformerFactory.newInstance();
					Transformer transformer = tfactory.newTransformer();
					// インデントを設定する.
					transformer.setOutputProperty(OutputKeys.INDENT, "yes");
					transformer.setOutputProperty(OutputKeys.METHOD, "xml");
					transformer.setOutputProperty(OutputPropertiesFactory.S_KEY_INDENT_AMOUNT, "2");
					// DOM を出力する.
					transformer.transform(new DOMSource(document), new StreamResult(out));
					// トランザクションのロールバック
					if (uTx.getStatus() != Status.STATUS_NO_TRANSACTION) uTx.rollback();
				} catch(Exception e) {
					ServletException srve = new ServletException(e.getMessage(), e.getCause());
					throw srve;
				}
			}
		} catch (Exception e) {
			ServletException srve = new ServletException(e.getMessage(), e.getCause());
			throw srve;
		}
	}

//	private Timestamp getTimestamp(Calendar cal, HSSFCell cell) throws Exception {
	//追加 @auther okamoto
	private Timestamp getTimestamp(Calendar cal, Cell cell) throws Exception {
		Timestamp ts = null;
		if (cell != null && cell.getDateCellValue() != null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd ");
			String sDate = sdf.format(cal.getTime());
			SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
			String sTime = sdf2.format(cell.getDateCellValue());
			ts = new Timestamp(SimpleDateFormat.getDateTimeInstance().parse(sDate + sTime).getTime());
		}
		return ts;
	}

//	private float getFloatValue(HSSFCell cell) throws Exception {
	//追加 @auther okamoto
	private float getFloatValue(Cell cell) throws Exception {
		float hours = 0;
		if (cell != null) {
			switch (cell.getCellType()) {
/*			
				case HSSFCell.CELL_TYPE_BLANK:
				case HSSFCell.CELL_TYPE_BOOLEAN:
				case HSSFCell.CELL_TYPE_ERROR:
					break;
				case HSSFCell.CELL_TYPE_FORMULA:
			
					if (cell.getCachedFormulaResultType() == HSSFCell.CELL_TYPE_NUMERIC) {
						hours = (float)cell.getNumericCellValue();
					} else {
						if (!cell.getRichStringCellValue().getString().isEmpty()) {
							hours = (float)Double.parseDouble(cell.getRichStringCellValue().getString());
						}
					}
					break;
				case HSSFCell.CELL_TYPE_NUMERIC:
					hours = (float)cell.getNumericCellValue();
					break;
				case HSSFCell.CELL_TYPE_STRING:
					if (!cell.getRichStringCellValue().getString().isEmpty()) {
						hours = (float)Double.parseDouble(cell.getRichStringCellValue().getString());
					}
					break;
*/			
			//追加 @auther okamoto
				case Cell.CELL_TYPE_BLANK:
				case Cell.CELL_TYPE_BOOLEAN:
				case Cell.CELL_TYPE_ERROR:
					break;
				case Cell.CELL_TYPE_FORMULA:
		
				if (cell.getCachedFormulaResultType() == Cell.CELL_TYPE_NUMERIC) {
					hours = (float)cell.getNumericCellValue();
				} else {
					if (!cell.getRichStringCellValue().getString().isEmpty()) {
						hours = (float)Double.parseDouble(cell.getRichStringCellValue().getString());
					}
				}
				break;
				case Cell.CELL_TYPE_NUMERIC:
				hours = (float)cell.getNumericCellValue();
				break;
				case Cell.CELL_TYPE_STRING:
				if (!cell.getRichStringCellValue().getString().isEmpty()) {
					hours = (float)Double.parseDouble(cell.getRichStringCellValue().getString());
				}
				break;
				
			}
			if (!cell.toString().isEmpty()) {
			}
		}
		return hours;
	}

}