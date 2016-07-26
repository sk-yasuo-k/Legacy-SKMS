package subApplications.personnelAffair.authority.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 一覧項目表示設定Dtoです。
	 *
	 * @author t-ito
	 *
	 */	
	public class AuthorityProfileItemSelectDto
	{
		/**
		 * 表示可否一覧です。
		 */				
		public var displayItemsList:ArrayCollection;
			
		/**
		 * 表示可否一覧データ作成処理です。
		 */				
		public function AuthorityProfileItemSelectDto(displayItemsShowDto:Object)
		{
			displayItemsList = new ArrayCollection([
				{label:"社員コード", bool:displayItemsShowDto.staffId},
				{label:"氏名", bool:displayItemsShowDto.fullname},
				{label:"性別", bool:displayItemsShowDto.sexname},
				{label:"生年月日", bool:displayItemsShowDto.birthday},
				{label:"年齢", bool:displayItemsShowDto.age},
				{label:"血液型", bool:displayItemsShowDto.bloodgroupname},
				{label:"入社年月日", bool:displayItemsShowDto.joindate},
				{label:"退職年月日", bool:displayItemsShowDto.retiredate},
				{label:"所属", bool:displayItemsShowDto.departmentname},
				{label:"配属部署", bool:displayItemsShowDto.projectname},
				{label:"委員会", bool:displayItemsShowDto.committeename},
				{label:"内線番号", bool:displayItemsShowDto.extensionnumber},
				{label:"メールアドレス", bool:displayItemsShowDto.email},
				{label:"電話番号", bool:displayItemsShowDto.homephoneno},
				{label:"携帯番号", bool:displayItemsShowDto.handyphoneno},
				{label:"郵便番号", bool:displayItemsShowDto.postalcode},
				{label:"住所１", bool:displayItemsShowDto.address1},
				{label:"住所２", bool:displayItemsShowDto.address2},
				{label:"緊急連絡先", bool:displayItemsShowDto.emergencyaddress},
				{label:"本籍地", bool:displayItemsShowDto.legaldomicilename},
				{label:"入社前経験年数", bool:displayItemsShowDto.beforeexperienceyears},
				{label:"勤続年数", bool:displayItemsShowDto.serviceyears},
				{label:"経験年数", bool:displayItemsShowDto.totalexperienceyears},
				{label:"最終学歴", bool:displayItemsShowDto.academicBackground},
				{label:"勤務状態", bool:displayItemsShowDto.workstatusname},
				{label:"セキュリティカード番号", bool:displayItemsShowDto.securitycardno},
				{label:"YRPカード番号", bool:displayItemsShowDto.yrpcardno},
				{label:"保険証記号", bool:displayItemsShowDto.insurancepolicysymbol},
				{label:"保険証番号", bool:displayItemsShowDto.insurancepolicyno},
				{label:"年金手帳番号", bool:displayItemsShowDto.pensionpocketbookno},
				{label:"資格 等級", bool:displayItemsShowDto.basicclassno},
				{label:"号", bool:displayItemsShowDto.basicrankno},
				{label:"基本給", bool:displayItemsShowDto.basicmonthlysum},
				{label:"職務手当", bool:displayItemsShowDto.managerialmonthlysum},
				{label:"主務手当", bool:displayItemsShowDto.competentmonthlysum},
				{label:"技能手当", bool:displayItemsShowDto.technicalskillmonthlysum},
				{label:"情報処理資格保有", bool:displayItemsShowDto.informationPayName},
				{label:"住宅補助手当", bool:displayItemsShowDto.housingmonthlysum},
				{label:"所属部長", bool:displayItemsShowDto.departmenthead},
				{label:"役職", bool:displayItemsShowDto.projectposition},
				{label:"経営役職", bool:displayItemsShowDto.managerialposition}		
			])
		}

		/**
		 * 表示可否データ取得
		 * 
		 * @return 表示項目表示可否データ
		 */
		public function get AuthorityProfileItemSelectData():ArrayCollection
		{
			return displayItemsList;
		}	
	}
}