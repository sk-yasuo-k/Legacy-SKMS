package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * スキルシートリストDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class StaffSkillListDto
	{
		/**
		 * スキルシートリストです。
		 */
		private var _staffSkillList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 * 
		 * @param DBからの取得結果
		 */
		public function StaffSkillListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:StaffSkillSheetDto in object)
			{
				tmpArray.push(tmp);
			}
			_staffSkillList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * スキルシートリスト取得処理
		 * 
		 * @return スキルシートリスト
		 */
		public function get StaffSkillList():ArrayCollection
		{
			return _staffSkillList;
		}
		
		/**
		 * スキルシートリスト更新処理
		 * 
		 * @param staffId 社員ID
		 * @param dto 更新するスキルシートDto
		 * @return 更新後のスキルシートリスト
		 */
		public function updateStaffSkillRecord(staffId:Number, dto:StaffSkillSheetDto):ArrayCollection
		{
			var bUpdate:Boolean = false;		// レコード更新有無
			var maxSequenceNo:Number = 0;		// 最大SeqNo
			
			// フィールドのスキルシートリストを元にリストを作成する
			var tmpArray:Array = new Array();
			for each(var tmp:StaffSkillSheetDto in _staffSkillList)
			{
				// SeqNoが一致した場合は引数のデータを設定する
				if( tmp.sequenceNo == dto.sequenceNo )
				{
					tmp = dto;
					bUpdate = true;
				}
				tmpArray.push(tmp);
				
				// 最大SeqNoの更新
				if ( maxSequenceNo < tmp.sequenceNo )
				{
					maxSequenceNo = tmp.sequenceNo;
				}
			}
			
			// 更新を行わなかった場合は末尾にデータを挿入
			if ( !bUpdate )
			{
				dto.staffId = staffId;					// 社員IDを設定する
				dto.sequenceNo = maxSequenceNo + 1;		// 最大SeqNo+1を設定する
				tmpArray.push(dto);
			}
			
			// フィールドのスキルシートリストを更新する
			_staffSkillList = new ArrayCollection(tmpArray);
			return _staffSkillList;
		}
		
		/**
		 * スキルシートリスト削除処理
		 * 
		 * @param dto 削除するスキルシートDto
		 * @return 削除後のスキルシートリスト
		 */
		public function deleteStaffSkillRecord(dto:StaffSkillSheetDto):ArrayCollection
		{
			// フィールドのスキルシートリストを元にリストを作成する
			var tmpArray:Array = new Array();
			for each(var tmp:StaffSkillSheetDto in _staffSkillList)
			{
				// SeqNoが一致しなかった場合のみデータを設定する
				if( tmp.sequenceNo != dto.sequenceNo )
				{
					tmpArray.push(tmp);
				}
			}
			
			// フィールドのスキルシートリストを更新する
			_staffSkillList = new ArrayCollection(tmpArray);
			return _staffSkillList;
		}
		
		/**
		 * 経験年数(制御系/業務系/保守)取得処理
		 * 
		 * @return 経験年数Dto
		 */
		public function get experienceYearsDto():ExperienceYearsDto
		{
			var experienceYears:ExperienceYearsDto = new ExperienceYearsDto();
			
			// スキルシートリストの数だけループする
			for ( var i:int=0; i < _staffSkillList.length; i++ )
			{
				var dto:Object = _staffSkillList.getItemAt(i);
				var kindId:Number = dto.kindId;			// 区分ID
				var joinDate:Date = dto.joinDate;		// 期間開始日
				var retireDate:Date = dto.retireDate;	// 期間終了日
				
				// 業務期間の経験年数を算出する
				var experienceYearsTemp:Number = 0.0;
				if ( joinDate != null && retireDate != null )
				{
					var diffYear:Number = retireDate.getFullYear() - joinDate.getFullYear();	// 差分(年)
					var diffMonth:Number = retireDate.getMonth() - joinDate.getMonth();			// 差分(月)
					var diffDate:Number = retireDate.getDate() - joinDate.getDate();			// 差分(日)
					
					// 差分(年)の反映
					if ( diffYear != 0 )
					{
						experienceYearsTemp += diffYear;
					}
					
					// 差分(月)の反映
					if ( diffMonth != 0 )
					{
						experienceYearsTemp += diffMonth / 12.0;
					}
					
					// 差分(日)の反映
					if ( diffDate != 0 )
					{
						experienceYearsTemp += diffDate / (12.0 * 30);
					}
				}
				
				// 区分IDごとに振り分ける
				switch ( kindId )
				{
				case 1:		// 制御系
					experienceYears.control += experienceYearsTemp;
					break;
				case 2:		// 業務系
					experienceYears.open += experienceYearsTemp;
					break;
				case 3:		// 保守
					experienceYears.maintenance += experienceYearsTemp;
					break;
				}
			}
			
			// 小数点以下1位で四捨五入する
			experienceYears.control = Math.round(experienceYears.control*100)/100;
			experienceYears.open = Math.round(experienceYears.open*100)/100;
			experienceYears.maintenance = Math.round(experienceYears.maintenance*100)/100;
			
			return experienceYears;
		}
		
	}
}