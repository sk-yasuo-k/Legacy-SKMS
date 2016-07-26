package services.mail.mai;

import java.text.NumberFormat;

import org.seasar.framework.util.StringUtil;

import services.generalAffair.entity.WorkingHoursMonthly;

/**
 * 勤務表関連メール情報です。

 *
 * @author yasuo-k
 *
 */
public class MailWorkingHoursDto {

    /**
	 * コンストラクタ

	 */
    public MailWorkingHoursDto(WorkingHoursMonthly workingHoursMonthly) {
		this.setApplicantName(workingHoursMonthly.staffName.fullName);
		this.setWorkingYear(workingHoursMonthly.workingMonthCode);
		this.setWorkingMonth(workingHoursMonthly.workingMonthCode);
		
		NumberFormat df = NumberFormat.getInstance();
		df.setMinimumFractionDigits(2);
		df.setMaximumFractionDigits(2);
		
		// 勤務時間
		this.setBalanceHours(df.format(workingHoursMonthly.balanceHours));
		this.setPrivateHours(df.format(workingHoursMonthly.privateHours));
		this.setWorkingHours(df.format(workingHoursMonthly.workingHours));
		this.setRecessHours(df.format(workingHoursMonthly.recessHours));
		this.setRealWorkingHours(df.format(workingHoursMonthly.realWorkingHours));
		
		// 控除数
		this.setDeductionCount(df.format(workingHoursMonthly.deductionCount));
		this.setAbsenceCount(Integer.toString(workingHoursMonthly.absenceCount));
		this.setAbsenceWithoutLeaveCount(Integer.toString(workingHoursMonthly.absenceWithoutLeaveCount));
		this.setNightWorkCount(Integer.toString(workingHoursMonthly.nightWorkCount));
		
		// 有給
		this.setLastPaidVacationCount(df.format(workingHoursMonthly.lastPaidVacationCount));
		this.setGivenPaidVacationCount(df.format(workingHoursMonthly.givenPaidVacationCount));
		this.setLostPaidVacationCount(df.format(workingHoursMonthly.lostPaidVacationCount));
		this.setTakenPaidVacationCount(df.format(workingHoursMonthly.takenPaidVacationCount));
		this.setCurrentPaidVacationCount(df.format(workingHoursMonthly.currentPaidVacationCount));
		
		// 代休
		this.setLastCompensatoryDayOffCount(df.format(workingHoursMonthly.lastCompensatoryDayOffCount));
		this.setGivenCompensatoryDayOffCount(df.format(workingHoursMonthly.givenCompensatoryDayOffCount));
		this.setLostCompensatoryDayOffCount(df.format(workingHoursMonthly.lostCompensatoryDayOffCount));
		this.setTakenCompensatoryDayOffCount(df.format(workingHoursMonthly.takenCompensatoryDayOffCount));
		this.setCurrentCompensatoryDayOffCount(df.format(workingHoursMonthly.currentCompensatoryDayOffCount));
    	
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
	 * (entity)勤務年です。

	 */
    private String _workingYear;
    
    public void setWorkingYear(String workingMonthCode_){
    	this._workingYear = workingMonthCode_.substring(0, 4);
    }
    
    public String getWorkingYear(){
    	return this._workingYear;
    }

    /**
	 * (entity)勤務月です。

	 */
    private String _workingMonth;
    
    public void setWorkingMonth(String workingMonthCode_){
    	this._workingMonth = workingMonthCode_.substring(4, 6);
    }
    
    public String getWorkingMonth(){
    	return this._workingMonth;
    }

    /**
	 * (entity)差引時間です。

	 */
    private String _balanceHours;
    
    public void setBalanceHours(String balanceHours_){
    	
    	this._balanceHours = String.format("%6s", balanceHours_);
    }
    
    public String getBalanceHours(){
    	return this._balanceHours;
    }
    
    /**
	 * (entity)私用時間です。

	 */
    private String _privateHours;
    
    public void setPrivateHours(String privateHours_){
    	this._privateHours = String.format("%6s", privateHours_);
    }
    
    public String getPrivateHours(){
    	return this._privateHours;
    }
    
    /**
	 * (entity)勤務時間です。

	 */
    private String _workingHours;
    
    public void setWorkingHours(String workingHours_){
    	this._workingHours = String.format("%6s", workingHours_);
    }
    
    public String getWorkingHours(){
    	return this._workingHours;
    }
    
    /**
	 * (entity)休憩時間です。

	 */
    private String _recessHours;
    
    public void setRecessHours(String recessHours_){
    	this._recessHours = String.format("%6s", recessHours_);
    }
    
    public String getRecessHours(){
    	return this._recessHours;
    }
    
    /**
	 * (entity)実働時間です。

	 */
    private String _realWorkingHours;
    
    public void setRealWorkingHours(String realWorkingHours_){
    	this._realWorkingHours = String.format("%6s", realWorkingHours_);
    }
    
    public String getRealWorkingHours(){
    	return this._realWorkingHours;
    }
    
    /**
	 * (entity)控除数です。

	 */
    private String _deductionCount;
    
    public void setDeductionCount(String deductionCount_){
    	this._deductionCount = String.format("%6s", deductionCount_);
    }
    
    public String getDeductionCount(){
    	return this._deductionCount;
    }
    
    /**
	 * (entity)欠勤日数です。

	 */
    private String _absenceCount;
    
    public void setAbsenceCount(String absenceCount_){
    	this._absenceCount = String.format("%6s", absenceCount_);
    }
    
    public String getAbsenceCount(){
    	return this._absenceCount;
    }
    
    /**
	 * (entity)無断欠勤日数です。

	 */
    private String _absenceWithoutLeaveCount;
    
    public void setAbsenceWithoutLeaveCount(String absenceWithoutLeaveCount_){
    	this._absenceWithoutLeaveCount = String.format("%6s", absenceWithoutLeaveCount_);
    }
    
    public String getAbsenceWithoutLeaveCount(){
    	return this._absenceWithoutLeaveCount;
    }
    
    /**
	 * (entity)深夜勤務日数です。

	 */
    private String _nightWorkCount;
    
    public void setNightWorkCount(String nightWorkCount_){
    	this._nightWorkCount = String.format("%6s", nightWorkCount_);
    }
    
    public String getNightWorkCount(){
    	return this._nightWorkCount;
    }
    
    /**
	 * (entity)有給繰越日数です。

	 */
    private String _lastPaidVacationCount;
    
    public void setLastPaidVacationCount(String lastPaidVacationCount_){
    	this._lastPaidVacationCount = String.format("%6s", lastPaidVacationCount_);
    }
    
    public String getLastPaidVacationCount(){
    	return this._lastPaidVacationCount;
    }
    
    /**
	 * (entity)有給発生日数です。

	 */
    private String _givenPaidVacationCount;
    
    public void setGivenPaidVacationCount(String givenPaidVacationCount_){
    	this._givenPaidVacationCount = String.format("%6s", givenPaidVacationCount_);
    }
    
    public String getGivenPaidVacationCount(){
    	return this._givenPaidVacationCount;
    }
    
    /**
	 * (entity)有給消滅日数です。

	 */
    private String _lostPaidVacationCount;
    
    public void setLostPaidVacationCount(String lostPaidVacationCount_){
    	this._lostPaidVacationCount = String.format("%6s", lostPaidVacationCount_);
    }
    
    public String getLostPaidVacationCount(){
    	return this._lostPaidVacationCount;
    }
    
    /**
	 * (entity)有給使用日数です。

	 */
    private String _takenPaidVacationCount;
    
    public void setTakenPaidVacationCount(String takenPaidVacationCount_){
    	this._takenPaidVacationCount = String.format("%6s", takenPaidVacationCount_);
    }
    
    public String getTakenPaidVacationCount(){
    	return this._takenPaidVacationCount;
    }
    
    /**
	 * (entity)有給今月残日数です。

	 */
    private String _currentPaidVacationCount;
    
    public void setCurrentPaidVacationCount(String currentPaidVacationCount_){
    	this._currentPaidVacationCount = String.format("%6s", currentPaidVacationCount_);
    }
    
    public String getCurrentPaidVacationCount(){
    	return this._currentPaidVacationCount;
    }
    
    /**
	 * (entity)代休繰越日数です。

	 */
    private String _lastCompensatoryDayOffCount;
    
    public void setLastCompensatoryDayOffCount(String lastCompensatoryDayOffCount_){
    	this._lastCompensatoryDayOffCount = String.format("%6s", lastCompensatoryDayOffCount_);
    }
    
    public String getLastCompensatoryDayOffCount(){
    	return this._lastCompensatoryDayOffCount;
    }
    
    /**
	 * (entity)代休発生日数です。

	 */
    private String _givenCompensatoryDayOffCount;
    
    public void setGivenCompensatoryDayOffCount(String givenCompensatoryDayOffCount_){
    	this._givenCompensatoryDayOffCount = String.format("%6s", givenCompensatoryDayOffCount_);
    }
    
    public String getGivenCompensatoryDayOffCount(){
    	return this._givenCompensatoryDayOffCount;
    }
    
    /**
	 * (entity)代休消滅日数です。

	 */
    private String _lostCompensatoryDayOffCount;
    
    public void setLostCompensatoryDayOffCount(String lostCompensatoryDayOffCount_){
    	this._lostCompensatoryDayOffCount = String.format("%6s", lostCompensatoryDayOffCount_);
    }
    
    public String getlostCompensatoryDayOffCount(){
    	return this._lostCompensatoryDayOffCount;
    }
    
    /**
	 * (entity)代休使用日数です。

	 */
    private String _takenCompensatoryDayOffCount;
    
    public void setTakenCompensatoryDayOffCount(String takenCompensatoryDayOffCount_){
    	this._takenCompensatoryDayOffCount = String.format("%6s", takenCompensatoryDayOffCount_);
    }
    
    public String getTakenCompensatoryDayOffCount(){
    	return this._takenCompensatoryDayOffCount;
    }
    
    /**
	 * (entity)代休今月残日数です。

	 */
    private String _currentCompensatoryDayOffCount;
    
    public void setCurrentCompensatoryDayOffCount(String currentCompensatoryDayOffCount_){
    	this._currentCompensatoryDayOffCount = String.format("%6s", currentCompensatoryDayOffCount_);
    }
    
    public String getCurrentCompensatoryDayOffCount(){
    	return this._currentCompensatoryDayOffCount;
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