package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 社員スキルシート情報Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffSkillSheetDto")]
	public class StaffSkillSheetDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:Number;
		
		/**
		 * スキルシート連番です。
		 */
		public var sequenceNo:Number;
		
		/**
		 * プロジェクトIDです。
		 */
		public var projectId:Number;
		
		/**
		 * プロジェクトコードです。
		 */
		public var projectCode:String;
		
		/**
		 * プロジェクト名です。
		 */
		public var projectName:String;
		
		/**
		 * 件名です。
		 */
		public var title:String;
		
		/**
		 * 区分IDです。
		 */
		public var kindId:Number;
		
		/**
		 * 区分名です。
		 */
		public var kindName:String;
		
		/**
		 * 期間開始日です。
		 */
		public var joinDate:Date;
		
		/**
		 * 期間終了日です。
		 */
		public var retireDate:Date;
		
		/**
		 * ハードウェアです。
		 */
		public var hardware:String;
		
		/**
		 * OSです。
		 */
		public var os:String;
		
		/**
		 * 言語です。
		 */
		public var language:String;
		
		/**
		 * キーワードです。
		 */
		public var keyword:String;
		
		/**
		 * 担当した内容です。
		 */
		public var content:String;
		
		/**
		 * 登録日時です。
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録者IDです。
		 */
		public var registrantId:Number;
		
		/**
		 * 社員スキルシート作業フェーズ
		 */
		public var staffSkillSheetPhaseList:ArrayCollection;
		
		/**
		 * 社員スキルシート参加形態
		 */
		public var staffSkillSheetPositionList:ArrayCollection;
		
		
		/**
		 * 社員スキルシート作業フェーズ取得処理(一覧表示用)
		 * 
		 * @return 社員スキルシート作業フェーズの内容をカンマ区切りにした文字列
		 */
		public function get Phase():String
		{
			var phase:String = new String();
			for each( var staffSkillSheetPhaseDto:StaffSkillPhaseDto in staffSkillSheetPhaseList)
			{
				if ( phase != "" )
				{
					phase += "、"
				}
				phase += staffSkillSheetPhaseDto.phaseCode;
			}
			return phase;
		}
		
		/**
		 * 社員スキルシート参加形態取得処理(一覧表示用)
		 * 
		 * @return 社員スキルシート参加形態の内容をカンマ区切りにした文字列
		 */
		public function get Position():String
		{
			var position:String = new String();
			for each( var staffSkillSheetPosition:StaffSkillPositionDto in staffSkillSheetPositionList)
			{
				if ( position != "" )
				{
					position += "、"
				}
				position += staffSkillSheetPosition.positionCode;
			}
			return position;
		}
		
		/**
		 * 社員スキルシート作業フェーズ取得処理(登録画面表示用)
		 * 
		 * @return 作業フェーズIDのリスト
		 */
		public function get PhaseIdList():Array
		{
			var phase:Array = new Array();
			for each( var staffSkillSheetPhaseDto:StaffSkillPhaseDto in staffSkillSheetPhaseList)
			{
				// 戻り値のリストに作業フェーズIDを追加
				phase.push(staffSkillSheetPhaseDto.phaseId.toString());
			}
			return phase;
		}

		/**
		 * 社員スキルシート参加形態取得処理(登録画面表示用)
		 * 
		 * @return 参加形態IDのリスト
		 */
		public function get PositionIdList():Array
		{
			var position:Array = new Array();
			for each( var staffSkillSheetPositionDto:StaffSkillPositionDto in staffSkillSheetPositionList)
			{
				// 戻り値のリストに参加形態IDを追加
				position.push(staffSkillSheetPositionDto.positionId.toString());
			}
			return position;
		}
		
//		/**
//		 * 社員スキルシート参加形態取得処理(登録画面表示用)
//		 * 
//		 * @return 参加形態ID
//		 */
//		public function get PositionId():String
//		{
//			var position:String = new String();
//			for each( var staffSkillSheetPosition:StaffSkillPositionDto in staffSkillSheetPositionList)
//			{
//				// 戻り値に参加形態IDを設定
//				position = staffSkillSheetPosition.positionId.toString();
//				break;
//			}
//			return position;
//		}
		
		/**
		 * 社員スキルシート作業フェーズ設定処理
		 * 
		 * @param phase 作業フェーズのリスト
		 */
		public function setPhaseList(phase:Array):void
		{
			staffSkillSheetPhaseList = new ArrayCollection(phase);
		}
		
		/**
		 * 社員スキルシート参加形態設定処理
		 * 
		 * @param position 参加形態のリスト
		 */
		public function setPositionList(position:Array):void
		{
			staffSkillSheetPositionList = new ArrayCollection(position);
		}
	}
}