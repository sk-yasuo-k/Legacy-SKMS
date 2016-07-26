package services.system.dto;

import java.io.Serializable;
import java.util.List;

/**
 * TreeDtoです.
 *
 * @author yasuo-k
 *
 */
public class TreeDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * IDです.
	 */
	public Integer id;

	/**
	 * 名称です.
	 */
	public String label;
	
	/**
	 * 名称です.
	 */
	public String alias;

	/**
	 * URLです.
	 */
	public String url;
	
	/**
	 * 表示順です.
	 */
	public Integer sortOrder;
	
	/**
	 * childrenです.
	 */
	public List<TreeDto> children;
	
	/**
	 * 操作可否フラグです.
	 */
	public boolean enabled = true;
	
	/**
	 * メモです.
	 */
	public String memo;
	
	/**
	 * URL参照タイプです。
	 */
	public int urlRef;
	
}