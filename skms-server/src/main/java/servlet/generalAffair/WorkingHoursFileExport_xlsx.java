package servlet.generalAffair;

import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.apache.poi.hssf.usermodel.HSSFCell;
//import org.apache.poi.hssf.usermodel.HSSFRichTextString;
//import org.apache.poi.hssf.usermodel.HSSFRow;
//import org.apache.poi.hssf.usermodel.HSSFSheet;
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.seasar.framework.container.SingletonS2Container;

//追加
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;

import services.generalAffair.entity.WorkingHoursDaily;
import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.entity.MAbsenceCode;
import services.generalAffair.service.WorkingHoursService;
import utils.TermDateUtil;

import enumerate.AbsenceCodeId;


/**
 * 勤務管理表ファイル(xlsx形式)のエクスポートを扱うアクションです。

 *
 * @author yosuke-w
 *
 */
public class WorkingHoursFileExport_xlsx extends HttpServlet{

	static final long serialVersionUID = 1L;

	/**
	 * Excelファイルにエクスポート.
	 *
	 * @param req  HttpServletRequest
	 * @param resp HttpServletResponse
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException
	{
		// 対象社員IDのリスト
		String[] staffIds = ((String)req.getParameter("staffId")).split(",");
		// 勤務月
		String workingMonthCode = (String)req.getParameter("workingMonthCode");
		
        try{
			// WorkingHoursServiceオブジェクトの取得
			WorkingHoursService workingHoursService = SingletonS2Container.getComponent(WorkingHoursService.class);
        	// 勤休コードリストの取得
			List<MAbsenceCode> abscenseCodeList = workingHoursService.getAbsenceCodeList();

            //Excelのワークブックを読み込みます。
            //POIFSFileSystem filein = new POIFSFileSystem;
                //(new FileInputStream("/skmstemplate/WorkingHoursMonthly.xls"));
				//(new FileInputStream("C:/projects/smks/skms-server/src/main/java/servlet/generalAffair/WorkingHoursMonthly.xls"));
            //テスト用
            XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream("/skmstemplate/WorkingHoursMonthly.xlsx"));
            //HSSFWorkbook wb = new HSSFWorkbook(filein);
        
            String fileName = "";
            String sheetName = "";
            
			for (int i = 0; i < staffIds.length; i++) {
				int staffId = Integer.parseInt(staffIds[i]);
				// 勤務管理表の取得
				WorkingHoursMonthly whm = workingHoursService.getWorkingHoursMonthly(staffId, workingMonthCode);

				//HSSFSheet sheet;
				XSSFSheet sheet;
				// テンプレートを複製します。
				sheet = wb.cloneSheet(0);

		        // シート名の生成
		        sheetName = String.format("%02d期勤務_%s月(%s)",
	        		TermDateUtil.getTerm(whm.workingHoursDailies.get(0).workingDate)
	        		, whm.workingMonthCode.substring(4,6), whm.staffName.lastName);
				wb.setSheetName(i+1, sheetName);
				
				//HSSFRow row = sheet.getRow(1);
		        XSSFRow row = sheet.getRow(1);
				// 勤務月
		        //HSSFCell cell = row.getCell(6);
		        XSSFCell cell = row.getCell(6);
		        cell.setCellValue(whm.workingHoursDailies.get(0).workingDate);
		        
		        // 氏名
		        cell = row.getCell(13);
		        //HSSFRichTextString rs = new HSSFRichTextString(whm.staffName.fullName);
		        XSSFRichTextString rs = new XSSFRichTextString(whm.staffName.fullName);
		        cell.setCellValue(rs);
	
		        // 勤務時間
		        int ridx = 5;
		        // 月の日数分繰り返し
		        for (WorkingHoursDaily whd : whm.workingHoursDailies) {
		            row = sheet.getRow(ridx);
		            // 日付
		            cell = row.getCell(0);
		            Calendar c = Calendar.getInstance();
		            c.setTime(whd.workingDate);
		            cell.setCellValue(c.get(Calendar.DATE));
		            // 曜日
		            cell = row.getCell(1);
		            SimpleDateFormat sdf = new SimpleDateFormat("E");
		            //rs = new HSSFRichTextString(sdf.format(c.getTime()));
		            rs = new XSSFRichTextString(sdf.format(c.getTime()));
		            cell.setCellValue(rs);
		            // 休日ならば
		            if (whd.holidayName != null && whd.holidayName.length() > 0) {
		            	cell = row.getCell(21);
			            //rs = new HSSFRichTextString("H");
		            	rs = new XSSFRichTextString("H");
		            	cell.setCellValue(rs);
		            }
		            
		            //時差開始時刻
		            cell = row.getCell(2);
			        if (whd.staggeredStartTime != null) cell.setCellValue(whd.staggeredStartTime);
		            //開始時刻
		            cell = row.getCell(3);
			        if (whd.startTime != null) cell.setCellValue(whd.startTime);
		            //終了時刻
		            cell = row.getCell(4);
			        if (whd.quittingTime != null) cell.setCellValue(whd.quittingTime);
		            //差引時間
		            cell = row.getCell(5);
			        if (whd.balanceHours > 0) cell.setCellValue(whd.balanceHours);
		            //私用時間
		            cell = row.getCell(6);
			        if (whd.privateHours > 0) cell.setCellValue(whd.privateHours);
		            //勤務時間
		            cell = row.getCell(7);
			        if (whd.workingHours > 0) cell.setCellValue(whd.workingHours);
		            //休憩時間
		            cell = row.getCell(8);
			        if (whd.recessHours > 0) cell.setCellValue(whd.recessHours);
		            //実働時間
		            cell = row.getCell(9);
			        if (whd.realWorkingHours > 0) cell.setCellValue(whd.realWorkingHours);
		            //勤休コード
		            cell = row.getCell(10);
			        if (whd.absenceCode > 0) cell.setCellValue(whd.absenceCode);
			        // 勤休内容
		            cell = row.getCell(11);
		            for (MAbsenceCode absenceCode : abscenseCodeList) {
		            	if (absenceCode.absenceCode == whd.absenceCode
		            			&& whd.absenceCode != AbsenceCodeId.ABSENCE
		            			&& whd.absenceCode != AbsenceCodeId.ABSENCE_WITHOUT_LEAVE) {
		    	            //rs = new HSSFRichTextString(absenceCode.absenceName);
		    	            rs = new XSSFRichTextString(absenceCode.absenceName);
		    		        cell.setCellValue(rs);
		            		break;
		            	}
		            }
		            if (whd.deductionCount > 0) {
		            	if (whd.privateHours == 0) {
		    	            //rs = new HSSFRichTextString("遅刻");
		    	            rs = new XSSFRichTextString("遅刻");
		    		        cell.setCellValue(rs);
		            	} else {
	//	    	            rs = new HSSFRichTextString("私用");
	//	    		        cell.setCellValue(rs);
		            	}
		            }
		            	
			        // 人事欄
		            cell = row.getCell(12);
			        if (whd.deductionCount > 0) cell.setCellValue(whd.deductionCount);
			        // 欠勤区分
		            cell = row.getCell(13);
		            for (MAbsenceCode absenceCode : abscenseCodeList) {
		            	if (absenceCode.absenceCode == whd.absenceCode
		            			&& (whd.absenceCode == AbsenceCodeId.ABSENCE
		            			|| whd.absenceCode == AbsenceCodeId.ABSENCE_WITHOUT_LEAVE)) {
		    	            //rs = new HSSFRichTextString(absenceCode.absenceName);
		    	            rs = new XSSFRichTextString(absenceCode.absenceName);
		    		        cell.setCellValue(rs);
		            		break;
		            	}
		            }
		            // 勤休・遅刻事由・その他
		            cell = row.getCell(14);
		            //rs = new HSSFRichTextString(whd.note);
		            rs = new XSSFRichTextString(whd.note);
			        cell.setCellValue(rs);
			        // 休日出勤
		            cell = row.getCell(19);
		            if (whd.holidayWorkType == 1)
		            {
		            	cell.setCellValue(1);
		            }
		            else if (whd.holidayWorkType == 2)
		            {
		            	cell.setCellValue(0.5);
		            }
		        	
			        // 深夜勤務
		            cell = row.getCell(20);
			        if (whd.nightWorkFlg) cell.setCellValue(1);
			        
		            ridx++;
		        }
		        
		        // 有給繰越日数
		        row = sheet.getRow(37);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.lastPaidVacationCount
		        		+ whm.givenPaidVacationCount - whm.lostCompensatoryDayOffCount);
		        //有給使用日数
		        row = sheet.getRow(38);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.takenPaidVacationCount);
		        //有給今月残日数
		        row = sheet.getRow(39);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.currentPaidVacationCount);
		        
		        // 代休繰越日数
		        row = sheet.getRow(40);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.lastCompensatoryDayOffCount);
		        //代休発生日数
		        row = sheet.getRow(41);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.givenCompensatoryDayOffCount - whm.lostCompensatoryDayOffCount);
		        //代休使用日数
		        row = sheet.getRow(42);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.takenCompensatoryDayOffCount);
		        //代休今月残日数
		        row = sheet.getRow(43);
		        cell = row.getCell(3);
		        cell.setCellValue(whm.currentCompensatoryDayOffCount);
		        
		        // 再計算
		        sheet.setForceFormulaRecalculation(true);
			}
			// テンプレートシートの削除
			wb.removeSheetAt(0);
			
	        // ファイル名の生成
			// 個別出力ならば
			if (staffIds.length == 1) {
				fileName = sheetName;
			} else {
				Calendar cal = Calendar.getInstance();
				cal.set(Integer.parseInt(workingMonthCode.substring(0,4)),
						Integer.parseInt(workingMonthCode.substring(4,6)),
						1, 0, 0, 0);
		        fileName = String.format("%02d期勤務_%s月(全員)",
		        		TermDateUtil.getTerm(cal.getTime())
		        		, workingMonthCode.substring(4,6));
				
			}
            fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
            fileName = new String(fileName.getBytes("Windows-31J"), "ISO-8859-1");
            // HTTPヘッダの設定
            resp.setHeader("Content-Type", "charset=UTF-8");
            resp.setHeader("Content-Disposition",
                "attachment;filename=\"" + fileName + ".xlsx\"");  ////
            resp.setContentType("application/vnd.ms-excel");
            // 応答
            wb.write(resp.getOutputStream());
            resp.getOutputStream().close();
        }catch(Exception e){
            System.out.println(e.toString());
        }
	}

//	private void showPdf(HttpServletRequest req, HttpServletResponse resp)
//	throws ServletException, IOException
//	{
//		// ログイン社員ID
//		int loginStaffId = Integer.parseInt((String)req.getParameter("loginStaffId"));
//		// 勤務月
//		String workingMonthCode = (String)req.getParameter("workingMonthCode");
//		
//		//出力用のStreamをインスタンス化します。
//		ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
//
//		//文書オブジェクトを生成
//		//ページサイズを設定します。
//		Document doc = new Document(PageSize.A4, 50, 50, 50, 50); 
//
//		try {
//			// WorkingHoursServiceオブジェクトの取得
//			WorkingHoursService workingHoursService = SingletonS2Container.getComponent(WorkingHoursService.class);
//			WorkingHoursMonthly whm = workingHoursService.getWorkingHoursMonthly(loginStaffId, workingMonthCode);
//			
//			// 出力先を指定し、文書をPDFとして出力
//			PdfWriter.getInstance(doc, byteOut);
//			// 出力開始
//			doc.open();
//			// 日本語フォントの設定
//			//明朝10pt
//			Font font_m10 =
//			    new Font(BaseFont.createFont("HeiseiMin-W3", "UniJIS-UCS2-HW-H",
//			    BaseFont.NOT_EMBEDDED),10);
//
//			String sHeader = workingMonthCode.substring(0, 4)
//				+ "年" + workingMonthCode.substring(4, 6) + "月度勤務管理表";
//			sHeader = sHeader + " 氏名：" + whm.staffName.fullName;
//			//ヘッダーの設定をします。
//			HeaderFooter header = new HeaderFooter(
//			    new Phrase(sHeader, font_m10), false);
//			header.setAlignment(Element.ALIGN_CENTER);
//			doc.setHeader(header);
//			
//			// 文書に要素を追加
//			doc.add(new Paragraph(sHeader, font_m10));
//		} catch (FileNotFoundException e) {
//			e.printStackTrace();
//		} catch (DocumentException e) {
//			e.printStackTrace();
//		}
//		// 出力終了
//		doc.close();
//	  
//		// ブラウザへの出力
//		resp.setContentType("application/pdf");
//		resp.setContentLength(byteOut.size());
//		OutputStream out = resp.getOutputStream();
//		out.write(byteOut.toByteArray());
//		out.close();
//	}

}