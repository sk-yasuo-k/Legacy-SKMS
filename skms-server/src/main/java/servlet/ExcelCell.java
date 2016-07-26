package servlet;

import java.text.SimpleDateFormat;
import java.util.Date;
/*
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
*/
import org.apache.poi.hssf.util.HSSFColor;

//追加 @auther okamoto
import org.apache.poi.ss.usermodel.*;

public class ExcelCell {

	/** セルの値：String */
	private String _cellString;

	/**
	 * Excelセルの値をStringに変換する.
	 * @param cellVal Excelのセル.
	 * @return セルの値.
	 */
//	public static String convert2(HSSFCell cellVal)
	//追加 @auther okamoto
	public static String convert2(Cell cellVal)
	{
		return getCellValue(cellVal);
	}

	/**
	 * Excelセルの値をStringに変換する.
	 * @param cellVal Excelのセル.
	 * @return セルの値.
	 */
//	public String convert(HSSFCell cellVal)
	//追加 @auther okamoto
	public String convert(Cell cellVal)
	{
		setCellString(cellVal);
		return getCellString();
	}

	/**
	 * セル値設定.
	 * boolean、数値、日付、文字列の設定を行なう.
	 * @param cellVal Excelのセル.
	 */
//	public void setCellString(HSSFCell cellVal)
	//追加 @auther okamoto
	public void setCellString(Cell cellVal)
	{
		_cellString = getCellValue(cellVal);
	}

	/**
	 * セル値取得.
	 * @return セルの値.
	 */
	public String getCellString()
	{
		// 直前にsetCellString()した値を返す.
		return _cellString;
	}

	/**
	 * セルTypeに応じて値を取得する.
	 * error、blank のときは null を返す.
	 * @param cellVal Excelのセル.
	 */
//	private static String getCellValue(HSSFCell cellVal)
	//追加 @auther okamoto
	private static String getCellValue(Cell cellVal)
	{
		String retString = null;
		if (cellVal == null)	 return retString;

		int cellType = cellVal.getCellType();
		switch (cellType) {
//			case HSSFCell.CELL_TYPE_BLANK:				// 3
			//追加 @auther okamoto
			case Cell.CELL_TYPE_BLANK:
				break;
//			case HSSFCell.CELL_TYPE_BOOLEAN:			// 4
			//追加 @auther okamoto
			case Cell.CELL_TYPE_BOOLEAN:
				Boolean bool = cellVal.getBooleanCellValue();
				retString = bool.toString();
				break;
//			case HSSFCell.CELL_TYPE_ERROR:				// 5
			//追加 @auther okamoto
			case Cell.CELL_TYPE_ERROR:
				break;
//			case HSSFCell.CELL_TYPE_FORMULA:			// 2
			//追加 @auther okamoto
			case Cell.CELL_TYPE_FORMULA:
				retString = cellVal.getCellFormula();
				break;
//			case HSSFCell.CELL_TYPE_NUMERIC:			// 0
			//追加 @auther okamoto
			case Cell.CELL_TYPE_NUMERIC:
//				if (HSSFDateUtil.isCellDateFormatted(cellVal)) {
				//追加 @auther okamoto
				if(DateUtil.isCellDateFormatted(cellVal)){
					Date date = cellVal.getDateCellValue();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
					retString = sdf.format(date);
				}
				else {
					Double dbl = cellVal.getNumericCellValue();
					retString = dbl.toString();
				}
				break;
//			case HSSFCell.CELL_TYPE_STRING:				// 1
			//追加 @auther okamoto
			case Cell.CELL_TYPE_STRING:
				retString = cellVal.getRichStringCellValue().getString();
				break;
		}
		return retString;
	}

	/**
	 * セルの枠線設定.
	 *
	 * @param book  ワークブック.
	 * @return 枠線設定したセルスタイル.
	 */
//	public static HSSFCellStyle createCellStyle_border(HSSFWorkbook book)
	//追加 @auther okamoto
	public static CellStyle createCellStyle_border(Workbook book)
	{
//		HSSFCellStyle style = book.createCellStyle();
		//追加 @auther okamoto
		CellStyle style = book.createCellStyle();

		// 下枠.
//		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		//追加 @auther okamoto
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		// 左枠.
//		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		//追加 @auther okamoto
		style.setBorderLeft(CellStyle.BORDER_THIN);
	    style.setLeftBorderColor(HSSFColor.BLACK.index);
	    // 右枠.
//	    style.setBorderRight(HSSFCellStyle.BORDER_THIN);
	    //追加 @auther okamoto
	    style.setBorderRight(CellStyle.BORDER_THIN);
	    style.setRightBorderColor(HSSFColor.BLACK.index);
	    // 上枠.
//	    style.setBorderTop(HSSFCellStyle.BORDER_THIN);
	    //追加 @auther okamoto
	    style.setBorderTop(CellStyle.BORDER_THIN);
	    style.setTopBorderColor(HSSFColor.BLACK.index);

		return style;
	}

	/**
	 * セルのフォント設定.
	 *
	 * @param book  ワークブック.
	 * @return フォント設定したスタイル.
	 */
//	public static HSSFCellStyle createCellStyle_title(HSSFWorkbook book)
	//追加 @auther okamoto
	public static CellStyle createCellStyle_title(Workbook book)
	{
//		HSSFFont font = book.createFont();
		//追加 @auther okamoto
		Font font = book.createFont();
		
		font.setFontHeightInPoints((short)12);
		font.setItalic(true);
//		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		//追加 @auther okamoto
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);

//		HSSFCellStyle style = book.createCellStyle();
		//追加 @auther okamoto
		CellStyle style = book.createCellStyle();
		style.setFont(font);

		return style;
	}

}
