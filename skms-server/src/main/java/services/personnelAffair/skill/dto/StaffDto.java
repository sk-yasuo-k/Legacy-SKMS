package services.personnelAffair.skill.dto;

import java.util.Date;
import java.util.List;

/**
 * 社員詳細情報Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffDto {

	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * 社員名です。
	 */
	public String fullName;
	
	/**
	 * 性別です。
	 */
	public String sex;
	
	/**
	 * 生年月日です。
	 */
	public Date birthday;

	/**
	 * 年齢です。
	 */
	public Integer age;
	
	/**
	 * 入社日です。
	 */
	public Date occuredDate;
	
	/**
	 * 経験年数です。
	 */
	public Integer experienceYears;
	
	/**
	 * 役職です。
	 */
	public String managerialPositionName;
	
	/**
	 * 職種です。
	 */
	public String occupationalCategoryName;
	
	/**
	 * 所属部署です。
	 */
	public String departmentName;
	
	/**
	 * 最終学歴です。
	 */
	public String finalAcademicBackground;
	
	/**
	 * 社員所持認定資格です。
	 */
	public List<StaffAuthorizedLicenceDto> staffAuthorizedLicence;
	
	/**
	 * 社員所持その他資格です。
	 */
	public List<StaffOtherLocenceDto> staffOtherLocence;
	
	/**
	 * コンストラクタです。
	 */
	public StaffDto(){
		
	}
	
}
