package servlet.customer;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.sun.org.apache.xml.internal.serializer.OutputPropertiesFactory;

import servlet.ExcelCell;


/**
 * 取引先ファイルアップロードを扱うアクションです。

 *
 * @author yasuo-k
 *
 */
public class CustomerFileUpload extends HttpServlet {

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
		//// TODO 自動生成されたメソッド・スタブ

		//super.doPost(req, resp);

		try {
			// response の content-type を設定する.
			resp.setContentType("text/xml; charset=UTF-8");
			PrintWriter out = resp.getWriter();

			//DOM Documentのインスタンスを生成するBuilderクラスのインスタンスを取得する.
			DocumentBuilderFactory bfactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = bfactory.newDocumentBuilder();

			//ビルダーからDOMを取得する

			Document document = builder.newDocument();

			if (ServletFileUpload.isMultipartContent(req)) {

				// XMLのルートを設定する.
				Element root = document.createElement("root");

				// ServletFileUpload を生成する.
				DiskFileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);

				// データを取得する.
				List list = upload.parseRequest(req);
				Iterator iterator = list.iterator();
				while (iterator.hasNext()) {
					FileItem item = (FileItem)iterator.next();
					if (item.getName() == null) 	continue;

					//System.out.print("ファイル名 : " + item.getName() + "\n");

					// アップロードファイルを取得する.
					InputStream fin = item.getInputStream();
//					POIFSFileSystem poi = new POIFSFileSystem(fin);

					// ワークブックを読み込む.
//					HSSFWorkbook workbook = new HSSFWorkbook(poi);
					//追加
					Workbook workbook = WorkbookFactory.create(fin);
					
					if (workbook == null)	break;

					// 各シートを取得する.
					for (int sheetindex = 0; sheetindex < workbook.getNumberOfSheets(); sheetindex++) {
						// シートを読み込む.
//						HSSFSheet sheet = workbook.getSheetAt(sheetindex);
						//追加
						Sheet sheet = workbook.getSheetAt(sheetindex);

						// customer タグを作成する.
						Element root_customer = document.createElement("customer");

						/* -----------------------------> 顧客情報の読み込み.      */
						List<Object[]> defList = CustomerFile.getDefineCustomer();
						for (int defindex = 0; defindex < defList.size(); defindex++) {

							// 項目名・タグ名を取得する.
							String kou = (String)defList.get(defindex)[0];
							String tag = (String)defList.get(defindex)[1];

							for (int rowindex = CustomerFile.getRow_dataCustomer(); rowindex < CustomerFile.getRow_dataCustomer() + defList.size(); rowindex++) {
								// 行を読み込む.
//								HSSFRow  row     = sheet.getRow(rowindex);
								//追加
								Row row = sheet.getRow(rowindex);
								
								if (row == null)		continue;

								// 項目セルを取得する.
//								HSSFCell cellKou = row.getCell((short)CustomerFile.getCol_dataCustomer());				// 項目.
								//追加
								Cell cellKou = row.getCell((short)CustomerFile.getCol_dataCustomer());
								
								if (!kou.equals(ExcelCell.convert2(cellKou)))	continue;

								// データセルを取得する.
//								HSSFCell cellVal = row.getCell((short)(CustomerFile.getCol_dataCustomer() + 1));		// 入力値.
								//追加
								Cell cellVal = row.getCell((short)(CustomerFile.getCol_dataCustomer() + 1));
								

								// タグを追加する.
								Element element = document.createElement(tag);
								element.setTextContent(ExcelCell.convert2(cellVal));
								root_customer.appendChild(element);
							}

						}
						/* <----------------------------- 顧客情報の読みこみ終了.  */


						/* -----------------------------> 担当者情報の読み込み.      */
						for (int colindex = CustomerFile.getCol_dataCustomer();  colindex < CustomerFile.getCol_dataCustomer() + CustomerFile.getMaxMember(); colindex++) {

							// member タグを作成する.
							Element root_member = document.createElement("member");
							boolean memberflg = false;

							List<Object[]> defList2 = CustomerFile.getDefineMember();
							for (int defindex = 0; defindex < defList2.size(); defindex++) {

								// 項目名・タグ名を取得する.
								String kou = (String)defList2.get(defindex)[0];
								String tag = (String)defList2.get(defindex)[1];

								for (int rowindex = CustomerFile.getRow_dataMember(); rowindex < CustomerFile.getRow_dataMember() + defList2.size(); rowindex++) {
									// 行を読み込む.
//									HSSFRow  row     = sheet.getRow(rowindex);
									//追加
									Row row = sheet.getRow(rowindex);
									
									if (row == null)		continue;

									// 項目セルを取得する.
//									HSSFCell cellKou = row.getCell((short)CustomerFile.getCol_dataMember());				// 項目.
									//追加
									Cell cellKou = row.getCell((short)CustomerFile.getCol_dataMember());
									
									if (!kou.equals(ExcelCell.convert2(cellKou)))	continue;

									// データセルを取得する.
//									HSSFCell cellVal = row.getCell((short)(CustomerFile.getCol_dataMember() + colindex));	// 入力値.
									//追加
									Cell cellVal = row.getCell((short)(CustomerFile.getCol_dataMember() + colindex));
									
									String   val     = ExcelCell.convert2(cellVal);
									if (val != null)	memberflg = true;

									// タグを追加する.
									Element element = document.createElement(tag);
									element.setTextContent(val);
									root_member.appendChild(element);
								}
							}
							/* <----------------------------- 担当者情報の読みこみ終了.  */

							// 担当者がいないときは 追加の担当者なしとみなし次の顧客情報を読み込む.
							if (!memberflg)	break;

							// 担当者タグを追加する.
							root_customer.appendChild(root_member);
						} // 担当者読込終了.

						NodeList nodelist = root_customer.getChildNodes();
						if (!(nodelist.getLength() > 0))	break;

						// 顧客タグを追加する.
						root.appendChild(root_customer);
					} // シート読込終了.
				}
				// rootタグを追加する.
				document.appendChild(root);
			}

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
		catch (IOException e) {
			throw e;
		}
		catch (Exception e) {
			ServletException srve = new ServletException(e.getMessage(), e.getCause());
			throw srve;
		}
		finally {
			// OutputStream は コンテナが閉じるときに close される.
		}
	}

}