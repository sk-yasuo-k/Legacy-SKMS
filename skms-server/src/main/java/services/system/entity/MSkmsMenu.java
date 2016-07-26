package services.system.entity;

import java.io.Serializable;

import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * メニューマスタ情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MSkmsMenu implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * メニューIDです。
	 */
	@Id
	public int skmsMenuId;
	
	/**
	 * メニュー名です。
	 */
	public String skmsMenuName;
	
	/**
	 * メニュー名です。
	 */
	public String skmsMenuAlias;
	
	/**
	 * メニューURLです。
	 */
	public String skmsMenuUrl;
	
	/**
	 * メニュー表示順です。
	 */
	public Integer skmsMenuSortOrder;
	
	/**
	 * 親メニューIDです。
	 */
	public Integer parentMenuId;
	
	/**
	 * アクセス権限です。
	 */
	public Integer authority;
	
	/**
	 * URL参照タイプです。
	 */
	public int urlRef;

}