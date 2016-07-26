package subApplications.customer.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	[Bindable]
	[RemoteClass(alias="services.customer.dto.CustomerMemberDto")]
	public class CustomerMemberDto
	{
		public function CustomerMemberDto()
		{
		}
		/**
		 * 顧客IDです,
		 */
		public var customerId:int;

		/**
		 * 顧客担当IDです,
		 */
		public var customerMemberId:int;

		/**
		  * 姓（漢字）です,
		  */
		public var lastName:String;

		/**
		  * 名（漢字）です,
		  */
		public var firstName:String;

		/**
		  * 姓（かな）です,
		  */
		public var lastNameKana:String;

		/**
		  * 名（かな）です,
		  */
		public var firstNameKana:String;

		/**
		  * 部署です,
		  */
		public var department:String;

		/**
		  * 役職です,
		  */
		public var position:String;

		/**
		  * Emailです,
		  */
		public var email:String;

		/**
		  * 電話です,
		  */
		public var telephone:String;

		/**
		  * 携帯電話です,
		  */
		public var telephone2:String;

		/**
		  * Faxです,
		  */
		public var fax:String;

		/**
		  * 備考です,
		  */
		public var note:String;

		 /**
		  * 登録バージョンです,
		  */
		public var registrationVer:int;

		 /**
		  * 取引開始日です,
		  */
		public var startDate:Date;

		/**
		  * 取引終了日です,
		  */
		public var finishDate:Date;

		/**
		  * 住所です,
		  */
		public var address:String;

		/**
		  * 郵便番号です,
		  */
		public var addressNo:String;

		/**
		 * 削除フラグです.
		 */
		public var isDelete:Boolean = false;


		/**
		 * 氏名です,（姓＋名）.
		 */
		public var fullName:String;

		/**
		 * 氏名です,（姓＋名 かな）.
		 */
		public var fullNameKana:String;


		/**
		 * 担当者作成.
		 *
		 * @param  customerId 顧客ID.
		 * @return 担当者.
		 */
		public static function newMember(customer:CustomerDto):CustomerMemberDto
		{
			var dst:CustomerMemberDto = new CustomerMemberDto();
			dst.customerId       = customer.customerId;
			var nMax:int = 20000; var nMin:int = 10000;
			var ran:int  = Math.floor(Math.random()*(nMax-nMin+1))+nMin;
			dst.customerMemberId = ran>0 ? (0-ran) : ran;
			return dst;
		}

		/**
		 * 担当者一致確認.
		 *
		 * @param comp1 担当者1.
		 * @param comp2 担当者2.
		 * @return 確認結果.
		 */
		public static function compare(comp1:CustomerMemberDto, comp2:CustomerMemberDto):Boolean
		{
			if (!(comp1 && comp2))	return false;
			if (ObjectUtil.compare(comp1.customerId, comp2.customerId) == 0 &&
				ObjectUtil.compare(comp1.customerMemberId, comp2.customerMemberId) == 0) {
				return true;
			}
			return false;
		}

		/**
		 * 担当者氏名の設定.
		 */
		public function setFullName():void
		{
			// 氏名を設定する.
			var lastname:String  = this.lastName;
			var firstname:String = this.firstName;
			this.fullName  =  lastname != null ? lastname : "";
			this.fullName  += (lastname != null && firstname != null) ? " " : "";
			this.fullName  += firstname != null ? firstname : "";

			// 氏名（かな）を設定する.
			lastname  = this.lastNameKana;
			firstname = this.firstNameKana;
			this.fullNameKana  =  lastname != null ? lastname : "";
			this.fullNameKana  += (lastname != null && firstname != null) ? " " : "";
			this.fullNameKana  += firstname != null ? firstname : "";
		}

		/**
		 * 担当者を作成する.
		 *
		 * @param members  担当者リスト.
		 * @param membersD 解除担当者リスト.
		 * @return 担当者リスト.
		 */
		 public static function createMembers(members:ArrayCollection, membersD:ArrayCollection):ArrayCollection
		 {
			var dst:ArrayCollection = new ArrayCollection();

			// 登録担当者を設定する.
			if (members) {
				for (var i:int = 0; i < members.length; i++) {
					var member:CustomerMemberDto = members.getItemAt(i) as CustomerMemberDto;
					dst.addItem(member);
				}
			}

			// 解除担当者を設定する.
			if (membersD) {
				for (var k:int = 0; k < membersD.length; k++) {
					var memberD:CustomerMemberDto = membersD.getItemAt(k) as CustomerMemberDto;
					memberD.isDelete = true;
					dst.addItem(memberD);
				}
			}
			return dst;
		}


		/**
		 * 顧客IDを取得する.
		 *
		 * @return 顧客担当者ID.
		 */
		 public function getCustomerMemberIdToString():String
		 {
		 	return this.customerMemberId.toString();
		 }

		/**
		 * 氏名を取得する.
		 *
		 * @return 氏名.
		 */
		 public function getFullName():String
		 {
		 	return this.fullName;
		 }


		/**
		 * 担当者XMリストLの変換.
		 *
		 * @param  customer 顧客情報.
		 * @param  xmllist  担当者XMLリスト.
		 * @return 担当者情報リスト.
		 */
		 public static function convert(customer:CustomerDto, xmllist:XMLList):ArrayCollection
		 {
		 	var list:ArrayCollection = new ArrayCollection();
		 	if (!xmllist)	return list;


			// 担当者情報XMLリストを取得する.
			for (var index:int = 0; index < xmllist.length(); index++) {
				// 担当者情報を取得する.
				var memberXml:XML = xmllist[index];
				var memberVal:String = null;

				// 担当者情報を設定する.
				var dst:CustomerMemberDto = CustomerMemberDto.newMember(customer);
				memberVal = CustomerDto.getXmlData(memberXml, "lastName");			// 姓（漢字）.
				if (memberVal)	dst.lastName = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "firstName");			// 名（漢字）.
				if (memberVal)	dst.firstName = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "lastNameKana");		// 姓（かな）.
				if (memberVal)	dst.lastNameKana = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "firstNameKana");		// 名（かな）.
				if (memberVal)	dst.firstNameKana = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "department");		// 部署.
				if (memberVal)	dst.department = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "position");			// 役職.
				if (memberVal)	dst.position = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "telephone");			// 電話.
				if (memberVal)	dst.telephone = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "fax");				// FAX.
				if (memberVal)	dst.fax = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "telephone2");		// 携帯電話.
				if (memberVal)	dst.telephone2 = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "email");				// Email.
				if (memberVal)	dst.email = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "addressNo");			// 郵便番号.
				if (memberVal)	dst.addressNo = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "address");			// 住所.
				if (memberVal)	dst.address = memberVal;

				memberVal = CustomerDto.getXmlData(memberXml, "note");				// 備考.
				if (memberVal)	dst.note = memberVal;

				// 氏名を作成する.
				dst.setFullName();
				if (dst.fullName.length == 0) {
					var memberno:String = (index + 1).toString();
					dst.fullName = "担当者 " + memberno;
				}
				// 担当者を追加する.
				list.addItem(dst);
			}
			return list;
		 }

		/**
		 * 担当者のXML変換.
		 * @param  member 担当者.
		 * @return 担当者XMLリスト.
		 */
		 public static function convert2(member:CustomerMemberDto):Array
		 {
		 	var array:Array = new Array();
		 	if (!member)		return array;

			var val:String;
			var xmlstring:String;

			val = CustomerDto.setXmlData(member.lastName);						// 姓（漢字）.
			xmlstring = "<lastName>"+ val +"</lastName>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.firstName);						// 名（漢字）.
			xmlstring = "<firstName>"+ val +"</firstName>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.lastNameKana);					// 姓（かな）.
			xmlstring = "<lastNameKana>"+ val +"</lastNameKana>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.firstNameKana);					// 名（かな）.
			xmlstring = "<firstNameKana>"+ val +"</firstNameKana>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.department);					// 部署.
			xmlstring = "<department>"+ val +"</department>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.position);						// 役職.
			xmlstring = "<position>"+ val +"</position>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.telephone);						// 電話.
			xmlstring = "<telephone>"+ val +"</telephone>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.fax);							// FAX.
			xmlstring = "<fax>"+ val +"</fax>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.telephone2);					// 携帯電話.
			xmlstring = "<telephone2>"+ val +"</telephone2>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.email);							// Email.
			xmlstring = "<email>"+ val +"</email>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.addressNo);						// 郵便番号.
			xmlstring = "<addressNo>"+ val +"</addressNo>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.address);						// 住所.
			xmlstring = "<address>"+ val +"</address>";
			array.push(xmlstring);

			val = CustomerDto.setXmlData(member.note);							// 備考.
			xmlstring = "<note>"+ val +"</note>";
			array.push(xmlstring);

		 	return array;
		 }
	}
}