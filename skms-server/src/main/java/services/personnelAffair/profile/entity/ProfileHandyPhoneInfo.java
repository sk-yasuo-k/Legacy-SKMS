package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール携帯電話情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select hp.handy_phone_no_1 || '-' || hp.handy_phone_no_2 || '-' || hp.handy_phone_no_3 as handy_phone_no" +
				",hp.*" +
				" from m_staff_handy_phone as hp" +
				" where (hp.staff_id,hp.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from m_staff_handy_phone" +
					" where open_handy_phone_no = true" +
					" group by staff_id)" +
				")")
public class ProfileHandyPhoneInfo implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 更新回数です。
	 */
	public Integer updateCount;
	
	/**
	 * 携帯電話番号です。
	 */
	public String handyPhoneNo;
}
