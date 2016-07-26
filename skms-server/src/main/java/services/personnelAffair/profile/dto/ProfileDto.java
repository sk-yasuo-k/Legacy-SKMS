package services.personnelAffair.profile.dto;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Lob;

/**
 * プロフィール情報Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class ProfileDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * 社員名です。
	 */
	public String fullName;
	
	/**
	 * 性別IDです。
	 */
	public Integer sex;
	
	/**
	 * 性別名称です。
	 */
	public String sexName;
	
	/**
	 * 生年月日です。
	 */
	public Date birthday;

	/**
	 * 年齢です。
	 */
	public Integer age;
	
	/**
	 * 血液型IDです。
	 */
	public Integer bloodGroup;
	
	/**
	 * 血液型名称です。
	 */
	public String bloodGroupName;
	
	/**
	 * 入社年月日です。
	 */
	public Date joinDate;
	
	/**
	 * 退職年月日です。
	 */
	public Date retireDate;
	
	/**
	 * 部署IDです。
	 */
	public Integer departmentId;
	
	/**
	 * 部署名です。
	 */
	public String departmentName;
	
	/**
	 * プロジェクトIDです。
	 */
	public Integer projectId;
	
	/**
	 * プロジェクトコードです。
	 */
	public String projectCode;
	
	/**
	 * プロジェクト名です。
	 */
	public String projectName;
	
	/**
	 * 委員会IDです。
	 */
	public Integer committeeId;
	
	/**
	 * 委員会名称です。
	 */
	public String committeeName;
	
	/**
	 * 内線番号です。
	 */
	public String extensionNumber;	
	
	/**
	 * メールアドレスです。
	 */
	public String email;
	
	/**
	 * 電話番号です。
	 */
	public String homePhoneNo;
	
	/**
	 * 携帯番号です。
	 */
	public String handyPhoneNo;
	
	/**
	 * 郵便番号です。
	 */
	public String postalCode;
	
	/**
	 * 住所１です。
	 */
	public String address1;
	
	/**
	 * 住所２です。
	 */
	public String address2;
	
	/**
	 * 緊急連絡先です。
	 */
	public String emergencyAddress;
	
	/**
	 * 本籍地です。
	 */
	public String legalDomicileName;
	
	/**
	 * 入社前経験年数です。
	 */
	public Integer beforeExperienceYears;
	
	/**
	 * 勤続年数です。
	 */
	public Integer serviceYears;
	
	/**
	 * 経験年数です。
	 */
	public Integer totalExperienceYears;
	
	/**
	 * 勤務状態IDです。
	 */
	public Integer workStatusId;
	
	/**
	 * 勤務状態です。
	 */
	public String workStatusName;
	
	/**
	 * セキュリティカード番号です。
	 * ※未設定
	 */
	
	/**
	 * YRPカード番号です。
	 * ※未設定
	 */
	
	/**
	 * 保険証記号です。
	 * ※未設定
	 */
	
	/**
	 * 保険証番号です。
	 * ※未設定
	 */
	
	/**
	 * 年金手帳番号です。
	 * ※未設定
	 */
	
	/**
	 * 資格（等級数）です。
	 */
	public Integer basicClassNo;
	
	/**
	 * 資格（等級名）です。
	 */
	public String basicClassName;
	
	/**
	 * 資格（号）です。
	 */
	public Integer basicRankNo;
	
	/**
	 * 基本給です。
	 */
	public Integer basicMonthlySum;
	
	/**
	 * 職務等級です。
	 */
	public Integer managerialClassNo;
	
	/**
	 * 職務手当です。
	 */
	public Integer managerialMonthlySum;
	
	/**
	 * 主務等級です。
	 */
	public Integer competentClassNo;
	
	/**
	 * 主務手当です。
	 */
	public Integer competentMonthlySum;
	
	/**
	 * 技能等級です。
	 */
	public Integer technicalSkillClassNo;
	
	/**
	 * 技能手当です。
	 */
	public Integer technicalSkillMonthlySum;
	
	/**
	 * 情報処理資格保有です。
	 */
	public String informationPayName;	
	
	/**
	 * 住宅補助手当IDです。
	 */
	public Integer housingId;
	
	/**
	 * 住宅補助手当です。
	 */
	public Integer housingMonthlySum;
	
/** プロフィール詳細用追加分(伊藤) */
	/**
	 * 姓です。
	 */
	public String lastName;

	/**
	 * 名です。
	 */
	public String firstName;

	/**
	 * 姓(かな)です。
	 */
	public String lastNameKana;

	/**
	 * 名(かな)です。
	 */
	public String firstNameKana;	
	
	/**
	 * 連絡のとりやすい社員です。
	 */
	public String associateStaff;	
	
	/**
	 * 社員画像です。
	 */
	@Lob
	public byte[] staffImage;	
	
/** プロフィール一覧用追加分(伊藤) */
	
	/**
	 * 部署長です。
	 */
	public String departmentHead;		
	
	/**
	 * 役職です。
	 */
	public String projectPosition;		
	
	/**
	 * 経営役職です。
	 */
	public String managerialPosition;	
	
	/**
	 * 最終学歴です。
	 */
	public String academicBackground;		
}
