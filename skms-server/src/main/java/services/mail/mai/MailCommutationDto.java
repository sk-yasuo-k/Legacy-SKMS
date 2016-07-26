package services.mail.mai;

import java.text.NumberFormat;
import java.util.Currency;
import java.util.Locale;

import org.seasar.framework.container.SingletonS2Container;
import org.seasar.framework.util.StringUtil;

import services.accounting.entity.Commutation;
import services.generalAffair.entity.MStaff;
import services.generalAffair.service.StaffService;

/**
 * 通勤費関連メール情報です。

 *
 * @author yasuo-k
 *
 */
public class MailCommutationDto {

    /**
	 * コンストラクタ

	 */
    public MailCommutationDto(Commutation commutation) {
		// StaffServiceオブジェクトの取得
		StaffService staffService = SingletonS2Container.getComponent(StaffService.class);
    	MStaff staff = staffService.getStaffInfo(commutation.staffId);
		this.setApplicantName(staff.staffName.fullName);
		this.setCommutationYear(commutation.commutationMonthCode);
		this.setCommutationMonth(commutation.commutationMonthCode);
		
		NumberFormat nf = NumberFormat.getCurrencyInstance();
		nf.setCurrency(Currency.getInstance(Locale.JAPAN));
		this.setPayment(nf.format(commutation.payment));
		
    }
    
    /**
	 * (entity)宛先アドレスです。

	 */
    private String _to;

    public void setTo(String to_){
    	this._to = to_;
    }
      
    public String getTo(){
    	return this._to;
    }

    /**
	 * (entity)宛先名です。

	 */
    private String _toName;
    
    public void setToName(String toName_){
    	this._toName = toName_;
    }
    
    public String getToName(){
    	return this._toName;
    }

    /**
	 * (entity)提出者名です。

	 */
    private String _applicantName;
    
    public void setApplicantName(String applicantName_){
    	this._applicantName = applicantName_;
    }
    
    public String getApplicantName(){
    	return this._applicantName;
    }

    /**
	 * (entity)申請年です。

	 */
    private String _commutationYear;
    
    public void setCommutationYear(String workingMonthCode_){
    	this._commutationYear = workingMonthCode_.substring(0, 4);
    }
    
    public String getCommutationYear(){
    	return this._commutationYear;
    }

    /**
	 * (entity)支給額です。

	 */
    private String _payment;
    
    public void setPayment(String payment_){
    	this._payment = payment_;
    }
    
    public String getPayment(){
    	return this._payment;
    }

    /**
	 * (entity)支給額です。

	 */
    private String _commutationMonth;
    
    public void setCommutationMonth(String workingMonthCode_){
    	this._commutationMonth = workingMonthCode_.substring(4, 6);
    }
    
    public String getCommutationMonth(){
    	return this._commutationMonth;
    }

    /**
	 * (entity)承認者種別です。

	 */
    private String _approvalType;
    
    public void setApprovalType(String approvalType_){
    	this._approvalType = approvalType_;
    }
    
    public String getApprovalType(){
    	return this._approvalType;
    }
    
    /**
	 * (entity)承認者名です。

	 */
    private String _approvalName;
    
    public void setApprovalName(String approvalName_){
    	this._approvalName = approvalName_;
    }
    
    public String getApprovalName(){
    	return this._approvalName;
    }

    /**
	 * (entity)理由です。

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