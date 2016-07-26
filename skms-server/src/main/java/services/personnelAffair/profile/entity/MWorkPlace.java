package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * MWorkPlaceエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MWorkPlace implements Serializable {

    private static final long serialVersionUID = 1L;

    /** workPlaceIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer workPlaceId;

    /** workPlaseNameプロパティ */
    @Column(length = 16, nullable = true, unique = false)
    public String workPlaseName;

    /** MStaffWorkPlaceList関連プロパティ */
    @OneToMany(mappedBy = "MWorkPlace")
    public List<MStaffWorkPlace> MStaffWorkPlaceList;

    /** MStaffWorkPlaceList2関連プロパティ */
    @OneToMany(mappedBy = "MWorkPlace2")
    public List<MStaffWorkPlace> MStaffWorkPlaceList2;
}