package services.generalAffair.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;


/**
 * 委員会マスタです。
 * 
 * @author Sumi-nobuhiro
 * 
 */
public class MCommitteeDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 委員会ID
	 */
	@Id
	@GeneratedValue
	public int committeeId;
			
	/**
	 * 委員会名
	 */
	public String committeeName;
					
	/**
	 * 備考
	 */
	public String note;
}
