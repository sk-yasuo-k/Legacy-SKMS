package servlet;

import java.text.DateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
/*
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
*/
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
//追加
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;

import utils.RegexUtil;


/**
 * Excelシートラッパークラス。
 * Excelシートオブジェクトを扱うためのラッパークラスです。
 *
 * @author yoshinori-t
 *
 */
public class ExcelSheet {
	/**
	 * Excelブックオブジェクト
	 */
//	private HSSFWorkbook book;
	//追加 @auther okamoto
	private Workbook book;
	/**
	 * Excelシートオブジェクト
	 */
//	private HSSFSheet sheet;
	//追加 @auther okamoto
	private Sheet sheet;
	
	/**
	 * コンストラクタ
	 * 
	 * @param _book Excelブックオブジェクト
	 * @param _sheet Excelシートオブジェクト
	 */
//	public ExcelSheet(HSSFWorkbook _book, HSSFSheet _sheet)
	//追加 @auther okamoto
	public ExcelSheet(Workbook _book, Sheet _sheet)
	{
		book = _book;
		sheet = _sheet;
	}
	
	/**
	 * Excelブックオブジェクトの設定
	 * 
	 * @param _book Excelブックオブジェクト
	 * @param _sheet Excelシートオブジェクト
	 */
//	public void setBook(HSSFWorkbook _book, HSSFSheet _sheet)
	//追加 @auther okamoto
	public void setBook(Workbook _book, Sheet _sheet)
	{
		book = _book;
		sheet = _sheet;
	}
	
	/**
	 * Excelシートオブジェクトの設定
	 * 
	 * @param _sheet Excelシートオブジェクト
	 */
//	public void setSeet(HSSFSheet _sheet)
	//追加 @auther okamoto
	public void setSeet(Sheet _sheet)
	{
		sheet = _sheet;
	}
	
	/**
	 * Excelシートオブジェクトの取得
	 * 
	 * @return _sheet Excelシートオブジェクト
	 */
//	public HSSFSheet getSeet()
	//追加 @auther okamoto
	public Sheet getSeet()
	{
		return sheet;
	}
	
	/**
	 * セルの設定(文字列)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param string 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, String string )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		Cell cell = this.getCell(rowNo, colNo);
//		cell.setCellValue(new HSSFRichTextString(string));
		//追加 @auther okamoto
		cell.setCellValue(string);
	}

	/**
	 * セルの設定(数値)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param number 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, double number )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = this.getCell(rowNo, colNo);
		cell.setCellValue(number);
	}
	
	/**
	 * セルの設定(論理型)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param bool 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, boolean bool )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = this.getCell(rowNo, colNo);
		cell.setCellValue(bool);
	}
	
	/**
	 * セルの設定(日付)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param date 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, Date date )
	{
		this.setCellValue(rowNo, colNo, date, null);
	}
	
	/**
	 * セルの設定(日付)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param format 日付の表示書式(省略可能)
	 * @param date 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, Date date, String format )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = this.getCell(rowNo, colNo);
		
		// 日付の設定
		if( date != null )
		{
//			HSSFCellStyle style = cell.getCellStyle();
			//追加 @auther okamoto
			CellStyle style = cell.getCellStyle();
			
			// セルが日付書式以外の場合
			int type = cell.getCellType();
//			if ( (( type != HSSFCell.CELL_TYPE_NUMERIC ) && ( type != HSSFCell.CELL_TYPE_BLANK ))
//			  || ( !HSSFDateUtil.isCellDateFormatted(cell) ) )
			//追加 @auther okamoto
			if ( (( type != Cell.CELL_TYPE_NUMERIC ) && ( type != Cell.CELL_TYPE_BLANK ))
			  || ( !DateUtil.isCellDateFormatted(cell) ) )
			{
				// 日付書式を設定する
				style.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy h:mm"));
				cell.setCellStyle(style);
			}
			
			// 日付の設定を行う
			cell.setCellValue(date);
			
			// 表示書式が指定されている場合
			if ( format != null )
			{
				// 表示用の日付書式を設定する
//				HSSFDataFormat fmt = book.createDataFormat();
				//追加 @auther okamoto
				DataFormat fmt = book.createDataFormat();
				style.setDataFormat(fmt.getFormat(format));
				cell.setCellStyle(style);
			}
		}
		// nullの設定
		else
		{
//			cell.setCellValue(new HSSFRichTextString(null));
			//追加 @auther okamoto
			cell.setCellValue("");
		}
	}

	/**
	 * セルの設定(カレンダー型)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param cal 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, Calendar cal )
	{
		this.setCellValue(rowNo, colNo, cal, null);
	}
	
	/**
	 * セルの設定(カレンダー型)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param format 日付の表示書式(省略可能)
	 * @param cal 設定する値
	 */
	public void setCellValue( int rowNo, int colNo, Calendar cal, String format )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = this.getCell(rowNo, colNo);
		
		// 日付の設定
		if( cal != null )
		{
//			HSSFCellStyle style = cell.getCellStyle();
			//追加 @auther okamoto
			CellStyle style = cell.getCellStyle();
			
			// セルが日付書式以外の場合
			int type = cell.getCellType();
//			if ( (( type != HSSFCell.CELL_TYPE_NUMERIC ) && ( type != HSSFCell.CELL_TYPE_BLANK ))
//			  || ( !HSSFDateUtil.isCellDateFormatted(cell) ) )
			//追加 @auther okamoto
			if ( (( type != Cell.CELL_TYPE_NUMERIC ) && ( type != Cell.CELL_TYPE_BLANK ))
			  || ( !DateUtil.isCellDateFormatted(cell) ) )
			{
				// 日付書式を設定する
				style.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy h:mm"));
				cell.setCellStyle(style);
			}
			
			// 日付の設定を行う
			cell.setCellValue(cal);
			
			// 表示書式が指定されている場合
			if ( format != null )
			{
				// 表示用の日付書式を設定する
//				HSSFDataFormat fmt = book.createDataFormat();
				//追加 @auther okamoto
				DataFormat fmt = book.createDataFormat();
				style.setDataFormat(fmt.getFormat(format));
				cell.setCellStyle(style);
			}
		}
		// nullの設定
		else
		{
			// nullを設定する
//			cell.setCellValue(new HSSFRichTextString(null));
			//追加 @auther okamoto
			cell.setCellValue("");
		}
	}
	
	/**
	 * セルの設定(数式)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @param formula 設定する数式
	 */
	public void setCellFormula( int rowNo, int colNo, String formula )
	{
//		HSSFCell cell = this.getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = this.getCell(rowNo, colNo);
		cell.setCellFormula(formula);
	}
	
	/**
	 * セル内容の取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セル内容の文字列(error、blank のときは null)
	 */
	public String getCellValue( int rowNo, int colNo )
	{
		return ExcelCell.convert2( getCell(rowNo, colNo) );
	}
	
	/**
	 * セル内容(日付型)の取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セル内容の文字列(日付型以外のときは null)
	 */
	public Date getDateCellValue( int rowNo, int colNo )
	{
		Date date = null;
		
		// セルの取得
//		HSSFCell cell = getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = getCell(rowNo, colNo);

		if ( cell != null )
		{
			// セルの書式が日付型である場合のみデータの取得を行う
			int type = cell.getCellType();
//			if ( type == HSSFCell.CELL_TYPE_NUMERIC )
			//追加 @auther okamoto
			if( type == Cell.CELL_TYPE_NUMERIC)
			{
//				if ( HSSFDateUtil.isCellDateFormatted(cell) )
				//追加 @auther okamoto
				if(DateUtil.isCellDateFormatted(cell))
				{
					// セル内容の取得
					date = cell.getDateCellValue();
				}
			}
			// セルの書式が文字列型である場合は日付型に変換してみる
//			else if ( type == HSSFCell.CELL_TYPE_STRING )
			//追加 @auther okamoto
			else if( type == Cell.CELL_TYPE_STRING)
			{
				String str = cell.getRichStringCellValue().toString();
				try {
					date = DateFormat.getDateInstance().parse(str);
				}
				catch( Exception e )
				{
					System.out.println("[" + str + "]の日付型への変換に失敗しました。");
				}
			}
		}
		
		return date;
	}
	
	/**
	 * セル内容(数値型)の取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セル内容の文字列(数値型以外のときは null)
	 */
	public Double getNumericCellValue( int rowNo, int colNo )
	{
		Double number = null;
		
		// セルの取得
//		HSSFCell cell = getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = getCell(rowNo, colNo);
		
		if ( cell != null )
		{
			// セルの書式が数値型である場合のみデータの取得を行う
			int type = cell.getCellType();
//			if ( type == HSSFCell.CELL_TYPE_NUMERIC )
			//追加 @auther okamoto
			if( type == Cell.CELL_TYPE_NUMERIC)
			{
//				if( !HSSFDateUtil.isCellDateFormatted(cell) )
				//追加 @auther okamoto
				if(!DateUtil.isCellDateFormatted(cell))
				{
					// セル内容の取得
					number = cell.getNumericCellValue();
				}
			}
			// セルの書式が文字列型である場合は数値型に変換してみる
//			else if ( type == HSSFCell.CELL_TYPE_STRING )
			//追加 @auther okamoto
			else if( type == Cell.CELL_TYPE_STRING)
			{
				String str = cell.getRichStringCellValue().toString();
				try {
					number = Double.valueOf(str);
				}
				catch( Exception e )
				{
					System.out.println("[" + str + "]の数値型への変換に失敗しました。");
				}
			}
		}
		
		return number;
	}
	
	/**
	 * セル内容(整数型)の取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セル内容の文字列(整数型以外のときは null)
	 */
	public Integer getIntCellValue( int rowNo, int colNo )
	{
		Integer integer = null;
		
		// セル内容の取得
		Double number = getNumericCellValue(rowNo, colNo);
		
		// 整数型への変換
		if ( number != null ) integer = number.intValue();
		
		return integer;
	}

	/**
	 * セル内容(数式)の取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セル内容の文字列(数式以外のときは null)
	 */
	public String getCellFormula( int rowNo, int colNo )
	{
		String formula = null;
		
		// セルの取得
//		HSSFCell cell = getCell(rowNo, colNo);
		//追加 @auther okamoto
		Cell cell = getCell(rowNo, colNo);
		
		// セルの書式が数式型である場合のみデータの取得を行う
//		if ( ( cell != null )
//		  && ( cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA ) )
		//追加 @auther okamoto
		if ( ( cell != null )
		  && ( cell.getCellType() == Cell.CELL_TYPE_FORMULA ) )
		{
			// セル内容の取得
			formula = cell.getCellFormula();
		}
		
		return formula;
	}
	
	/**
	 * シートの再計算
	 * 
	 * @param value 再計算有無(多分)
	 */
	public void setForceFormulaRecalculation(boolean value)
	{
		sheet.setForceFormulaRecalculation(value);
	}
	
	/**
	 * 行の挿入(単一行のみ実装)
	 * 
	 * @param rowNoInsert 挿入行番号(1から開始)
	 */
	public void insertRowSingle( int rowNoInsert )
	{
		// 最終行から開始し、１行下へシフトさせ続ける
		int lastRow = this.getLastRowNum();	// 最終行
		for (int i = lastRow; i >= rowNoInsert; i-- )
		{
			// 対象行を生成する
//			HSSFRow rowInsert = this.getRow(i);
			//追加 @auther okamoto
			Row rowInsert = this.getRow(i);
			
			// 対象行の表示/非表示設定を次の行に設定する
//			HSSFRow rowNext = this.getRow(i + 1);
			//追加 @auther okamoto
			Row rowNext = this.getRow(i + 1);
			rowNext.setZeroHeight(rowInsert.getZeroHeight());
			
			// 列が無い場合、次の行の行を削除する
			if ( rowInsert.getLastCellNum() < 0 )
			{
//				HSSFRow rowDelete = this.getRowCore(i + 1);
				//追加 @auther okamoto
				Row rowDelete = this.getRowCore(i + 1);
				if( rowDelete != null && rowDelete.getLastCellNum() >= 0 ) sheet.removeRow(rowDelete);
				continue;
			}
			
			// 行の内容を１行下へシフトさせる
			this.shiftRows( i, i, 1 );
		}
	}
	
	/**
	 * 行のコピー(単一行のみ実装)
	 * 
	 * @param rowNoSrc コピー元の行番号(1から開始)
	 * @param rowNoDst コピー先の行番号(1から開始)
	 */
	@SuppressWarnings("deprecation")
	public void copyRowSingle( int rowNoSrc, int rowNoDst )
	{
//		HSSFRow rowSrc = this.getRow(rowNoSrc);			// コピー元行オブジェクト
		//追加 @auther okamoto
		Row rowSrc = this.getRow(rowNoSrc);
//		HSSFRow rowDst = this.getRow(rowNoDst);			// コピー先行オブジェクト
		//追加 @auther okamoto
		Row rowDst = this.getRow(rowNoDst);
		short cellNumCopySrc = rowSrc.getLastCellNum();		// コピー元列数
		short cellNumCopyDst = rowDst.getLastCellNum();		// コピー先列数
		if ( cellNumCopySrc < 0 ) cellNumCopySrc = 0;
		if ( cellNumCopyDst < 0 ) cellNumCopyDst = 0;
		
		//////////////////////////////////////////////////
		// コピー先列数の調整(コピー元の列数と数を合わせる)
		//////////////////////////////////////////////////
		// コピー元の方が列数が多い場合
		if ( cellNumCopyDst < cellNumCopySrc )
		{
			// 足らない列を追加
			for ( int i = cellNumCopyDst; i < cellNumCopySrc; i++ )
			{
				rowDst.createCell(i);
			}
		}
		// コピー先の方が列数が多い場合
		else if ( cellNumCopyDst > cellNumCopySrc )
		{
			// 余分な列を削除
			for ( int i = cellNumCopySrc; i < cellNumCopyDst; i++ )
			{
				rowDst.removeCell(rowDst.getCell(i));
			}
		}
		
		//////////////////////////////////////////////////
		// 書式、値、数式のコピー
		//////////////////////////////////////////////////
		// コピー元の行数分ループ
		for ( int i = 0; i < cellNumCopySrc; i++ )
		{
//			HSSFCell cellSrc = rowSrc.getCell(i);	// コピー元セルオブジェクト
			//追加 @auther okamoto
			Cell cellSrc = rowSrc.getCell(i);
//			HSSFCell cellDst = rowDst.getCell(i);	// コピー先セルオブジェクト
			//追加 @auther okamoto
			Cell cellDst = rowDst.getCell(i);
			
			// コピー元セルがnullの場合は次のセルへ
			if ( cellSrc == null ) continue;
			
			// セルの書式をコピー
			cellDst.setCellStyle(cellSrc.getCellStyle());
			
			// セルの表示形式をコピー
			int type = cellSrc.getCellType();
			cellDst.setCellType(type);
			
			// 表示形式に応じて処理の振り分け
			switch (type) {
//			case HSSFCell.CELL_TYPE_STRING:				// 1
			//追加 @auther okamoto
			case Cell.CELL_TYPE_STRING:
				cellDst.setCellValue(cellSrc.getRichStringCellValue());		// コピー先の文字の設定
				break;
//			case HSSFCell.CELL_TYPE_FORMULA:			// 2
			//追加 @auther okamoto
			case Cell.CELL_TYPE_FORMULA:
				String formula = cellSrc.getCellFormula();					// コピー元の数式の取得
				formula = copyRowFormula(formula, rowNoDst - rowNoSrc);		// 数式の参照値変換を実施
				cellDst.setCellFormula(formula);							// コピー先の数式の設定
				break;
//			case HSSFCell.CELL_TYPE_NUMERIC:			// 0
			//追加 @auther okamoto
			case Cell.CELL_TYPE_NUMERIC:
				// 日付型の場合
//				if (HSSFDateUtil.isCellDateFormatted(cellSrc))
				//追加 @auther okamoto
				if(DateUtil.isCellDateFormatted(cellSrc))
				{
					cellDst.setCellValue(cellSrc.getDateCellValue());		// コピー先の日付の設定
				}
				// 数値型の場合
				else {
					cellDst.setCellValue(cellSrc.getNumericCellValue());	// コピー先の数値の設定
				}
				break;
//			case HSSFCell.CELL_TYPE_BOOLEAN:			// 4
			//追加 @auther okamoto
			case Cell.CELL_TYPE_BOOLEAN:
				cellDst.setCellValue(cellSrc.getBooleanCellValue());		// コピー先の論理値の設定
				break;
//			case HSSFCell.CELL_TYPE_BLANK:				// 3
			//追加 @auther okamoto
			case Cell.CELL_TYPE_BLANK:
//			case HSSFCell.CELL_TYPE_ERROR:				// 5
			//追加 @auther okamoto
			case Cell.CELL_TYPE_ERROR:
//				cellDst.setCellValue(new HSSFRichTextString(null));		// コピーを空に設定
				//追加 @auther okamoto
				cellDst.setCellValue("");
				break;
			}
		}
		
		//////////////////////////////////////////////////
		// セル結合
		//////////////////////////////////////////////////
		int rowNoSrcCore = rowNoSrc - 1;	// コピー元行番号(0から開始)
		int rowNoDstCore = rowNoDst - 1;	// コピー先行番号(0から開始)
		// 結合情報数分ループ
		for ( int i = 0; i < sheet.getNumMergedRegions(); i++ )
		{
			// 結合情報の取得
//			Region region = sheet.getMergedRegionAt(i);
			//追加 @auther okamoto
			CellRangeAddress region = sheet.getMergedRegion(i);
			
			// 結合情報がコピー元行のものでなければ処理を行わない
//			if ( region.getRowFrom() != rowNoSrcCore ) continue;
			//追加 @auther okamoto
			if ( region.getFirstRow() != rowNoSrcCore ) continue;
			
			// コピー先行に結合情報を設定する
			sheet.addMergedRegion(new CellRangeAddress(
//					rowNoDstCore, region.getColumnFrom(),
//					rowNoDstCore, region.getColumnTo()));
					//追加 @auther okamoto
					rowNoDstCore, region.getFirstColumn(),
					rowNoDstCore, region.getLastColumn()));
		}
	}
	
	/**
	 * セルオブジェクトの取得(行列指定)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @param colNo 列番号(1から開始)
	 * @return セルオブジェクト
	 */
//	public HSSFCell getCell( int rowNo, int colNo )
	//追加 @auther okamoto
	public Cell getCell(int rowNo, int colNo)
	{
		// 行オブジェクトを取得する
//		HSSFRow row = getRow(rowNo);
		//追加 @auther okamoto
		Row row = getRow(rowNo);
		
		// 列オブジェクトを取得する
		return getCell(row, colNo);
	}
	
	/**
	 * 行オブジェクトの取得
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @return 行オブジェクト
	 */
//	private HSSFRow getRow( int rowNo )
	//追加 @auther okamoto
	private Row getRow(int rowNo)
	{
		int rowNoWork = rowNo - 1;		// 対象行(0相対のため、デクリメント)
		
		// 行オブジェクトを取得する
//		HSSFRow row = sheet.getRow(rowNoWork);
		//追加 @auther okamoto
		Row row = sheet.getRow(rowNoWork);
		
		// 行が存在しない場合は新たに作成する
		if( row == null ) row = sheet.createRow(rowNoWork);	
		
		return row;
	}
	
	/**
	 * 行オブジェクトの取得(取得のみで作成は行わない)
	 * 
	 * @param rowNo 行番号(1から開始)
	 * @return 行オブジェクト
	 */
//	private HSSFRow getRowCore( int rowNo )
	//追加 @auther okamoto
	private Row getRowCore(int rowNo)
	{
		int rowNoWork = rowNo - 1;		// 対象行(0相対のため、デクリメント)
		
		// 行オブジェクトを取得して返却する
		return sheet.getRow(rowNoWork);
	}
	
	/**
	 * セルオブジェクトの取得
	 * 
	 * @param 行オブジェクト
	 * @param colNo 列番号(1から開始)
	 * @return セルオブジェクト
	 */
//	private HSSFCell getCell( HSSFRow row, int colNo )
	//追加 @auther okamoto
	private Cell getCell(Row row, int colNo)
	{
		int colNoWork = colNo - 1;		// 対象列(0相対のため、デクリメント)
		
		// セルオブジェクトを取得する
//		HSSFCell cell = row.getCell(colNoWork);
		//追加 @auther okamoto
		Cell cell = row.getCell(colNoWork);
		
		// セルが存在しない場合は新たに作成する
		if ( cell == null ) cell = row.createCell(colNoWork);
		
		return cell;
	}
	
	// removeRow
	
	/**
	 * 最大行番号の取得
	 * 
	 * @return 最大行番号(1から開始)
	 */
	private int getLastRowNum()
	{
		return sheet.getLastRowNum() + 1;
	}
	
	/**
	 * 行のシフト
	 * 
	 * @param startRow シフト開始行番号(1から開始)
	 * @param endRow シフト終了行番号(1から開始)
	 * @param n シフト数
	 */
	private void shiftRows( int startRow, int endRow, int n )
	{
		int startRowWork = startRow - 1;		// シフト開始行(0相対のため、デクリメント)
		int endRowWork = endRow - 1;			// シフト終了行(0相対のため、デクリメント)
		
		sheet.shiftRows( startRowWork, endRowWork, n );
	}
	
	/**
	 * 数式の参照値変換(行のみ)
	 * 
	 * @param formula 変換を行う数式
	 * @param row 行の相対位置
	 * @return 変換後の数式
	 */
	private String copyRowFormula(String formula, int row)
	{
		// 相対位置に変わりがなければそのまま返却する
		if ( row == 0 ) return formula;
		
		String result = formula;
		result += " ";	// 完全一致かどうかの判定のため、一時的に末尾にスペースを付加する
		
		// 参照値で分割
		String[] splitFormula = splitFormula(formula);
		
		// 配列を昇順でソート
		Arrays.sort(splitFormula);
		
		// 分割した配列数分ループ
		int i = 0;
		for ( int cnt = 0; cnt < splitFormula.length; cnt++ )
		{
			// 相対位置が＋方向の場合、逆方向から変換を行う
			if ( row > 0)
			{
				i = splitFormula.length - cnt - 1;
			}
			else
			{
				i = cnt;
			}
			
			// 参照値の判定
			if ( isReference(splitFormula[i]) )
			{
				// 参照値の変換の実施
				String regexBase = splitFormula[i];
				
				// // メタ文字に「￥」を付加する
				String regex = RegexUtil.replaceMetaWord(regexBase);
				
				// 完全一致かどうかによって処理を振り分ける
				String[] arrPerfectMatching = result.split(regex);
				result = arrPerfectMatching[0];	// 先頭データは必ず格納
				for ( int j = 1; j < arrPerfectMatching.length; j++ )
				{
					// 完全一致でない場合
					if ( arrPerfectMatching[j].matches("^[0-9].*") )
					{
						// 変換を実施しない
						result = result + regexBase + arrPerfectMatching[j];
					}
					// 完全一致の場合
					else
					{
						// 変換を実施
						result = result + convertRowReference(regexBase, row) + arrPerfectMatching[j];
					}
				}
			}
		}
		result = result.trim();	// 一時的に付加した末尾のスペースを除去する
		
		return result;
	}
	
	/**
	 * 数式を参照値で分割
	 * 
	 * @param src 分割対象の数式配列
	 * @return 分割後の参照値配列
	 */
	private String[] splitFormula(String src)
	{
		String[] formula = {src};
		String[] result = formula;
		result = split(result, "\\=");
		result = split(result, "\\)");
		result = split(result, "\\(");
		result = split(result, "\\,");
		result = split(result, "\\+");
		result = split(result, "\\-");
		result = split(result, "\\*");
		result = split(result, "\\/");
		result = split(result, "\\<");
		result = split(result, "\\>");
		result = split(result, "\\!");
		result = split(result, "\\ ");
		result = split(result, "\\^");
		result = split(result, "\\|");
		result = split(result, "\\.");
		result = split(result, "\\ ");
		
		return result;
	}

	/**
	 * splitの配列版
	 * 
	 * @param src 分割対象の文字列配列
	 * @param regex 正規表現の区切り
	 * @return 分割後の文字列配列
	 */
	private String[] split(String[] src, String regex)
	{
		String[] result = {};
		for( int i = 0; i < src.length; i++ )
		{
			// 分割の実施
			String[] dst = src[i].split(regex);
			
			// 配列の結合を行う
			String[] tmp = new String[result.length + dst.length];
			System.arraycopy(result, 0, tmp, 0, result.length);
			System.arraycopy(dst, 0, tmp, result.length, dst.length);
			result = tmp;
		}
		return result;
	}
	
	/**
	 * 参照値の変換(行のみ)
	 * 
	 * @param src 変換を行う参照値
	 * @param row 行の相対位置
	 * @return 変換後の参照値
	 */
	private String convertRowReference(String src, int row)
	{
		// アルファベット部分の除去
		String strNumPart = src.replaceAll("\\$?[A-Z]+", "");
		
		// 絶対参照の場合は変換を実施しない
		if ( strNumPart.matches("$.*") ) return src;
		
		// 数値の加算を行う
		int num;
		num = Integer.parseInt(strNumPart);
		num += row;
		
		// 変換の実施
		String result = src.replaceAll(strNumPart, String.valueOf(num));
		
		return result;
	}

	/**
	 * 参照値の判定
	 * 
	 * @param src チェック対象の参照値
	 * @return チェック結果(参照値の場合はtrue)
	 */
	private boolean isReference(String src)
	{
		return src.matches("\\$?[A-Z]+\\$?[0-9]+");
	}
}
