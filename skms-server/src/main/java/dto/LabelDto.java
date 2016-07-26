package dto;

import java.io.Serializable;

/**
 *  ラベル用Dtoです.
 *
 * @author yasuo-k
 *
 */
public class LabelDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * IDです.
	 */
	public int data;

	/**
	 * IDです.
	 */
	public String data2;
	
	/**
	 * IDです.
	 */
	public int data3;

	/**
	 * IDの名前です.
	 */
	public String label;

	/**
	 * 選択状態です.
	 */
	public boolean selected = false;

	/**
	 * 操作状態です.
	 */
	public boolean enabled = true;

	/**
	 * ツールヒントです.
	 */
	public String toolTip;
}