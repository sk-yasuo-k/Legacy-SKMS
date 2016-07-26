package services.accounting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;


/**
 * 交通機関別マスタ情報エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity(name="m_transportation_facilities")
public class TransportationFacility implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 交通機関IDです。
	 */
	@Id
	public int facilityId;

	/**
	 * 交通機関名。
	 */
	public String facilityName;
}