package services.personnelAffair.license.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 等級マスタエンティティクラス
 * 
 */
@Entity
public class MBasicClass implements Serializable {

    private static final long serialVersionUID = 1L;
	
    /** Idプロパティ(連番)*/
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer Id;
    
    /** periodIdプロパティ(等級ID)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer classId;
    
    /** periodNameプロパティ(等級名)*/
    @Column(precision = 10, nullable = true, unique = false)
    public String className;
}
