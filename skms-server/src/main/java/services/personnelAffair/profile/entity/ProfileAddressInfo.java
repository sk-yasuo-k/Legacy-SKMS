package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール住所情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select a.home_phone_no_1 || '-' || a.home_phone_no_2 || '-' || a.home_phone_no_3 as home_phone_no" +
				",a.postal_code_1 || '-'  || a.postal_code_2 as postal_code" +
				",mp_address.name as prefecture_name" +
				",a.*" +
				" from m_staff_address as a" +
				" left outer join m_prefecture mp_address" +
				" on a.prefecture_code = mp_address.code" +
				" where (a.staff_id,a.update_count) in" +
					"(select staff_id, max(address_update_count)" +
					" from staff_address_history" +
					" where address_status_id = 7" +
					" group by staff_id)" +
				")")
public class ProfileAddressInfo implements Serializable {

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
	 * 自宅電話番号です。
	 */
	public String homePhoneNo;

	/**
	 * 郵便番号です。
	 */
	public String postalCode;
	
	/**
	 * 都道府県コードです。
	 */
	public String prefectureCode;
	
	/**
	 * 都道府県名称です。
	 */
	public String prefectureName;
	
	/**
	 * 市区町村・番地です。
	 */
	public String ward;
	
	/**
	 * ビルです。
	 */
	public String houseNumber;

	/**
	 * 連絡のとりやすい社員です。
	 */
	public String associateStaff;		
	
}
