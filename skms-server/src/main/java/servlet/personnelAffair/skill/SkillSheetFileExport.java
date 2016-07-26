package servlet.personnelAffair.skill;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/*
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
*/
//追加
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

//import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.seasar.framework.container.SingletonS2Container;

import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.dto.StaffDto;
import services.personnelAffair.skill.dto.StaffOtherLocenceDto;
import services.personnelAffair.skill.dto.StaffSkillSheetDto;
import services.personnelAffair.skill.dto.StaffSkillSheetPhaseDto;
import services.personnelAffair.skill.dto.StaffSkillSheetPositionDto;
import services.personnelAffair.skill.service.SkillSheetService;
import servlet.ExcelSheet;

/**
 * 業務経歴エクスポートクラス。
 * 業務経歴ファイルのエクスポートを扱うアクションです。
 *
 * @author yoshinori-t
 *
 */
public class SkillSheetFileExport extends HttpServlet {

	static final long serialVersionUID = 1L;
	
	/**
	 * デフォルト一覧件数
	 */
	private static final int DEFAULT_ROW_COUNT = 20;
	
	/**
	 * コピー元行番号
	 */
	private static final int COPYBASE_ROW = 16;
	
	
	/**
	 * 業務経歴ファイルエクスポート処理。
	 *
	 * @param req  HttpServletRequest HTTPリクエスト
	 * @param resp HttpServletResponse HTTPレスポンス
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{
		// 対象社員IDのリスト
		String[] staffIds = ((String)req.getParameter("staffId")).split(",");

		//////////////////////////////////////////////////
		// ClassCastException回避のためのダミー
		//////////////////////////////////////////////////
		////////////////////
		// StaffDto
		StaffDto dummy = new StaffDto();
		// .staffAuthorizedLicence
		StaffAuthorizedLicenceDto dummyAuthorized = new StaffAuthorizedLicenceDto();
		List<StaffAuthorizedLicenceDto> dummyAuthorizedList = new ArrayList<StaffAuthorizedLicenceDto>();
		dummyAuthorizedList.add(dummyAuthorized);
		dummy.staffAuthorizedLicence = dummyAuthorizedList;
		// .staffOtherLocence
		StaffOtherLocenceDto dummyOther = new StaffOtherLocenceDto();
		List<StaffOtherLocenceDto> dummyOtherList = new ArrayList<StaffOtherLocenceDto>();
		dummyOtherList.add(dummyOther);
		dummy.staffOtherLocence = dummyOtherList;
		
		////////////////////
		// StaffSkillSheetDto
		StaffSkillSheetDto dummySkill = new StaffSkillSheetDto();
		// .staffSkillSheetPhaseList
		StaffSkillSheetPhaseDto dummyPhase = new StaffSkillSheetPhaseDto();
		List<StaffSkillSheetPhaseDto> dummyPhaseList = new ArrayList<StaffSkillSheetPhaseDto>();
		dummyPhaseList.add(dummyPhase);
		dummySkill.staffSkillSheetPhaseList = dummyPhaseList;
		// .staffSkillSheetPositionList
		StaffSkillSheetPositionDto dummyPosition = new StaffSkillSheetPositionDto();
		List<StaffSkillSheetPositionDto> dummyPositionList = new ArrayList<StaffSkillSheetPositionDto>();
		dummyPositionList.add(dummyPosition);
		dummySkill.staffSkillSheetPositionList = dummyPositionList;
		
        try {
			//////////////////////////////////////////////////
			// SkillSheetServiceオブジェクトの取得
			//////////////////////////////////////////////////
			SkillSheetService skillSheetService = SingletonS2Container.getComponent(SkillSheetService.class);
    		
			//////////////////////////////////////////////////
			// 現在日付の取得
			//////////////////////////////////////////////////
			Calendar calNow = Calendar.getInstance();
			
			//////////////////////////////////////////////////
	        //Excelのワークブックを読み込みます。
			//////////////////////////////////////////////////
//			POIFSFileSystem filein = new POIFSFileSystem
//				(new FileInputStream("/skmstemplate/SkillSheetList.xls"));
			//追加
			FileInputStream filein = new FileInputStream("/skmstemplate/SkillSheetList.xlsx");
			
//			HSSFWorkbook workbook = new HSSFWorkbook(filein);
			//追加
			Workbook workbook = WorkbookFactory.create(filein);
			
			String fileName = "";
			String sheetName = "";
			
			//////////////////////////////////////////////////
			// 社員ID数分ループ
			//////////////////////////////////////////////////
			String mainStaff = null;	// メイン社員(ファイル名に使用)
			int exportCount = 0;		// エクスポート数
			for (int i = 0; i < staffIds.length; i++)
			{
				//////////////////////////////////////////////////
				// データの取得
				//////////////////////////////////////////////////
				int staffId = Integer.parseInt(staffIds[i]);	// 社員ID
				// 社員詳細の取得
				List<StaffDto> staffDetailList = skillSheetService.getStaffDetail(staffId);
				if ( staffDetailList == null || staffDetailList.size() < 1 )
				{
					System.out.println("社員ID["+staffId+"]の社員詳細が見つかりませんでしたが、処理を継続します。");
					continue;
				}
				StaffDto staffDetail = staffDetailList.get(0);
				// スキルシートリストの取得
				List<StaffSkillSheetDto> skillSheetList = skillSheetService.getStaffSkillList(staffId);
				
				// テンプレートを複製します。
//				HSSFSheet sheet;
				//追加
				Sheet sheet;
				
				sheet = workbook.cloneSheet(0);
				ExcelSheet excelSeet = new ExcelSheet(workbook, sheet);
				
				// シート名の生成
				String spaceTrimedFullName = staffDetail.fullName.replaceAll(" ", "");	// スペースを削除した氏名
				sheetName = String.format("%s", spaceTrimedFullName);
				workbook.setSheetName(i+1, sheetName);
				
				//////////////////////////////////////////////////
				// データの設定(ヘッダ)
				//////////////////////////////////////////////////
				//////////
				// 2行目
				// 入力日
				excelSeet.setCellValue(2, 20, calNow.getTime(), "yy/mm/dd");
				
				//////////
				// 4行目
				// 生年月日
				excelSeet.setCellValue(4, 9, staffDetail.birthday, "yy/mm/dd");
				
				//////////
				// 5行目
				// No
				excelSeet.setCellValue(5, 1, staffDetail.staffId);
				// 氏名
				excelSeet.setCellValue(5, 2, staffDetail.fullName);
				// 性別
				excelSeet.setCellValue(5, 5, staffDetail.sex);
				// 入社日
				excelSeet.setCellValue(5, 9, staffDetail.occuredDate, "yy/mm/dd");
				// 経験年数
				excelSeet.setCellValue(5, 13, staffDetail.experienceYears);
				// 役職
				excelSeet.setCellValue(5, 15, staffDetail.managerialPositionName);
				// 職種
				excelSeet.setCellValue(5, 16, staffDetail.occupationalCategoryName);
				// 所属部署
				excelSeet.setCellValue(5, 17, staffDetail.departmentName);
				// 最終学歴
				excelSeet.setCellValue(5, 18, staffDetail.finalAcademicBackground);
				
				//////////
				// 7行目
				// 取得資格
				String authorizedLicenceName = "";
				if ( staffDetail.staffAuthorizedLicence != null )
				{
					for ( StaffAuthorizedLicenceDto dto : staffDetail.staffAuthorizedLicence )
					{
						if ( !"".equals(authorizedLicenceName) ) authorizedLicenceName += "、";
						authorizedLicenceName += dto.licenceName;
					}
				}
				excelSeet.setCellValue(7, 5, authorizedLicenceName);
				
				//////////
				// 8行目
				// 取得免許
				String otherLicenceName = "";
				if ( staffDetail.staffOtherLocence != null )
				{
					for ( StaffOtherLocenceDto dto : staffDetail.staffOtherLocence )
					{
						if ( !"".equals(otherLicenceName) ) otherLicenceName += "、";
						otherLicenceName += dto.licenceName;
					}
				}
				excelSeet.setCellValue(8, 5, otherLicenceName);
				
				//////////////////////////////////////////////////
				// データの設定(一覧)
				//////////////////////////////////////////////////
				if ( skillSheetList != null )
				{
					// スキルシートリストの数に応じて行の追加を行う
					int skillSheetCount = skillSheetList.size();
					if ( skillSheetCount > DEFAULT_ROW_COUNT )
					{
						// 足りない行を追加する
						for ( int j = DEFAULT_ROW_COUNT; j < skillSheetCount; j++)
						{
							// 行の挿入(1行下の行に挿入)
							excelSeet.insertRowSingle(COPYBASE_ROW + 1);
							
							// 行のコピー(1行下の行にコピー)
							excelSeet.copyRowSingle(COPYBASE_ROW, COPYBASE_ROW + 1);
						}
					}
					
					// スキルシートリスト数分ループ
					for ( int j = 0; j < skillSheetList.size(); j++ )
					{
						StaffSkillSheetDto dto = skillSheetList.get(j);
						//////////
						// 16+j行目
						// No
						excelSeet.setCellValue(COPYBASE_ROW + j, 1, dto.sequenceNo);
						// 件名(プロジェクト名)
						String title = dto.projectName;
						if ( title == null || "".equals(title) ) title = dto.title;
						excelSeet.setCellValue(COPYBASE_ROW + j, 2, title);
						// 区分
						excelSeet.setCellValue(COPYBASE_ROW + j, 5, dto.kindId);
						// 開発期間
						excelSeet.setCellValue(COPYBASE_ROW + j, 6, dto.joinDate, "yy/mm");
						excelSeet.setCellValue(COPYBASE_ROW + j, 8, "～");
						excelSeet.setCellValue(COPYBASE_ROW + j, 9, dto.retireDate, "yy/mm");
						// ハード
						excelSeet.setCellValue(COPYBASE_ROW + j, 11, dto.hardware);
						// OS
						excelSeet.setCellValue(COPYBASE_ROW + j, 13, dto.os);
						// 言語
						excelSeet.setCellValue(COPYBASE_ROW + j, 15, dto.language);
						// 作業フェーズ
						String phase = "";
						if ( dto.staffSkillSheetPhaseList != null )
						{
							for ( StaffSkillSheetPhaseDto dtoPhase : dto.staffSkillSheetPhaseList)
							{
								if ( !"".equals(phase) ) phase += "、";
								phase += dtoPhase.phaseCode;
							}
						}
						excelSeet.setCellValue(COPYBASE_ROW + j, 16, phase);
						// 参加形態
						String position = "";
						if ( dto.staffSkillSheetPositionList != null )
						{
							for ( StaffSkillSheetPositionDto dtoPosition : dto.staffSkillSheetPositionList)
							{
								if ( !"".equals(position) ) position += "、";
								position += dtoPosition.positionCode;
							}
						}
						excelSeet.setCellValue(COPYBASE_ROW + j, 17, position);
						// キーワード
						excelSeet.setCellValue(COPYBASE_ROW + j, 18, dto.keyword);
						// 担当した内容
						excelSeet.setCellValue(COPYBASE_ROW + j, 19, dto.content);
					}
				}
				
				// 再計算
				excelSeet.setForceFormulaRecalculation(true);
				
				// メイン社員を更新する
				if ( mainStaff == null ) mainStaff = spaceTrimedFullName;
				
				// エクスポート数のインクリメント
				exportCount++;
			}
			
			// エクスポートを1件も出来なかった場合はエラー
			if ( exportCount == 0 )
			{
				throw new Exception("エクスポートに失敗しました。");
			}
			
			//////////////////////////////////////////////////
			// テンプレートシートの削除
			//////////////////////////////////////////////////
			workbook.removeSheetAt(0);
    		
			//////////////////////////////////////////////////
			// ファイル名の生成
			//////////////////////////////////////////////////
			if ( exportCount > 1 ) mainStaff = "全員";
			fileName = String.format("業務スキルシート（%s）%04d-%02d",
										mainStaff,
										calNow.get(Calendar.YEAR),
										calNow.get(Calendar.MONTH));
			
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
			fileName = new String(fileName.getBytes("Windows-31J"), "ISO-8859-1");
			
			//////////////////////////////////////////////////
			// HTTPヘッダの設定
			//////////////////////////////////////////////////
			resp.setHeader("Content-Type", "charset=UTF-8");
			resp.setHeader("Content-Disposition",
				"attachment;filename=\"" + fileName + ".xlsx\"");
			resp.setContentType("application/vnd.ms-excel");
			
			//////////////////////////////////////////////////
			// 応答
			//////////////////////////////////////////////////
			workbook.write(resp.getOutputStream());
			resp.getOutputStream().close();
		}
        catch(Exception e) {
			e.printStackTrace();	// 念のためトレース
			
			ServletException srve = new ServletException(e.getMessage(), e.getCause());
			throw srve;
		}
	}
}
