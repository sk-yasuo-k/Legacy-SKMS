package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * Seminarエンティティクラス
 *
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class Seminar implements Serializable {

    private static final long serialVersionUID = 1L;

    /** seminarIdプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer seminarId;

    /** seminarTitleプロパティ */
    @Column(columnDefinition ="text", nullable = false, unique = false)
    public String seminarTitle;

    /** startTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp startTime;

    /** endTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp endTime;

    /** placeプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String place;

    /** organizerプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String organizer;

    /** lecturerプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String lecturer;

    /** objectプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String object;

    /** capacityプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String capacity;

    /** feeプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer fee;

    /** contentプロパティ */
    @Column(columnDefinition ="text", nullable = true, unique = false)
    public String content;

    /** entryDeadlineプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp entryDeadline;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** seminarApplicantList関連プロパティ */
    @OneToMany(mappedBy = "seminar")
    public List<SeminarApplicant> seminarApplicantList;

    /** seminarApplicantList2関連プロパティ */
    @OneToMany(mappedBy = "seminar2")
    public List<SeminarApplicant> seminarApplicantList2;

    /** seminarParticipantList関連プロパティ */
    @OneToMany(mappedBy = "seminar")
    public List<SeminarParticipant> seminarParticipantList;

    /** seminarParticipantList2関連プロパティ */
    @OneToMany(mappedBy = "seminar2")
    public List<SeminarParticipant> seminarParticipantList2;
}