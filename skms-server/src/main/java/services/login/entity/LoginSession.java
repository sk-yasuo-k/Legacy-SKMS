package services.login.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * セッション情報です。
 * 現グループウェアからの移行が完了すれば不要となる見込み。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class LoginSession implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * セッションIDです。
	 */
	@Id
	public String sessionId;

	/**
	 * ログイン名です。
	 */
	public String loginName;

}