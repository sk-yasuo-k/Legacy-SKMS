package subApplications.customer.dto
{
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.customer.dto.CustomerDto")]
	public class CustomerDto
	{
		public function CustomerDto()
		{
		}
		/**
		 * 顧客IDです.
		 */
		public var customerId:int;

		/**
		 * 顧客区分です.
		 */
	    public var customerType:String;

		/**
		 * 顧客番号です.
		 */
		public var customerNo:String;

		/**
		 * 顧客名称です.
		 */
		public var customerName:String;

		/**
		 * 顧客略称です.
		 */
		public var customerAlias:String;

		/**
		 * 表示順序です.
		 */
		public var sortOrder:int;

		/**
		 * 支払サイトです.
		 */
		public var billPayable:String;

		/**
		  * 備考です.
		  */
		public var note:String;

		 /**
		  * 登録バージョンです.
		  */
		public var registrationVer:int;

		 /**
		  * Webページです.
		  */
		public var customerHtml:String;

		 /**
		  * 取引開始日です.
		  */
		public var customerStartDate:Date;

		/**
		  * 取引終了日です.
		  */
		public var customerFinishDate:Date;

		 /**
		  * 代表者 姓（漢字）です.
		  */
		public var representativeLastName:String;

		 /**
		  * 代表者 名（漢字）です.
		  */
		public var representativeFirstName:String;

		 /**
		  * 代表者 姓（かな）です.
		  */
		public var representativeLastNameKana:String;

		 /**
		  * 代表者 名（かな）です.
		  */
		public var representativeFirstNameKana:String;

		/**
		 * 顧客担当者リストです.
		 */
		public var customerMembers:ArrayCollection;


		/**
		 * 顧客コードです.（顧客種別＋顧客番号）.
		 */
		public var customerCode:String;

		 /**
		  * 顧客代表者です.（姓＋名）.
		  */
		public var customerRepresentative:String;

		 /**
		  * 顧客代表者です.（姓＋名 かな）.
		  */
		public var customerRepresentativeKana:String;


		/**
		 * 顧客一致確認.
		 *
		 * @param comp1 顧客1.
		 * @param comp2 顧客2.
		 * @return 確認結果.
		 */
		public static function compare(comp1:CustomerDto, comp2:CustomerDto):Boolean
		{
			if (!(comp1 && comp2))	return false;
			if (ObjectUtil.compare(comp1.customerId, comp2.customerId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 顧客のコピー.
		 *
		 * @return 顧客.
		 */
		public function copy():CustomerDto
		{
			var dst:CustomerDto = ObjectUtil.copy(this) as CustomerDto;
			dst.customerId   = -99;										// 顧客ID初期化.
			dst.customerNo   = null										// 顧客番号初期化.
			dst.customerStartDate = null;								// 取引開始日初期化.
			dst.sortOrder    = -99;										// ソート順初期化.
			if (dst.customerMembers) {
				for (var i:int = 0; i < dst.customerMembers.length; i++) {
					dst.customerMembers.getItemAt(i).customerId       = -99;
					dst.customerMembers.getItemAt(i).customerMemberId = -99;
				}
			}
			return dst;
		}

		/**
		 * Webページが登録されているかどうか確認する.
		 *
		 * @return 確認結果.
		 */
		 public function checkCustomerHtml():Boolean
		 {
		 	
		 	if (this.customerHtml && StringUtil.trim(this.customerHtml).length > 0) {
//			if(StringUtil.trim(this.customerHtml).length == 0){
		 		return true;
		 	}
		 	return false;
		 }

		/**
		 * Webページの取得.
		 *
		 * @return url.
		 */
		 public function getCustomerHtml():String
		 {
		 	return this.customerHtml;
		 }

		/**
		 * 顧客XMLの変換.
		 * @param  xml 顧客XMLリスト.
		 * @return 顧客情報リスト.
		 */
		 public static function convert(xml:XML):ArrayCollection
		 {
		 	var list:ArrayCollection = new ArrayCollection();
		 	if (!xml)	return list;

			// 顧客情報XMLリストを取得する.
			var customerList:XMLList = xml.descendants("customer");
			for (var index:int = 0; index < customerList.length(); index++) {
				// 顧客情報XMLを取得する.
				var customerXml:XML = customerList[index];
				var customerVal:String = null;

				// 顧客情報を設定する.
				var dst:CustomerDto = new CustomerDto();
				customerVal = getXmlData(customerXml, "customerType");				// 顧客区分.
				if (customerVal) {
					if (ObjectUtil.compare(customerVal, "C") == 0 || ObjectUtil.compare(customerVal, "E") == 0 )
						dst.customerType = customerVal;
				}

				// 顧客コードは自動採番するため、取得しない.

				customerVal = getXmlData(customerXml, "customerName");				// 顧客名称.
				if (customerVal)	dst.customerName = customerVal;

				customerVal = getXmlData(customerXml, "customerAlias");				// 顧客略称.
				if (customerVal)	dst.customerAlias = customerVal;

				customerVal = getXmlData(customerXml, "representativeFirstName");	// 代表者 姓（漢字）.
				if (customerVal)	dst.representativeFirstName = customerVal;

				customerVal = getXmlData(customerXml, "representativeLastName");	// 代表者 名（漢字）.
				if (customerVal)	dst.representativeLastName = customerVal;

				customerVal = getXmlData(customerXml, "representativeFirstNameKana");// 代表者 姓（かな）.
				if (customerVal)	dst.representativeFirstNameKana = customerVal;

				customerVal = getXmlData(customerXml, "representativeLastNameKana");// 代表者 名（かな）.
				if (customerVal)	dst.representativeLastNameKana = customerVal;

				customerVal = getXmlData(customerXml, "customerHtml");				// Webページ.
				if (customerVal)	dst.customerHtml = customerVal;

				customerVal = getXmlData(customerXml, "customerStartDate");			// 取引開始日.
				if (customerVal) {
					var date:Date = DateField.stringToDate(customerVal, "YYYY/MM/DD");
					dst.customerStartDate = date;
				}

				customerVal = getXmlData(customerXml, "billPayable");				// 支払サイト.
				if (customerVal)	dst.billPayable = customerVal;

				customerVal = getXmlData(customerXml, "note");						// 備考.
				if (customerVal)	dst.note = customerVal;



				// 担当者情報を取得する.
				var membersList:XMLList = customerXml.descendants("member");
				dst.customerMembers = CustomerMemberDto.convert(dst, membersList);


				// 顧客情報を追加する.
				list.addItem(dst);
			}
		 	return list;
		 }

		/**
		 * 顧客XMLの変換.
		 * @param  xml 顧客XMLリスト.
		 * @return 顧客情報リスト.
		 */
		 public static function getXmlData(xml:XML, name:String = null):String
		 {
		 	var ret:String = null;
		 	if (!xml)	return ret;

		 	var list:XMLList = xml.descendants(name);
		 	for (var i:int = 0; i < list.length(); i++) {
		 		var item:XML = list[i];
		 		ret = item.toString();
		 		break;
		 	}

		 	return ret;
		 }


		/**
		 * 顧客のXML変換.
		 * @param  list 顧客情報リスト.
		 * @return 顧客XMLリスト.
		 */
		 public static function convert2(list:ArrayCollection):XML
		 {
		 	if (!(list && list.length > 0))		return null;
		 	var root:XML = new XML("<root></root>");

			// 顧客情報リストを取得する.
			for (var index:int = 0; index < list.length; index++) {
				var customer:CustomerDto = list.getItemAt(index) as CustomerDto;
				if (!customer)	continue;

				// 顧客xmlを作成する.
				var customerXml:XML = new XML("<customer></customer>");
				var val:String;
				var xmlstring:String;

				val = setXmlData(customer.customerType);							// 顧客区分.
				xmlstring = "<customerType>"+ val +"</customerType>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.customerCode);							// 顧客コード.
				xmlstring = "<customerCode>"+ val +"</customerCode>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.customerName);							// 顧客名称.
				xmlstring = "<customerName>"+ val +"</customerName>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.customerAlias);							// 顧客略称.
				xmlstring = "<customerAlias>"+ val +"</customerAlias>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.representativeFirstName);					// 代表者 姓（漢字）.
				xmlstring = "<representativeFirstName>"+ val +"</representativeFirstName>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.representativeLastName);					// 代表者 名（漢字）.
				xmlstring = "<representativeLastName>"+ val +"</representativeLastName>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.representativeFirstNameKana);				// 代表者 姓（かな）.
				xmlstring = "<representativeFirstNameKana>"+ val +"</representativeFirstNameKana>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.representativeLastNameKana);				// 代表者 名（かな）.
				xmlstring = "<representativeLastNameKana>"+ val +"</representativeLastNameKana>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.customerHtml);							// Webページ.
				xmlstring = "<customerHtml>"+ val +"</customerHtml>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData_date(customer.customerStartDate);					// 取引開始日.
				xmlstring = "<customerStartDate>"+ val +"</customerStartDate>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.billPayable);								// 支払サイト.
				xmlstring = "<billPayable>"+ val +"</billPayable>";
				customerXml.appendChild(new XML(xmlstring));

				val = setXmlData(customer.note);									// 備考..
				xmlstring = "<note>"+ val +"</note>";
				customerXml.appendChild(new XML(xmlstring));


				// 担当者情報リストを取得する.
				if (customer.customerMembers) {
					for (var k:int = 0; k < customer.customerMembers.length; k++) {
						// 担当者xmlを作成する.
						var member:CustomerMemberDto = customer.customerMembers.getItemAt(k) as CustomerMemberDto;
						var xmlitems:Array = CustomerMemberDto.convert2(member);
						if (!xmlitems)		continue;

						// 顧客xmlを作成する.
						var memberXml:XML = new XML("<member></member>");
						for (var x:int = 0; x < xmlitems.length; x++) {
							memberXml.appendChild(new XML(xmlitems[x]));
						}
						customerXml.appendChild(memberXml);
					}
				}
				// 顧客XMLを root に追加する.
				root.appendChild(customerXml);
			}
		 	return root;
		 }

		/**
		 * 顧客XMLの変換.
		 * @param  value メンバ値.
		 * @return XML設定値.
		 */
		 public static function setXmlData(value:String):String
		 {
		 	if (value)			return value;
		 	else				return "";
		 }

		/**
		 * 顧客XMLの変換.
		 * @param  value メンバ値.
		 * @return XML設定値.
		 */
		 public static function setXmlData_date(value:Date):String
		 {
			var date:String = DateField.dateToString(value, "YYYY/MM/DD");
		 	if (date)			return date;
		 	else				return "";
		 }
	}
}