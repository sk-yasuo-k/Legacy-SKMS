package services.personnelAffair.skill.dto;

import java.io.Serializable;

/**
 * ラベルDto
 * @author kengo-i
 *
 */
public class SkillLabelDto implements Serializable{
	
	static final long serialVersionUID = 1L;
	
	/**
	 * データ
	 */
	public int data;
	
	/**
	 * 表示名
	 */
	public String label;
	
	/**
	 * ID
	 */
	public String id;

	/**
	 * コード
	 */
	public String code;

	/**
	 * 名称
	 */
	public String name;
	
	
	/**
	 * デフォルトコンストラクタ()
	 */
	public SkillLabelDto(){
		
	}
	
	
}
