package services.personnelAffair.authority.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * リスト表示可否エンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
public class MProfileListChoices implements Serializable{

	private static final long serialVersionUID = 1L;
	
	
	/**
	 * 表示可否リスト番号です。
	 */
	@Id
	@GeneratedValue
	public int listChoicesId;
	
	/**
	 * 権限種別名
	 */
	@Column(length = 32, nullable = false)
	public String positionName;	

	/**
	 * 社員ID
	 */
	@Column(nullable = false)
	public Boolean staffid;		
	
	/**
	 * 氏名
	 */
	@Column(nullable = false)
	public Boolean fullname;	
	
	/**
	 * 性別
	 */
	@Column(nullable = false)
	public Boolean sexname;	
	
	/**
	 * 生年月日
	 */
	@Column(nullable = false)
	public Boolean birthday;	
	
	/**
	 * 年齢
	 */
	@Column(nullable = false)
	public Boolean age;		
	
	/**
	 * 血液型
	 */
	@Column(nullable = false)
	public Boolean bloodgroupname;	

	/**
	 * 郵便番号
	 */
	@Column(nullable = false)
	public Boolean postalcode;
	
	/**
	 * 住所１
	 */
	@Column(nullable = false)
	public Boolean address1;
	
	/**
	 * 住所２
	 */
	@Column(nullable = false)
	public Boolean address2;	

	/**
	 * 電話番号
	 */
	@Column(nullable = false)
	public Boolean homephoneno;
	
	/**
	 * 携帯番号
	 */
	@Column(nullable = false)
	public Boolean handyphoneno;	
	
	/**
	 * 入社年月日
	 */
	@Column(nullable = false)
	public Boolean joindate;	
	
	/**
	 * 退職年月日
	 */
	@Column(nullable = false)
	public Boolean retiredate;	
	
	/**
	 * 所属
	 */
	@Column(nullable = false)
	public Boolean departmentname;	
	
	/**
	 * 配属部署
	 */
	@Column(nullable = false)
	public Boolean projectname;	
	
	/**
	 * 委員会
	 */
	@Column(nullable = false)
	public Boolean committeename;
	
	/**
	 * 内線番号
	 */
	@Column(nullable = false)
	public Boolean extensionnumber;
	
	/**
	 * メールアドレス
	 */
	@Column(nullable = false)
	public Boolean email;
	
	/**
	 * 緊急連絡先
	 */
	@Column(nullable = false)
	public Boolean emergencyaddress;
	
	/**
	 * 本籍地
	 */
	@Column(nullable = false)
	public Boolean legaldomicilename;
	
	/**
	 * 入社前経験年
	 */
	@Column(nullable = false)
	public Boolean beforeexperienceyears;
	
	/**
	 * 勤続年数
	 */
	@Column(nullable = false)
	public Boolean serviceyears;
	
	/**
	 * 経験年数
	 */
	@Column(nullable = false)
	public Boolean totalexperienceyears;

	/**
	 * 最終学歴
	 */
	@Column(nullable = false)
	public Boolean academicBackground;	
	
	/**
	 * 勤務状態
	 */
	@Column(nullable = false)
	public Boolean workstatusname;
	
	/**
	 * セキュリティ
	 */
	@Column(nullable = false)
	public Boolean securitycardno;
	
	/**
	 * YRPカード番号
	 */
	@Column(nullable = false)
	public Boolean yrpcardno;
	
	/**
	 * 保険証記号
	 */
	@Column(nullable = false)
	public Boolean insurancepolicysymbol;
	
	/**
	 * 保険証番号
	 */
	@Column(nullable = false)
	public Boolean insurancepolicyno;
	
	/**
	 * 年金手帳番号
	 */
	@Column(nullable = false)
	public Boolean pensionpocketbookno;
	
	/**
	 * 資格 等級
	 */
	@Column(nullable = false)
	public Boolean basicclassno;
	
	/**
	 * 号
	 */
	@Column(nullable = false)
	public Boolean basicrankno;
	
	/**
	 * 基本給
	 */
	@Column(nullable = false)
	public Boolean basicmonthlysum;
	
	/**
	 * 職務手当
	 */
	@Column(nullable = false)
	public Boolean managerialmonthlysum;
	
	/**
	 * 主務手当
	 */
	@Column(nullable = false)
	public Boolean competentmonthlysum;
	
	/**
	 * 技能手当
	 */
	@Column(nullable = false)
	public Boolean technicalskillmonthlysum;
	
	/**
	 * 情報処理資格保有
	 */
	@Column(nullable = false)
	public Boolean informationpayname;
	
	/**
	 * 住宅補助手当
	 */
	@Column(nullable = false)
	public Boolean housingmonthlysum;

	/**
	 * 所属部長
	 */
	@Column(nullable = false)
	public Boolean departmenthead;

	/**
	 * 役職
	 */
	@Column(nullable = false)
	public Boolean projectposition;

	/**
	 * 経営役職
	 */
	@Column(nullable = false)
	public Boolean managerialposition;	
}
