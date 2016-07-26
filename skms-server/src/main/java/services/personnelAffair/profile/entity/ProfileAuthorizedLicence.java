package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール認定資格情報エンティティクラスです。
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select sa.staff_id" +
				" , max(ia.information_pay_name) as information_pay_name" +
				" from m_staff_authorized_licence as sa" +
				" inner join m_authorized_licence al" +
				" on sa.licence_id = al.licence_id" +
				" inner join m_information_allowance ia" +
				" on al.information_pay_id = ia.information_pay_id" +
				" group by staff_id" +
				")")
public class ProfileAuthorizedLicence implements Serializable {
	
	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 情報処理手当名です。
	 */
	public String informationPayName;	
}
