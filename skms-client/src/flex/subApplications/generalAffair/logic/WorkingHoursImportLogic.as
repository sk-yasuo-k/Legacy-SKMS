package subApplications.generalAffair.logic
{
    import dto.StaffDto;
    
    import flash.events.*;
    import flash.net.*;
    import flash.system.Security;
    
    import logic.Logic;
    
    import mx.controls.*;
    import mx.core.Application;
    import mx.events.*;
    import mx.managers.*;
    import mx.states.*;
    
    import subApplications.generalAffair.web.UploadProgress;
    import subApplications.generalAffair.web.WorkingHoursImport;
    
    import utils.CommonIcon;
    
	/**
	 * WorkingHoursUploadのLogicクラスです。

	 */
	public class WorkingHoursImportLogic extends Logic
	{
	    private const _strUploadDomain:String = "/skms-server/workingHoursFileImport";
	    private const _strUploadScript:String = _strUploadDomain;
	    
	    private var _arrUploadFiles:Array = new Array();
	    private var _numCurrentUpload:Number = 0;
	    private var _refAddFiles:FileReferenceList;    
	    private var _refUploadFile:FileReference;
	    
	    private var _uploadProgress:UploadProgress;
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function WorkingHoursImportLogic()
		{
			super();
		}


//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {
            // PMまたは総務部長ならば
            var staff:StaffDto = Application.application.indexLogic.loginStaff;
            if (staff.isProjectPositionPM() || staff.isDepartmentHeadGA()) {
            	view.chkApproval.visible = true;
            	view.chkApproval.selected = true;
            }
	        _arrUploadFiles = new Array();
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
	    // Called to add file(s) for upload
	    public function onClick_btnAdd():void {
	        _refAddFiles = new FileReferenceList();
	        _refAddFiles.addEventListener(Event.SELECT, onSelectFile);
	        _refAddFiles.browse();
	    }
	    
	    // Called to remove selected file(s) for upload
	    public function onClick_btnRemove():void {
	        var arrSelected:Array = view.grdFiles.selectedItems;
	        for (var i:Number = 0; i < arrSelected.length; i++) {
	            _arrUploadFiles[_arrUploadFiles.indexOf(arrSelected[i])] = null;
	        }
	        for (var j:Number = 0; j < _arrUploadFiles.length; j++) {
	            if (_arrUploadFiles[j] == null) {
	                _arrUploadFiles.splice(j, 1);
	                j--;
	            }
	        }
	        view.grdFiles.dataProvider = _arrUploadFiles;
	        view.grdFiles.selectedIndex = 0;
	        if (_arrUploadFiles.length == 0) {
	            view.btnUpload.enabled = false;
	        } else {
	            view.btnUpload.enabled = true;
	        }
	    }
	    
	    // Called to remove selected file(s) for upload
	    public function onClick_btnRemoveAll():void {
	    	_arrUploadFiles = new Array();
	        view.grdFiles.dataProvider = _arrUploadFiles;
	    }
	    
	    // Called to upload file based on current upload number
	    public function onClick_btnUpload(booIsFirst:Boolean, booOverwriteConfirm:Boolean):void {
	        if (booIsFirst) {
	            _numCurrentUpload = 0;
	        }
	        if (_arrUploadFiles.length > 0) {
//	            _uploadProgress = UploadProgress(PopUpManager.createPopUp(view, UploadProgress, true));
//	            _uploadProgress.btnCancel.removeEventListener("click", onUploadCanceled);
//	            _uploadProgress.btnCancel.addEventListener("click", onUploadCanceled);
//	            _uploadProgress.title = "Uploading file to " + _strUploadDomain;
//	            _uploadProgress.txtFile.text = _arrUploadFiles[_numCurrentUpload].label;
//	            _uploadProgress.progBar.label = "0%";
//	            PopUpManager.centerPopUp(_uploadProgress);
				
	            _arrUploadFiles[_numCurrentUpload].status = "";
		    	_arrUploadFiles[_numCurrentUpload].color = 0x000000;
		    	view.grdFiles.selectedIndex = _numCurrentUpload;
		    	view.grdFiles.scrollToIndex(_numCurrentUpload);

	            // Variables to send along with upload
	            var sendVars:URLVariables = new URLVariables();
	            var staff:StaffDto = Application.application.indexLogic.loginStaff;
	            sendVars.loginStaffId = staff.staffId;
				// PMまたは総務部長ならば
	            if (staff.isProjectPositionPM() || staff.isDepartmentHeadGA()) {
		            sendVars.isManagementMode = true;
	            } else {
		            sendVars.isManagementMode = false;
	            }
	            sendVars.doOverwriteConfirmation = booOverwriteConfirm;
	            sendVars.doApproval = view.chkApproval.selected;
	            
	            var request:URLRequest = new URLRequest(_strUploadScript);
	            request.url = _strUploadScript;
	            request.method = URLRequestMethod.GET;
	            request.data = sendVars;
	            _refUploadFile = new FileReference();
	            _refUploadFile = _arrUploadFiles[_numCurrentUpload].data;
	            _refUploadFile.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
	            _refUploadFile.addEventListener(Event.COMPLETE, onUploadComplete);
	            _refUploadFile.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
	            _refUploadFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
				_refUploadFile.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);// ファイル送信完了の応答受信.
	            _refUploadFile.upload(request, "file", false);
	        }
	    }
	    
//--------------------------------------
//  Function
//--------------------------------------
	    // Called when a file is selected
	    private function onSelectFile(event:Event):void {
	        Security.allowDomain("*");
	        var arrFoundList:Array = new Array();
	        // Get list of files from fileList, make list of files already on upload list
	        for (var i:Number = 0; i < _arrUploadFiles.length; i++) {
	            for (var j:Number = 0; j < _refAddFiles.fileList.length; j++) {
	                if (_arrUploadFiles[i].fileName == _refAddFiles.fileList[j].name) {
	                    arrFoundList.push(_refAddFiles.fileList[j].name);
	                    _refAddFiles.fileList.splice(j, 1);
	                    j--;
	                }
	            }
	        }
	        if (_refAddFiles.fileList.length >= 1) {
	            for (var k:Number = 0; k < _refAddFiles.fileList.length; k++) {
	                _arrUploadFiles.push({fileName:_refAddFiles.fileList[k].name, data:_refAddFiles.fileList[k]});
	            }
	            view.grdFiles.dataProvider = _arrUploadFiles;
	            view.grdFiles.selectedIndex = _arrUploadFiles.length - 1;
	        }                
	        if (arrFoundList.length >= 1) {
//	            Alert.show("The file(s): \n\n• " + arrFoundList.join("\n• ") + "\n\n...are already on the upload list. Please change the filename(s) or pick a different file.", "File(s) already on list");
	        }
	        if (_arrUploadFiles.length == 0) {
	            view.btnUpload.enabled = false;
	        } else {
	            view.btnUpload.enabled = true;
	        }
	    }
	    
	    
		private function onClose_overwriteAlert(e:CloseEvent):void
		{
			var msg:String = "失敗(勤務管理表が既に存在します。)";
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.CANCEL) {
		    	_arrUploadFiles[_numCurrentUpload].status = msg;
		    	view.grdFiles.selectedIndices = view.grdFiles.selectedIndices;
				return;
			} else if (e.detail == Alert.NO){
		    	_arrUploadFiles[_numCurrentUpload].status = msg;
		    	view.grdFiles.selectedIndices = view.grdFiles.selectedIndices;
		        _numCurrentUpload++;
			}
	        if (_numCurrentUpload < _arrUploadFiles.length) {
	            onClick_btnUpload(false, e.detail != Alert.YES);
       		}
	    }
	    
	    // Cancel and clear eventlisteners on last upload
	    private function clearUpload():void {
	        _numCurrentUpload = 0;
	        _refUploadFile.removeEventListener(ProgressEvent.PROGRESS, onUploadProgress);
	        _refUploadFile.removeEventListener(Event.COMPLETE, onUploadComplete);
	        _refUploadFile.removeEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
	        _refUploadFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
	        _refUploadFile.cancel();
	    }
	    
	    // Called on upload cancel
	    private function onUploadCanceled(event:Event):void {
	        PopUpManager.removePopUp(_uploadProgress);
	        _uploadProgress == null;
	        _refUploadFile.cancel();
	        clearUpload();
	    }
	    
	    // Get upload progress
	    private function onUploadProgress(event:ProgressEvent):void {
	        var numPerc:Number = Math.round((Number(event.bytesLoaded) / Number(event.bytesTotal)) * 100);
	        var numBar:Number = numPerc / 100 * 25;
	        var sBar:String = "";
	        for (var i:Number = 0; i < numBar; i++) {
	        	sBar += "■";
	        } 
            _arrUploadFiles[_numCurrentUpload].status = sBar;
	    	view.grdFiles.selectedIndices = view.grdFiles.selectedIndices;
//	        _uploadProgress.progBar.setProgress(numPerc, 100);
//	        _uploadProgress.progBar.label = numPerc + "%";
//	        _uploadProgress.progBar.validateNow();
//	        if (numPerc > 90) {
//	            _uploadProgress.btnCancel.enabled = false;
//	        } else {
//	            _uploadProgress.btnCancel.enabled = true;
//	        }
	    }
	    
	    // Called on upload complete
	    private function onUploadComplete(event:Event):void {
	    }
	    
	    private function onUploadCompleteData(event:DataEvent):void {
			// trace (event.data);
			var xml:XML = new XML(event.data);
			var result:Number = parseInt(xml.result);
			
			if (result == 1) {
		    	_arrUploadFiles[_numCurrentUpload].status = "上書き確認";
		    	_arrUploadFiles[_numCurrentUpload].color = 0xfe0000;
				Alert.show("勤務管理表が存在します。上書きしてもよろしいですか？",
				 "",
				  Alert.YES | Alert.NO,
				   view,
				    onClose_overwriteAlert,
				    CommonIcon.questionIcon);
		    	
			} else {
				// 成功
				if (result == 0) {
			    	_arrUploadFiles[_numCurrentUpload].status = "成功";
			    	_arrUploadFiles[_numCurrentUpload].color = 0x000000;
				// 失敗
				} else {
			    	_arrUploadFiles[_numCurrentUpload].status = "失敗(" + xml.message +")";
			    	_arrUploadFiles[_numCurrentUpload].color = 0xfe0000;
				}
		        _numCurrentUpload++;
		        if (_numCurrentUpload < _arrUploadFiles.length) {
		            onClick_btnUpload(false, view.chkOverwriteConfirmation.selected);
	       		}
			}
	    	view.grdFiles.selectedIndices = view.grdFiles.selectedIndices;
	    }
	    
	    // Called on upload io error
	    private function onUploadIoError(event:IOErrorEvent):void {
	    	_arrUploadFiles[_numCurrentUpload].status = "失敗(" + event.text + ")";
	    	_arrUploadFiles[_numCurrentUpload].color = 0xfe0000;
	    	view.grdFiles.selectedIndices = view.grdFiles.selectedIndices;
//	        Alert.show("IO Error in uploading file.", "Error");
	        _numCurrentUpload++;
//	        PopUpManager.removePopUp(_uploadProgress);
	        if (_numCurrentUpload < _arrUploadFiles.length) {
	            onClick_btnUpload(false, view.chkOverwriteConfirmation.selected);
	        } else {
//	            Alert.show("File(s) have been uploaded.", "Upload successful");
	        }
//	        _uploadProgress == null;
//	        _refUploadFile.cancel();
//	        clearUpload();
	    }
	    
	    // Called on upload security error
	    private function onUploadSecurityError(event:SecurityErrorEvent):void {
	        Alert.show("Security Error in uploading file.", "Error");
	        PopUpManager.removePopUp(_uploadProgress);
	        _uploadProgress == null;
	        _refUploadFile.cancel();
	        clearUpload();
	    }
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkingHoursImport;

	    /**
	     * 画面を取得します

	     */
	    public function get view():WorkingHoursImport
	    {
	        if (_view == null) {
	            _view = super.document as WorkingHoursImport;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkingHoursImport):void
	    {
	        _view = view;
	    }

	}    
}