package utils
{
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.CurrencyFormatter;
	import mx.formatters.DateFormatter;
	import mx.formatters.Formatter;
	import mx.formatters.NumberFormatter;
	import mx.utils.ObjectUtil;

	/**
	 * ラベルを扱うときに使用する静的なクラスです。
	 *
	 */
	[Bindable]
	public class LabelUtil
	{

//--------------------------------------
//  Function
//--------------------------------------
	//--------------------------------------
	//  Date Label
	//--------------------------------------
		/**
		 * DataGrid 日時フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function dateTimeLabel(data:Object, column:DataGridColumn):String
		{
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYY/MM/DD J:NN";
			return convertLabel(data[column.dataField], formatter);
	    }

		/**
		 * DataGrid 日付フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function dateLabel(data:Object, column:DataGridColumn):String
		{
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYY/MM/DD";
			return convertLabel(data[column.dataField], formatter);
		}

		/**
		 * Label 日付フォーマット処理.
		 *
		 * @param currency データ.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function date(date:Object):String
		{
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYY/MM/DD";
			return convertLabel(date, formatter);
		}


		/**
		 * DateField 日付フォーマット処理.
		 *
		 * @param data DateFieldの選択されたデータ項目.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function dateFieldLabel(date:Date):String
		{
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYY/MM/DD";
			return convertLabel(date, formatter);
		}


	//--------------------------------------
	//  Currency Label
	//--------------------------------------
		/**
		 * DataGrid 金額フォーマット処理(\なし).
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function currencyLabel(data:Object, column:DataGridColumn):String
		{
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			formatter.currencySymbol        = "";
			return convertLabel(data[column.dataField], formatter);
		}

		/**
		 * Label 金額フォーマット処理(\なし).
		 *
		 * @param currency データ.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function currency(currency:Object):String
		{
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			formatter.currencySymbol        = "";
			return convertLabel(currency, formatter);
		}

		/**
		 * Label 金額フォーマット処理(\なし).
		 * 通貨フォーマットから数値への変換処理.
		 * ※通貨フォーマットチェックを行なっていること.
		 *
		 * @param  expense 通貨フォーマット値 or 数値.
		 * @return 数値.
		 */
		public static function currencyFormatOff(expense:String):String
		{
			/*
				CurrencyFormatter、NumberFormatter の format().では..
				連続する数字の直前に.ダッシュ（-）がある場合、それが負符号と認識される.
				ダッシュの直後にスペースがある場合は、負符号とは見なされない.
			*/
			if (!expense)				return "";
			var formatter:NumberFormatter  = new NumberFormatter();
			formatter.useThousandsSeparator = false;
			formatter.useNegativeSign       = true;
			var fmexpense:String = convertLabel(expense, formatter);

//			// fo-mat前と後を比較し、"-"がついていなかったら設定する.
//			if (isNaN(Number(fmexpense)) == false
//				&& ObjectUtil.compare(expense.charAt(0),   "-") == 0
//				&& ObjectUtil.compare(fmexpense.charAt(0), "-") != 0) {
//				fmexpense = "-" + fmexpense;
//			}
			return fmexpense;
		}

		/**
		 * DataGrid 金額フォーマット処理(\あり).
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		 public static function expenseLabel(data:Object, column:DataGridColumn):String
		 {
		 	/*
				数値をフォーマット変換する.
				-\3.000 のような値が設定されていたら.\3.000 に変換されるため注意が必要!!
		 	*/
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			//formatter.currencySymbol        = "";
			return convertLabel(data[column.dataField], formatter);
		 }

		/**
		 * Label 金額フォーマット処理(\あり).
		 *
		 * @param expense 金額.
		 * @return フォーマット後の金額.
		 */
		 public static function expense(expense:Object):String
		 {
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			//formatter.currencySymbol        = "";
			return convertLabel(expense, formatter);
		 }

		/**
		 * Label 金額フォーマット処理(\なし).
		 * 通貨フォーマットから数値への変換処理.
		 * ※通貨フォーマットチェックを行なっていること.
		 *
		 * @param  expense 通貨フォーマット値 or 数値.
		 * @return 数値.
		 */
		public static function expenseFormatOff(expense:String):String
		{
			/*
				CurrencyFormatter、NumberFormatter の format().では..
				連続する数字の直前に.ダッシュ（-）がある場合、それが負符号と認識される.
				ダッシュの直後にスペースがある場合は、負符号とは見なされない.
			*/
			if (!expense)				return "";
			var formatter:NumberFormatter  = new NumberFormatter();
			formatter.useThousandsSeparator = false;
			formatter.useNegativeSign       = true;
			var fmexpense:String = convertLabel(expense, formatter);

			// fo-mat前と後を比較し、"-"がついていなかったら設定する.
			if (isNaN(Number(fmexpense)) == false
				&& ObjectUtil.compare(expense.charAt(0),   "-") == 0
				&& ObjectUtil.compare(fmexpense.charAt(0), "-") != 0) {
				fmexpense = "-" + fmexpense;
			}
			return fmexpense;
		}

	//--------------------------------------
	//  Hour Label
	//--------------------------------------
		/**
		 * DataGrid 勤務時間フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function workingHourLabel(data:Object, column:DataGridColumn):String
		{
			var formatter:NumberFormatter = new NumberFormatter();
			formatter.precision = 2;
			return convertLabel(data[column.dataField], formatter);
		}

		/**
		 * Label 勤務時間フォーマット処理.
		 *
		 * @param  expense 通貨フォーマット値 or 数値.
		 * @return 数値.
		 */
		public static function workingHour(hour:Number):String
		{
			var formatter:NumberFormatter = new NumberFormatter();
			formatter.precision = 2;
			return convertLabel(hour, formatter);
		}

	//--------------------------------------
	//  Accounting Label
	//--------------------------------------
		/**
		 * DataGrid 往復フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function roundTripLabel(data:Object, column:DataGridColumn):String
		{
			var roundTrip:Boolean = data[column.dataField] as Boolean;
			if (roundTrip)	return "往復";
			else			return "片道";
		}


		/**
		 * DataGrid 合計金額フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function totalExpenseLabel(data:Object, column:DataGridColumn):String
		{
			var list:ArrayCollection = data[column.dataField] as ArrayCollection;
			return totalExpense(list);
		}

		/**
		 * DataGrid 合計金額フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function totalExpense(list:ArrayCollection):String
		{
//			if (list && list.length > 0) {
				var total:Number = 0;
				for each (var object:Object in list) {
					total += Number(object.expense);
				}
				return expense(total.toString());
//			}
//			else {
//				return "";
//			}
		}


	//--------------------------------------
	//  Other.
	//--------------------------------------
		/**
		 * フォーマット処理.
		 *
		 * @param data フォーマット対象のデータ.
		 * @param formatter フォーマット形式.
		 * @return フォーマット済みのデータ.
		 */
		private static function convertLabel(data:Object, formatter:Formatter):String
		{
			// フォーマット変換する.
			if (!data)		return "";
			var fmdata:String = formatter.format(data);
			if (ObjectUtil.compare(fmdata, "") == 0) {
				// エラーのときは エラー内容を返す.
				fmdata = formatter.error + "(" + data + ")";
			}
	        return fmdata;
		}

	}
}