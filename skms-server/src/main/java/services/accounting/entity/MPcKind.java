package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * PC種別情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MPcKind implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * PC種別IDです。
	 */
	@Id
	public int pcKindId;

	/**
	 * PC種別名です。
	 */
	public String pcKindName;
}
