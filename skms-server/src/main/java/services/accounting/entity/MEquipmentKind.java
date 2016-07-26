package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 設備種別情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MEquipmentKind implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 設備種別IDです。
	 */
	@Id
	public int equipmentKindId;

	/**
	 * 設備種別名です。
	 */
	public String equipmentKindName;

}
