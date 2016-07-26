package servlet.customer;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.lang.StringUtils;

//import org.apache.poi.hssf.usermodel.HSSFCell;
//import org.apache.poi.hssf.usermodel.HSSFCellStyle;
//import org.apache.poi.hssf.usermodel.HSSFRichTextString;
//import org.apache.poi.hssf.usermodel.HSSFRow;
//import org.apache.poi.hssf.usermodel.HSSFSheet;
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;

//追加 @auther watanuki-y
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import org.seasar.framework.util.FileOutputStreamUtil;
import org.seasar.framework.util.InputStreamUtil;
import org.seasar.framework.util.OutputStreamUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;


import flex.messaging.util.URLEncoder;

import servlet.ExcelCell;


/**
 * 取引先ファイルダウンロードを扱うアクションです。

 *
 * @author yasuo-k
 *
 */
public class CustomerFileDownload extends HttpServlet {

	static final long serialVersionUID = 1L;

	/**
	 * ファイルダウンロード.
	 *
	 * @param req  HttpServletRequest
	 * @param resp HttpServletResponse
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{
		//// TODO 自動生成されたメソッド・スタブ

		//super.doGet(req, resp);

		// 出力ファイルに名前をつける.
		Calendar fileTime = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String filename = CustomerFile.CUSTOMER_EXCEL_PREFIX + CustomerFile.CUSTOMER_EXCEL_DELIM + sdf.format(fileTime.getTime()) + CustomerFile.CUSTOMER_EXCEL_SUFFIX;

		// response に content-type を設定する.
		resp.setContentType("application/octet-stream");
		resp.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(filename, "UTF-8") + "\"");


		// ダウンロードファイル作成用変数.
		FileOutputStream outStream   = null;
		InputStream inputResorce     = null;
		InputStream inputExcel       = null;

		// response 設定用変数.
		BufferedInputStream ins = null;
		ServletOutputStream ous = null;

		try {
			// response に設定するダウンロードファイルを作成する.

			/* 出力ストリームを設定する。*/
			File outFile = new File(CustomerFile.FILE_PATH, filename);
			outStream  = FileOutputStreamUtil.create(outFile);

			// 新規ファイルを作成する.
//			HSSFWorkbook wb = new HSSFWorkbook();
			//追加
			//Workbook wb = WorkbookFactory.create(outFile);
			Workbook wb = new XSSFWorkbook();

			// request からパラメータを取得する.
			String xml  = (String)req.getParameter("xml");
			DocumentBuilderFactory dbfactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docbuilder = dbfactory.newDocumentBuilder();
			Document document = docbuilder.parse(new ByteArrayInputStream(xml.getBytes("UTF-8")));
			// ルートを取得する.
			Element root = document.getDocumentElement();

			// 取引先xmlリストを取得する.
			NodeList customerList = root.getElementsByTagName("customer");
			for (int index = 0; index < customerList.getLength(); index++) {

				// 取引先xmを取得する.
				Element customerXml = (Element)customerList.item(index);

				// シートを作成する.
//				HSSFSheet sheet = wb.createSheet(getSheetName(customerXml, index));
				//追加
				Sheet sheet = wb.createSheet(getSheetName(customerXml, index));
				

				/* -----------------------------> 顧客情報の書き込み.      */
				// タイトルを書き込む.
//				HSSFRow  rowc = sheet.createRow(CustomerFile.getRow_titleCustomer());
//				HSSFCell cellc= rowc.createCell((short)CustomerFile.getCol_titleCustomer());
				//追加
				Row rowc = sheet.createRow(CustomerFile.getRow_titleCustomer());
				Cell cellc = rowc.createCell((short)CustomerFile.getCol_titleCustomer());

//				cellc.setCellValue(new HSSFRichTextString(CustomerFile.getTitleCustomer()));
				//追加
				cellc.setCellValue(CustomerFile.getTitleCustomer());
				
				cellc.setCellStyle(ExcelCell.createCellStyle_title(wb));

				// データを書き込む.
				List<Object[]> defList = CustomerFile.getDefineCustomer();
				int startindex = CustomerFile.getRow_dataCustomer();
				for (int rowindex = 0; rowindex < defList.size(); rowindex++) {

					// 行・セルスタイルを作成する.
//					HSSFRow row = sheet.createRow(startindex + rowindex);
//					HSSFCellStyle style = ExcelCell.createCellStyle_border(wb);
					//追加
					Row row = sheet.createRow(startindex + rowindex);
					CellStyle style = ExcelCell.createCellStyle_border(wb);
					

					// 項目名・タグ名を取得する.
					String kou = (String)defList.get(rowindex)[0];
					String tag = (String)defList.get(rowindex)[1];

					// 項目セルを設定する.
//					HSSFCell cellKou = row.createCell((short)CustomerFile.getCol_dataCustomer());
					//追加
					Cell cellKou = row.createCell((short)CustomerFile.getCol_dataCustomer());
					cellKou.setCellStyle(style);
//					cellKou.setCellValue(new HSSFRichTextString(kou));
					//追加
					cellKou.setCellValue(kou);
					

					// データセルを作成する.
//					HSSFCell cellVal = row.createCell((short)(CustomerFile.getCol_dataCustomer() + 1));
					//追加
					Cell cellVal = row.createCell((short)(CustomerFile.getCol_dataCustomer() + 1));
					
					cellVal.setCellStyle(style);
					String val = getFirstChildren(customerXml, tag);
					if (val == null)	val = "";
//					cellVal.setCellValue(new HSSFRichTextString(val));
					//追加
					cellVal.setCellValue(val);
				}
				/* <----------------------------- 顧客情報の書き込み終了.  */


				/* -----------------------------> 担当者情報の書き込み.      */
				// 担当者xmlリストを取得する.
				NodeList memberList = customerXml.getElementsByTagName("member");

				List<Object[]> defList2 = CustomerFile.getDefineMember();
				//タイトルを書き込む
				Row rowm = sheet.createRow(CustomerFile.getRow_titleMember());
				Cell cellm = rowm.createCell((short)CustomerFile.getCol_titleMember());
				
				cellm.setCellValue(CustomerFile.getTitleMember());
				cellm.setCellStyle(ExcelCell.createCellStyle_title(wb));
				
				//担当者情報を書き込む
				startindex = CustomerFile.getRow_dataMember();
				
				for(int rowindex=0; rowindex < defList2.size(); rowindex++)
				{
					//行・セルスタイルを作成する
					Row row = sheet.createRow(startindex + rowindex);
					CellStyle style = ExcelCell.createCellStyle_border(wb);
					
					//項目名・タグ名を取得する
					String kou = (String)defList2.get(rowindex)[0];
					String tag = (String)defList2.get(rowindex)[1];
					
					//項目セルを設定する
					Cell cellKou = row.createCell((short)CustomerFile.getCol_dataMember());
					cellKou.setCellStyle(style);
					cellKou.setCellValue(kou);
					
					for(int colindex=0; colindex < memberList.getLength(); colindex++)
					{
						//データセルを作成する
						Cell cellVal = row.createCell((short)(CustomerFile.getCol_dataMember() + 1 + colindex));
						cellVal.setCellStyle(style);
						
						//担当者xmlを取得し、データセルに格納
						String val = getFirstChildren((Element)memberList.item(colindex), tag);
						if(val == null)	val = "";
						cellVal.setCellValue(val);
					}
				}
				
/*				for (int colindex = 0; colindex < memberList.getLength(); colindex++) {
					// タイトルを書き込む.
					if (colindex == 0) {
//						HSSFRow  rowm = sheet.createRow(CustomerFile.getRow_titleMember());
//						HSSFCell cellm= rowm.createCell((short)CustomerFile.getCol_titleMember());
//						cellm.setCellValue(new HSSFRichTextString(CustomerFile.getTitleMember()));
						//追加
						Row rowm = sheet.createRow(CustomerFile.getRow_titleMember());
						Cell cellm = rowm.createCell((short)CustomerFile.getCol_titleMember());
						cellm.setCellValue(CustomerFile.getTitleMember());
						
						cellm.setCellStyle(ExcelCell.createCellStyle_title(wb));
					}

					// 担当者xmlを取得する.
					Element memberXml = (Element)memberList.item(colindex);

					// 担当者情報を書き込む.
					startindex = CustomerFile.getRow_dataMember();
					for (int rowindex = 0; rowindex < defList2.size(); rowindex++) {
						
							
						// 行・セルスタイルを作成する.
//						HSSFRow row = sheet.createRow(startindex + rowindex);
//						HSSFCellStyle style = ExcelCell.createCellStyle_border(wb);
						//追加
						Row row = sheet.createRow(startindex + rowindex);
						CellStyle style = ExcelCell.createCellStyle_border(wb);
						

						// 項目名・タグ名を取得する.
						String kou = (String)defList2.get(rowindex)[0];
						String tag = (String)defList2.get(rowindex)[1];

						// 項目セルを設定する.
//						HSSFCell cellKou = row.createCell((short)CustomerFile.getCol_dataMember());
						//追加
						Cell cellKou = row.createCell((short)CustomerFile.getCol_dataMember());
						
						cellKou.setCellStyle(style);
//						cellKou.setCellValue(new HSSFRichTextString(kou));
						//追加
						cellKou.setCellValue(kou);

						// データセルを作成する.
//						HSSFCell cellVal = row.createCell((short)(CustomerFile.getCol_dataMember() + 1 + colindex));
						//追加
						Cell cellVal = row.createCell((short)(CustomerFile.getCol_dataMember() + 1 + colindex));

							
						cellVal.setCellStyle(style);
						String val = getFirstChildren(memberXml, tag);
						if (val == null)	val = "";
//						cellVal.setCellValue(new HSSFRichTextString(val));
						//追加
						cellVal.setCellValue(val);
						
						
						System.out.println("rowindex= " + rowindex + " colindex= " + colindex);
					}
				}
*/				
				/* <----------------------------- 担当者報の書き込み終了.  */
	
				
				// 列幅を文字数に応じて設定する.
				int maxcol = CustomerFile.getCol_titleCustomer() + (memberList.getLength() > 0 ? memberList.getLength() : 1);
				int maxrow = CustomerFile.getRow_dataMember() + defList2.size();
				for (int colindex = CustomerFile.getCol_titleCustomer(); colindex <= maxcol; colindex++) {
					int maxlen = 30;
					// 列の最大文字数を取得する.
					for (int rowindex = CustomerFile.getCol_titleCustomer(); rowindex < maxrow; rowindex++){
//						HSSFRow row  = sheet.getRow(rowindex);
						//追加
						Row row = sheet.getRow(rowindex);
						
						if (row == null)	continue;
//						HSSFCell cell = row.getCell((short)colindex);
						//追加
						Cell cell = row.getCell((short)colindex);
						
						if (cell == null)	continue;
						String str = ExcelCell.convert2(cell);
						if (str == null)	continue;
						if (maxlen < str.length())	maxlen = str.length();
						
					//	System.out.println("rowindex= " + rowindex + " colindex= " + colindex);
					}
					// 列幅を設定する.
					int width = 256 * maxlen;
					sheet.setColumnWidth((short)colindex, (short)width);
					//System.out.print("col[" + colindex + "]" + " " + "length:"+ maxlen + " " + "width:" + width +"\n");
				}
			}
			// ワークブックを保存する.
			wb.write(outStream);


			// response にダウンロードファイルを設定する.
			File file = new File(CustomerFile.FILE_PATH, filename);
			ins = new BufferedInputStream(new FileInputStream(file));
			ous = resp.getOutputStream();
			int size;
			byte buffer[]  = new byte[4096];
			while((size = ins.read(buffer))!=-1) {
				ous.write(buffer,0, size);
			}
		}
		catch (IOException e) {
			throw e;
		}
		catch (Exception e) {
			ServletException srve = new ServletException(e.getMessage(), e.getCause());
			throw srve;
		}
		finally {
			// ダウンロードファイルは response に使用していて削除できないため古いファイルを削除する.
			File dir = new File(CustomerFile.FILE_PATH);
			File[] filelist = dir.listFiles();
			for (File file : filelist) {
				long filetime = file.lastModified();
				long nowtime  = Calendar.getInstance().getTime().getTime();
				long difftime = nowtime - filetime;
				// 2日以上経過したら削除する.
				if (difftime >  2* 24 * 60 * 60 * 1000) 	file.delete();
			}

			// ファイルストリームを close する.
			OutputStreamUtil.flush(outStream);
			OutputStreamUtil.close(outStream);
			InputStreamUtil.close(inputResorce);
			InputStreamUtil.close(inputExcel);

			// response ストリームを close する.
			InputStreamUtil.close(ins);
			// out は コンテナが閉じるときに close される.
		}
	}


	  /**
	   * 指定されたエレメントから子要素の内容を取得.
	   *
	   * @param   element 指定エレメント.
	   * @param   tagName 指定タグ名.
	   * @return  取得した内容.
	   */
	  private static String getFirstChildren(Element element, String tagName)
	  {
		  return getChildren(element, tagName, 0);
	  }

//	  /**
//	   * 指定されたエレメントから子要素の内容を取得.
//	   *
//	   * @param   element 指定エレメント.
//	   * @param   tagName 指定タグ名.
//	   * @return  取得した内容.
//	   */
//	  private static String getIndexChildren(Element element, String tagName, int index)
//	  {
//		  return getChildren(element, tagName, index);
//	  }

	  /**
	   * 指定されたエレメントから子要素の内容を取得.
	   *
	   * @param   element 指定エレメント.
	   * @param   tagName 指定タグ名.
	   * @return  取得した内容.
	   */
	  private static String getChildren(Element element, String tagName, int index)
	  {
	    NodeList list = element.getElementsByTagName(tagName);
	    Element cElement = (Element)list.item(index);
	    if (cElement == null)	return null;
	    if (cElement.getFirstChild() == null)	return null;
	    return  cElement.getFirstChild().getNodeValue();
	  }


	  /**
	   * シート名の作成.
	   *
	   * @param element 取引先エレメント.
	   * @param index   取引先Index.
	   * @return シート名.
	   */
	  private static String getSheetName(Element element, int index)
	  {
		  String sheetname = "";
		  String ccode = getFirstChildren(element, "customerCode");
		  String cname = getFirstChildren(element, "customerName");
		  if (ccode != null && StringUtils.trim(ccode).length() > 0) {
			  sheetname += ccode;
		  }
		  if (cname != null && StringUtils.trim(cname).length() > 0) {
			  if (sheetname.length() > 0)	sheetname += " ";
			  sheetname += cname;
		  }

		  // "「/\*?[]」は "" に置き換える.
		  sheetname = sheetname.replace("/", "");
		  sheetname = sheetname.replace("\\", "");
		  sheetname = sheetname.replace("*", "");
		  sheetname = sheetname.replace("?", "");
		  sheetname = sheetname.replace("[", "");
		  sheetname = sheetname.replace("]", "");

		  if (!(sheetname != null && StringUtils.trim(sheetname).length() > 0)) {
			  sheetname = "取引先" + index;
		  }
		  return sheetname;
	  }



	  /**
	   * templateファイルダウンロード.
	   *
	   * @param req  HttpServletRequest
	   * @param resp HttpServletResponse
	   */
	  @Override
	  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	  {
		  //// TODO 自動生成されたメソッド・スタブ

		  //super.doGet(req, resp);

		  // response に content-type を設定する.
		  resp.setContentType("application/octet-stream");
		  resp.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(CustomerFile.CUSTOMER_TEMPLATE, "UTF-8") + "\"");

		  // response 設定用変数.
		  BufferedInputStream ins = null;
		  ServletOutputStream ous = null;

		  try {
			  // response にダウンロードファイルを設定する.
			  File file = new File(CustomerFile.FILE_PATH_TEMPLATE, CustomerFile.CUSTOMER_TEMPLATE);
			  ins = new BufferedInputStream(new FileInputStream(file));
			  ous = resp.getOutputStream();
			  int size;
			  byte buffer[]  = new byte[4096];
			  while((size = ins.read(buffer))!=-1) {
				  ous.write(buffer,0, size);
			  }
		  }
		  catch (IOException e) {
			  throw e;
		  }
		  catch (Exception e) {
			  ServletException srve = new ServletException(e.getMessage(), e.getCause());
			  throw srve;
		  }
		  finally {
				// response ストリームを close する.
				InputStreamUtil.close(ins);
				// out は コンテナが閉じるときに close される.
			}
	  }
}