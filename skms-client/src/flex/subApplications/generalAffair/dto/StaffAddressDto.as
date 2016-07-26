package subApplications.generalAffair.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 社員住所情報Dtoです。
	 *
	 * @author t-ito
	 *
	 */		
	public class StaffAddressDto
	{
		/** 社員住所リスト */
		private var _staffAddress:ArrayCollection;
		/** 社員住所データ */
		private var _staffAddressText:ChangeAddressApplyDto;
		/** 提出リスト */
		private var _newStaffAddress:ArrayCollection;
		/** 提出者リスト */
		private var _newStaffName:ArrayCollection;
		
		/** 
		 * コンストラクタ 
		 */
		public function StaffAddressDto(object:Object)
		{
			var tmpArray:Array  = new Array();
			var listArry:Array  = new Array();
			var labelArry:Array = new Array();
			var i:int = 0;
			for each(var tmp:ChangeAddressApplyDto in object){
				var list:ChangeAddressApprovalDto = new ChangeAddressApprovalDto();
				list.statusName  = tmp.addressStatusName;
				list.staffId     = tmp.staffId;
				list.fullName    = tmp.fullName;
				list.presentTime = tmp.presentTime;
				
				if(tmp.houseNumber == null){
					list.newAddress  = "〒" + tmp.postalCode1 + "-" + tmp.postalCode2 + " " + tmp.prefectureName + tmp.ward;					
				}else{
					list.newAddress  = "〒" + tmp.postalCode1 + "-" + tmp.postalCode2 + " " + tmp.prefectureName + tmp.ward + tmp.houseNumber;
				}
				
				list.statusId    = tmp.addressStatusId;
				
				var label:LabelDto = new LabelDto();
				label.data  = i;
				label.label = tmp.fullName;
				
				labelArry.push(label);
				listArry.push(list);
				tmpArray.push(tmp);
				i++;
			}
			_newStaffName     = new ArrayCollection(labelArry);
			_newStaffAddress  = new ArrayCollection(listArry);
			_staffAddress     = new ArrayCollection(tmpArray);
			_staffAddressText = tmpArray[0];
		}
		
		/**
		 * 住所データ取得
		 * 
		 */
		public function get StaffAddressText():ChangeAddressApplyDto
		{
			return _staffAddressText;
		}
		
		/**
		 * 住所の履歴リスト取得
		 * 
		 */
		public function get StaffAddress():ArrayCollection
		{
			return _staffAddress;
		}
		
		/**
		 * 提出リスト取得
		 * 
		 */
		public function get NewStaffAddress():ArrayCollection
		{
			return _newStaffAddress;
		}
		
		/**
		 * 提出者リスト取得
		 * 
		 */
		public function get NewStaffName():ArrayCollection
		{
			return _newStaffName;
		}		
	}
}