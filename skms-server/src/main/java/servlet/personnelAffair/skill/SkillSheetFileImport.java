package servlet.personnelAffair.skill;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.sql.Timestamp;

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

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
/*
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
*/
//追加
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

//import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.framework.container.SingletonS2Container;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.org.apache.xml.internal.serializer.OutputPropertiesFactory;

import services.generalAffair.entity.MStaff;
import services.personnelAffair.skill.dto.SkillLabelDto;
import services.personnelAffair.skill.dto.StaffSkillSheetDto;
import services.personnelAffair.skill.dto.StaffSkillSheetPhaseDto;
import services.personnelAffair.skill.dto.StaffSkillSheetPositionDto;
import services.personnelAffair.skill.service.SkillSheetEntryService;
import services.personnelAffair.skill.service.SkillSheetService;
import services.project.dto.ProjectDto;
import services.project.dto.ProjectSearchDto;
import services.project.service.ProjectService;
import servlet.ExcelSheet;
import utils.RegexUtil;

/**
 * 業務経歴インポートクラス。
 * 業務経歴ファイルのインポートを扱うアクションです。
 *
 * @author yoshinori-t
 *
 */
public class SkillSheetFileImport extends HttpServlet {

	static final long serialVersionUID = 1L;
	
	/**
	 * 業務経歴ファイルインポート処理。
	 *
	 * @param req  HttpServletRequest HTTPリクエスト
	 * @param resp HttpServletResponse HTTPレスポンス
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{
		// 登録社員ID
		int staffId = Integer.parseInt((String)req.getParameter("staffId"));
		// 管理者モード
		Boolean isManagementMode = Boolean.parseBoolean((String)req.getParameter("isManagementMode"));
		
		try {
			//////////////////////////////////////////////////
			// HTTPレスポンスの準備
			//////////////////////////////////////////////////
			// response の content-type を設定する.
			resp.setContentType("text/xml; charset=UTF-8");
			PrintWriter out = resp.getWriter();
			
			// DOM Documentのインスタンスを生成するBuilderクラスのインスタンスを取得する.
			DocumentBuilderFactory bfactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = bfactory.newDocumentBuilder();
			
			// ビルダーからDOMを取得する
			Document document = builder.newDocument();
			// XMLのルートを設定する.
			Element root = document.createElement("root");
			
			try {
				// マルチパートリクエストでないならば
				if ( !ServletFileUpload.isMultipartContent(req) )
				{
					throw new Exception("不正なリクエストです。");
				}
				
				//////////////////////////////////////////////////
				// ファイルの取得を行う
				//////////////////////////////////////////////////
				// ServletFileUpload を生成する.
				DiskFileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				
				// データを取得する.
				List<FileItem> list = upload.parseRequest(req);
				Iterator<FileItem> iterator = list.iterator();
				
				FileItem item = null;
				while ( iterator.hasNext() )
				{
					item = iterator.next();
					if (item.getName() != null) break;
				}
				
				InputStream fin = null;
//				POIFSFileSystem poi = null;
//				HSSFWorkbook workbook = null;
				//追加
				Workbook workbook = null;
				
				try {
					// アップロードファイルを取得する.
					fin = item.getInputStream();
//					poi = new POIFSFileSystem(fin);
					// ワークブックを読み込む.
//					workbook = new HSSFWorkbook(poi);
					//追加
					workbook = WorkbookFactory.create(fin);
					
					if (workbook == null) throw new Exception("ワークブックの読み込みに失敗");
				}
				catch ( Exception e )
				{
					throw new Exception("正規のスキルシートファイルではありません。");
				}

				//////////////////////////////////////////////////
				// JdbcManagerオブジェクトの取得
				//////////////////////////////////////////////////
				JdbcManager jdbcManager = SingletonS2Container.getComponent(JdbcManager.class);
				
				//////////////////////////////////////////////////
				// シートのエラーチェック
				//////////////////////////////////////////////////
				// 最初のシートのみ処理対象とする.
				int sheetindex = 0;
				
				// シートを読み込む.
//				HSSFSheet sheet = workbook.getSheetAt(sheetindex);
				//追加
				Sheet sheet = workbook.getSheetAt(sheetindex);
				
				ExcelSheet excelSheet = new ExcelSheet(workbook, sheet);
				
				
				
				// 「ＳＫＩＬＬ　ＬＩＳＴ」の文字列を取得する。
				String titleSkillList = excelSheet.getCellValue(1, 1);
				if ( titleSkillList == null || !"ＳＫＩＬＬ　ＬＩＳＴ".equals(titleSkillList) )
				{
					throw new Exception("正規のスキルシートファイルではありません。");
				}
				
				// 「区分」の文字列を取得する。
				String kindCheck = excelSheet.getCellValue(15, 5);
				if ( kindCheck == null || !"区分".equals(kindCheck) )
				{
					throw new Exception("スキルシートファイルのバージョンが異なります。");
				}
				
				// 氏名を取得する。
				String fullName = excelSheet.getCellValue(5, 2);
				
				// 社員マスタから社員情報の取得
				MStaff staff = jdbcManager.from(MStaff.class)
					.innerJoin("staffName",
							"staffName.lastName || staffName.firstName like translate(?, ' 　','')",
							fullName+"%")
					.getSingleResult();
				if ( staff == null )
				{
					String msg = String.format("氏名[%s]が社員マスタに存在しません。", fullName);
					throw new Exception(msg);
				}
				
				// 管理者モードでなく、自分のスキルシート以外ならば
				if ( !isManagementMode && ( staffId != staff.staffId ) )
				{
					throw new Exception("あなたのスキルシートではありません。");
				}
				
				//////////////////////////////////////////////////
				// ProjectService、SkillSheetService、SkillSheetEntryServiceオブジェクトの取得
				//////////////////////////////////////////////////
				ProjectService projectService = SingletonS2Container.getComponent(ProjectService.class);
				SkillSheetService skillSheetService = SingletonS2Container.getComponent(SkillSheetService.class);
				SkillSheetEntryService skillSheetEntryService = SingletonS2Container.getComponent(SkillSheetEntryService.class);
				
				//////////////////////////////////////////////////
				// マスタからプロジェクト情報、作業フェーズ、参加形態のリストを作成しておく
				//////////////////////////////////////////////////
				// プロジェクト情報
				ProjectSearchDto projectSearch = new ProjectSearchDto();
				projectSearch.staffId = staff.staffId;		// 対象社員の所属するプロジェクトのみ検索
				projectSearch.actualStartDateNone = true;	// 開始実績日が未設定でも検索する
				projectSearch.actualFinishDateNone = true;	// 終了実績日が未設定でも検索する
				projectSearch.pmStaffId = -99;				// PMを[-99:指定なし]で検索する
				List<ProjectDto> projectList = projectService.getProjectList(projectSearch);
				if ( projectList.isEmpty() )
				{
					// コンソールにログを出力させるが、処理は継続させる
					String msg = String.format("[%d:%s]の所属するプロジェクトは存在しません。", staff.staffId, fullName);
					System.out.println(msg);
				}
				
				// 作業フェーズ
				List<SkillLabelDto> pheseList = skillSheetEntryService.getProjectPhaseList();
				if ( pheseList.isEmpty() )
				{
					throw new Exception("作業フェーズの検索に失敗しました。");
				}
				
				// 参加形態
				List<SkillLabelDto> positionList = skillSheetEntryService.getProjectPositionList();
				if ( positionList.isEmpty() )
				{
					throw new Exception("参加形態の検索に失敗しました。");
				}
				
				// CT⇒UTの変換の実施
				// 作業フェーズマスタの単体試験のコード値を取得する
				String exchangeUT = "";		// 変換対象のフェーズコード
				String phaseMasterUT = "";	// マスタの単体試験のフェーズコード
				for ( SkillLabelDto checkPhase : pheseList )
				{
					// マスタの値がUTの場合
					if ( "UT".equals(checkPhase.code) )
					{
						exchangeUT = "CT";
						phaseMasterUT = "UT";
						break;
					}
					else if ( "CT".equals(checkPhase.code) )
					{
						exchangeUT = "UT";
						phaseMasterUT = "CT";
						break;
					}
				}
				
				//////////////////////////////////////////////////
				// 現在日付の取得
				//////////////////////////////////////////////////
				Calendar calNow = Calendar.getInstance();
				
				//////////////////////////////////////////////////
				// 一覧の件数分データを取得
				//////////////////////////////////////////////////
				ArrayList<StaffSkillSheetDto> skillSheetList = new ArrayList<StaffSkillSheetDto>();
				// 一覧の件数分ループ
				int rowNo = 16;		// 行番号(一覧の開始行番号をデフォルト値とする)
				int seqNo = 1;		// スキルシート連番
				while ( rowNo < 65536 )		// Excelの最大行数に達したら強制終了
				{
					//////////////////////////////////////////////////
					// 件名が入力されているかどうかを終了判定とする
					//////////////////////////////////////////////////
					String title = excelSheet.getCellValue(rowNo, 2);
					if ( title == null || "".equals(title) ) break;
					
					StaffSkillSheetDto dtoSkillSheet = new StaffSkillSheetDto();
					
					//////////////////////////////////////////////////
					// データ設定
					//////////////////////////////////////////////////
					// 社員ID
					dtoSkillSheet.staffId = staff.staffId;
					// スキルシート連番
					dtoSkillSheet.sequenceNo = seqNo;
					// 登録日時
					dtoSkillSheet.registrationTime = new Timestamp(calNow.getTimeInMillis());
					// 登録者ID
					dtoSkillSheet.registrantId = staffId;
					
					// 件名
					dtoSkillSheet.title = title;
					
					// 区分
					dtoSkillSheet.kindId = excelSheet.getIntCellValue(rowNo, 5);
					
					// 開発期間
					dtoSkillSheet.joinDate = excelSheet.getDateCellValue(rowNo, 6);
					dtoSkillSheet.retireDate = excelSheet.getDateCellValue(rowNo, 9);
					
					// ハード
					dtoSkillSheet.hardware = excelSheet.getCellValue(rowNo, 11);
					
					// OS
					dtoSkillSheet.os = excelSheet.getCellValue(rowNo, 13);
					
					// 言語
					dtoSkillSheet.language = excelSheet.getCellValue(rowNo, 15);

					// キーワード
					dtoSkillSheet.keyword = excelSheet.getCellValue(rowNo, 18);
					
					// 担当した内容
					dtoSkillSheet.content = excelSheet.getCellValue(rowNo, 19);
					
					//////////////////////////////////////////////////
					// データ設定(作業フェーズ)
					//////////////////////////////////////////////////
					String phase = excelSheet.getCellValue(rowNo, 16);
					if ( phase != null && !"".equals(phase) )
					{
						// 取得した作業フェーズを分解してリストに格納
						String[] phaseArray = phase.split("[、, ]");
						List<StaffSkillSheetPhaseDto> dotPhaseList = new ArrayList<StaffSkillSheetPhaseDto>();
						for ( int i = 0; i < phaseArray.length; i++ )
						{
							StaffSkillSheetPhaseDto dtoPhase = new StaffSkillSheetPhaseDto();
							
							// 社員ID
							dtoPhase.staffId = staff.staffId;
							// スキルシート連番
							dtoPhase.sequenceNo = seqNo;
							// 登録日時
							dtoPhase.registrationTime = new Timestamp(calNow.getTimeInMillis());
							// 登録者ID
							dtoPhase.registrantId = staffId;
							
							//////////////////////////////
							// 期間指定をしている場合
							String[] period = phaseArray[i].split("～");
							if ( period.length == 2 )
							{
								String startPhase = period[0];	// 開始作業フェーズコード
								String endPhase = period[1];	// 終了作業フェーズコード
								
								// 旧フォーマットに対応するため、CT⇒UTに変換を行う
								if ( !"".equals(exchangeUT) )
								{
									if ( exchangeUT.equals(startPhase) )
									{
										startPhase = phaseMasterUT;
										System.out.println("["+rowNo+"]" + exchangeUT + "から" + phaseMasterUT + "への変換を実施しました。");
									}
									if ( exchangeUT.equals(endPhase) )
									{
										endPhase = phaseMasterUT;
										System.out.println("["+rowNo+"]" + exchangeUT + "から" + phaseMasterUT + "への変換を実施しました。");
									}
								}
								
								// 作業フェーズID、作業フェーズ名
								List<StaffSkillSheetPhaseDto> dtoPhasePeriodList = new ArrayList<StaffSkillSheetPhaseDto>();
								for ( SkillLabelDto mPhase : pheseList )
								{
									StaffSkillSheetPhaseDto dtoPhasePeriod = new StaffSkillSheetPhaseDto();
									
									// Dtoにデータを設定
									dtoPhasePeriod.staffId = dtoPhase.staffId;
									dtoPhasePeriod.sequenceNo = dtoPhase.sequenceNo;
									dtoPhasePeriod.registrationTime = dtoPhase.registrationTime;
									dtoPhasePeriod.registrantId = dtoPhase.registrantId;
									dtoPhasePeriod.phaseId = Integer.parseInt(mPhase.id);
									dtoPhasePeriod.phaseCode = mPhase.code;
									dtoPhasePeriod.phaseName = mPhase.name;
									
									// 開始作業フェーズコードと一致するデータの場合はリストに追加する
									if ( startPhase.equals(mPhase.code) )
									{
										dtoPhasePeriodList.add(dtoPhasePeriod);
									}
									// リスト追加中の場合は続けて追加する
									else if ( dtoPhasePeriodList.size() > 0 )
									{
										dtoPhasePeriodList.add(dtoPhasePeriod);
										
										// 終了作業フェーズコードと一致するデータの場合
										if ( endPhase.equals(mPhase.code) )
										{
											// リスト件数分、作業フェーズリストにデータを追加
											String debugPhase = "";
											for ( StaffSkillSheetPhaseDto dtoTemp : dtoPhasePeriodList )
											{
												dotPhaseList.add(dtoTemp);
												debugPhase += dtoTemp.phaseCode + " ";
											}
											
											System.out.println("["+rowNo+"]" + "作業フェーズで指定した期間を分解しました。");
											System.out.println("["+rowNo+"]" + phaseArray[i] + "⇒" + debugPhase.trim());
											
											// データ追加後はリストをnullに変更する
											// ※nullの場合に正常終了と判断する
											dtoPhasePeriodList.clear();
											dtoPhasePeriodList = null;
											break;
										}
									}
								}
								
								// 異常終了した場合
								if ( dtoPhasePeriodList != null )
								{
									// 開始作業フェーズIDがnullの場合は異常終了
									if ( dtoPhasePeriodList.size() == 0 )
									{
										String msg = String.format("作業フェーズ[%s]は存在しません。", startPhase);
										throw new Exception(msg);
									}
									// 終了作業フェーズIDがnullの場合は異常終了
									else
									{
										String msg = String.format("作業フェーズ[%s]は存在しません。", endPhase);
										throw new Exception(msg);
									}
								}
							}
							//////////////////////////////
							// 期間指定をしていない場合
							else
							{
								// 作業フェーズコード
								dtoPhase.phaseCode = phaseArray[i];
								
								// 旧フォーマットに対応するため、CT⇒UTに変換を行う
								if ( !"".equals(exchangeUT) )
								{
									if ( exchangeUT.equals(dtoPhase.phaseCode) )
									{
										dtoPhase.phaseCode = phaseMasterUT;
										System.out.println("["+rowNo+"]" + exchangeUT + "から" + phaseMasterUT + "への変換を実施しました。");
									}
								}
								
								// 作業フェーズID、作業フェーズ名
								for ( SkillLabelDto mPhase : pheseList )
								{
									// 作業フェーズコードと一致するデータの場合は
									// 作業フェーズID、作業フェーズ名を格納してループを抜ける
									if ( dtoPhase.phaseCode.equals(mPhase.code) )
									{
										dtoPhase.phaseId = Integer.parseInt(mPhase.id);
										dtoPhase.phaseName = mPhase.name;
										break;
									}
								}
								
								// 作業フェーズIDがnullの場合は異常終了
								if ( dtoPhase.phaseId == null )
								{
									String msg = String.format("作業フェーズ[%s]は存在しません。", dtoPhase.phaseCode);
									throw new Exception(msg);
								}
								
								// 作業フェーズリストにデータを追加
								dotPhaseList.add(dtoPhase);
							}
						}
						
						// 作成した作業フェーズリストを設定
						dtoSkillSheet.staffSkillSheetPhaseList = dotPhaseList;
					}
					
					//////////////////////////////////////////////////
					// データ設定(参加形態)
					//////////////////////////////////////////////////
					String position = excelSheet.getCellValue(rowNo, 17);
					if ( position != null && !"".equals(position) )
					{
						// 取得した参加形態を分解してリストに格納
						String[] positionArray = position.split("[、, ]");
						List<StaffSkillSheetPositionDto> dotPositionList = new ArrayList<StaffSkillSheetPositionDto>();
						for ( int i = 0; i < positionArray.length; i++ )
						{
							StaffSkillSheetPositionDto dtoPosition = new StaffSkillSheetPositionDto();
							
							// 社員ID
							dtoPosition.staffId = staff.staffId;
							// スキルシート連番
							dtoPosition.sequenceNo = seqNo;
							// 登録日時
							dtoPosition.registrationTime = new Timestamp(calNow.getTimeInMillis());
							// 登録者ID
							dtoPosition.registrantId = staffId;
							
							// 参加形態コード
							dtoPosition.positionCode = positionArray[i];
							
							// 参加形態ID、参加形態名
							for ( SkillLabelDto mPosition : positionList )
							{
								// 参加形態コードと一致するデータの場合は
								// 参加形態ID、参加形態名を格納してループを抜ける
								if ( dtoPosition.positionCode.equals(mPosition.code) )
								{
									dtoPosition.positionId = Integer.parseInt(mPosition.id);
									dtoPosition.positionName = mPosition.name;
									break;
								}
							}
							
							// 参加形態IDがnullの場合は異常終了
							if ( dtoPosition.positionId == null )
							{
								String msg = String.format("参加形態[%s]は存在しません。", dtoPosition.positionCode);
								throw new Exception(msg);
							}
							
							// 参加形態リストにデータを追加
							dotPositionList.add(dtoPosition);
						}
						
						// 作成した参加形態リストを設定
						dtoSkillSheet.staffSkillSheetPositionList = dotPositionList;
					}
						
					//////////////////////////////////////////////////
					// データ設定(プロジェクトID、プロジェクトコード、プロジェクト名)
					//////////////////////////////////////////////////
					if ( dtoSkillSheet.title != null && !"".equals(dtoSkillSheet.title) )
					{
						// プロジェクト名のデフォルトを件名とする
						dtoSkillSheet.projectName = dtoSkillSheet.title;
						
						// 対象社員の所属するプロジェクトが存在する場合
						if ( !projectList.isEmpty() )
						{
							// 参加形態ID、参加形態名
							for ( ProjectDto mProject : projectList )
							{
								// プロジェクト名が完全一致の場合はDtoにデータを格納してループを抜ける
								if ( dtoSkillSheet.projectName.equals(mProject.projectName) )
								{
									dtoSkillSheet.projectId = mProject.projectId;
									dtoSkillSheet.projectCode = mProject.projectCode;
									dtoSkillSheet.projectName = mProject.projectName;
									
									System.out.println("["+rowNo+"]" + "完全一致のプロジェクト名を発見しました。");
									System.out.println("["+rowNo+"]" + "プロジェクトID    #" + mProject.projectId);
									System.out.println("["+rowNo+"]" + "プロジェクトコード#" + mProject.projectCode);
									System.out.println("["+rowNo+"]" + "プロジェクト名    #" + mProject.projectName);
									break;
								}
								
								// プロジェクト名が部分一致の場合はDtoにデータを格納しておく
								if ( mProject.projectName != null && !"".equals(mProject.projectName) )
								{
									// 件名を元に検索を実行する
									String regex = dtoSkillSheet.title;
									
									// メタ文字に「￥」を付加する
									regex = RegexUtil.replaceMetaWord(regex);
									
									// 部分一致の検索を実行する
									regex = ".*" + regex + ".*";
									if ( mProject.projectName.matches(regex) )
									{
										dtoSkillSheet.projectId = mProject.projectId;
										dtoSkillSheet.projectCode = mProject.projectCode;
										dtoSkillSheet.projectName = mProject.projectName;
										
										System.out.println("["+rowNo+"]" + "部分一致のプロジェクト名を発見しました。");
										System.out.println("["+rowNo+"]" + "プロジェクト名[" + dtoSkillSheet.title + "]で検索。");
										System.out.println("["+rowNo+"]" + "プロジェクトID    #" + mProject.projectId);
										System.out.println("["+rowNo+"]" + "プロジェクトコード#" + mProject.projectCode);
										System.out.println("["+rowNo+"]" + "プロジェクト名    #" + mProject.projectName);
									}
								}
							}
						}
					}
					
					// リストにデータを追加
					skillSheetList.add(dtoSkillSheet);
					
					// 行番号のインクリメント
					rowNo++;
					
					// スキルシート連番のインクリメント
					seqNo++;
				}
				
				// 1件もデータが無い場合
				if ( skillSheetList.isEmpty() )
				{
					throw new Exception("インポートするスキルシート情報が存在しません。");
				}
				
				//////////////////////////////////////////////////
				// スキルシートの更新を行う
				//////////////////////////////////////////////////
				skillSheetService.updateSkillSheetList( staff.staffId, skillSheetList, staffId );
				
				//////////////////////////////////////////////////
				// 成功時の応答
				//////////////////////////////////////////////////
				// タグを追加する.
				Element element = document.createElement("result");
				element.setTextContent("0");
				root.appendChild(element);
			}
			catch ( Exception e )
			{
				e.printStackTrace();	// 念のためトレース
				
				//////////////////////////////////////////////////
				// 失敗時の応答
				//////////////////////////////////////////////////
				// 結果タグを追加する.
				Element result = document.createElement("result");
				result.setTextContent("-1");
				root.appendChild(result);
				// メッセージタグを追加する.
				result = document.createElement("message");
				result.setTextContent(e.getMessage());
				root.appendChild(result);
				return;
			}
			finally
			{
				//////////////////////////////////////////////////
				// 応答
				//////////////////////////////////////////////////
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
				}
				catch( Exception e ) {
					ServletException srve = new ServletException(e.getMessage(), e.getCause());
					throw srve;
				}
			}
		}
		catch ( Exception e )
		{
			e.printStackTrace();	// 念のためトレース
			
			ServletException srve = new ServletException(e.getMessage(), e.getCause());
			throw srve;
		}
	}
}
