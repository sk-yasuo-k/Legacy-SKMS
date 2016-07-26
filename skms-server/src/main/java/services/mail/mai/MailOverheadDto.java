package services.mail.mai;

import java.text.NumberFormat;
import java.util.Currency;
import java.util.Locale;

import org.seasar.framework.util.StringUtil;

import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;


/**
 * 諸経費関連メール情報です。
 *
 * @author yasuo-k
 *
 */
public class MailOverheadDto {

    /**
	 * コンストラクタ
	 */
    public MailOverheadDto(Overhead overhead)
    {
		this.setOverheadId(overhead.overheadId);
		this.setApplicantName(overhead.staff.staffName.fullName);
		this.setProjectCode(overhead.projectE.projectCode);
		this.setProjectName(overhead.projectE.projectName);
		// 合計金額を計算する。
		int expense = 0;
		for (OverheadDetail overheadDetail : overhead.overheadDetails) {
			expense += overheadDetail.expense;
		}
		NumberFormat nf = NumberFormat.getCurrencyInstance();
		nf.setCurrency(Currency.getInstance(Locale.JAPAN));
		this.setExpense(nf.format(expense));

    }

    /**
	 * (entity)宛先アドレスです.
	 */
    private String _to;

    public void setTo(String to_){
    	this._to = to_;
    }

    public String getTo(){
    	return this._to;
    }

    /**
	 * (entity)宛先名です.
	 */
    private String _toName;

    public void setToName(String toName_){
    	this._toName = toName_;
    }

    public String getToName(){
    	return this._toName;
    }

    /**
	 * (entity)申請IDです.
	 */
    private int _overheadId;

    public void setOverheadId(int overheadId_){
    	this._overheadId = overheadId_;
    }

    public int getOverheadId(){
    	return this._overheadId;
    }

    /**
	 * (entity)申請者名です.
	 */
    private String _applicantName;

    public void setApplicantName(String applicantName_){
    	this._applicantName = applicantName_;
    }

    public String getApplicantName(){
    	return this._applicantName;
    }

    /**
	 * (entity)プロジェクトコードです.
	 */
    private String _projectCode;

    public void setProjectCode(String projectCode_){
    	this._projectCode = projectCode_;
    }

    public String getProjectCode(){
    	return this._projectCode;
    }

    /**
	 * (entity)プロジェクト名です.
	 */
    private String _projectName;

    public void setProjectName(String projectName_){
    	this._projectName = projectName_;
    }

    public String getProjectName(){
    	return this._projectName;
    }

    /**
	 * (entity)金額です.
	 */
    private String _expense;

    public void setExpense(String expense_){
    	this._expense = expense_;
    }

    public String getExpense(){
    	return this._expense;
    }

    /**
	 * (entity)承認者種別です.
	 */
    private String _approvalType;

    public void setApprovalType(String approvalType_){
    	this._approvalType = approvalType_;
    }

    public String getApprovalType(){
    	return this._approvalType;
    }

    /**
	 * (entity)承認者名です.
	 */
    private String _approvalName;

    public void setApprovalName(String approvalName_){
    	this._approvalName = approvalName_;
    }

    public String getApprovalName(){
    	return this._approvalName;
    }

    /**
	 * (entity)理由です.
	 */
    private String _reason;

    public void setReason(String reason_){
    	// メールのフォーマットに整形
    	reason_ = StringUtil.replace(reason_, "\r", "\r　　　　　　　　　　 ： ");
    	this._reason = reason_;
    }

    public String getReason(){
    	return this._reason;
    }

}