package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 委員会所属履歴Dtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class CommitteeListLogDto
	{
		private var _committeeListLog:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function CommitteeListLogDto(object:Object)
		{	
			//////////////////////////////
			// 初期値
			//////////////////////////////
			
			// 編集対象社員IDの初期値は「0」
			var nowStaffID:int = 0;
			
			// リスト型を空ににする
			var tmpArray:Array = new Array();
			
			// 期間の初期値は「」
			var Periodhead:String =  ""
			
			// 役職期間の初期値は「」
			var PeriodCommittee:String =  ""
			
			// リスト作成カウントの初期値は「0」
			// ■object.lengthの値との比較により、最後のリスト作成タイミングを確認する■
			var lengthCount:int = 0
			
			// 配列の中身が空の場合は空のリストを設定して返却
			if ( object.length == 0 )
			{
				_committeeListLog = new ArrayCollection(tmpArray);
				return;
			}
			
			// 最初の社員ＩＤを格納
			var firstDto:CommitteeDto = object.getItemAt(0) as CommitteeDto;
			nowStaffID = firstDto.staffId;
			
			// リストに格納するＤＴＯの準備（new）
		 	var dto:CommitteeDto = new CommitteeDto();
			var committeeFullName:String = ""
			var periodhead:String = ""
			var periodCommittee:String = ""
					
			//////////////////////////////
			// メンバーの履歴処理
			//////////////////////////////
			// 配列数分ループ
			for each(var tmp:CommitteeDto in object)
			{	
				// リスト作成カウントは「現在の値+1」とする
				lengthCount = lengthCount + 1
						
				// 社員ＩＤが変更されたかどうかを判定
				if(nowStaffID != tmp.staffId)
				{	
					dto.committeeFullName = committeeFullName
					dto.periodDate = periodhead
					dto.periodNameDate = periodCommittee
					
					// (社員名)・(期間)・(役員期間)リストに追加する
					tmpArray.push(dto);
					
					// 新たなＤＴＯを用意（newする）
					dto = new CommitteeDto();
					periodhead = ""
					periodCommittee = ""
				}
							
				// 対象社員IDをセット
				nowStaffID = tmp.staffId

				//////////////////////////////
				// 期間を内部変数に格納
				//////////////////////////////
				
				// 解除日が登録されていない場合
				var PeriodDate:String;
				if(tmp.cancelDate == null)
				{
					// 期間(適用日～)
					PeriodDate = tmp.applyDate.fullYear + "/" + (tmp.applyDate.month + 1) + "/" + tmp.applyDate.date + "～"
				}
				else
				{
					// 期間(適用日～解除日)
					PeriodDate = tmp.applyDate.fullYear + "/" + (tmp.applyDate.month + 1) + "/" + tmp.applyDate.date + "～" + tmp.cancelDate.fullYear + "/" + (tmp.cancelDate.month + 1) + "/" + tmp.cancelDate.date
				}		
					
				//////////////////////////////
				// 役職があるかどうかを判定してＤＴＯに格納
				//////////////////////////////
				// 役職が委員長
				// ⇒役職期間に「委員長：」を付けて追加格納
				if(tmp.committeePositionId == 1)
				{	
					// 空でない場合は改行する
					if(periodCommittee != "")
					{
						periodCommittee += "\n";
					}
					
					// 期間を結合する
					periodCommittee += "委員長:" + PeriodDate;
				}
				// 役職が副委員長
				// ⇒役職期間に「副委員長：」を付けて追加格納
				else if(tmp.committeePositionId == 2)
				{					
					// 空でない場合は改行する
					if(periodCommittee != "")
					{
						periodCommittee += "\n";
					}
					
					// 期間を結合する
					periodCommittee += "副委員長:" + PeriodDate;
				}
				// 役職がない
				// ⇒期間に格納
				else
				{
					// 空でない場合は改行する
					if(periodhead != "")
					{
						periodhead += "\n";
					}
					
					// 期間を結合する
					periodhead += PeriodDate;
				}
				
				// 社員名を格納する
				committeeFullName = tmp.fullName
				
				//////////////////////////////
				// 最後のＤＴＯをリストに追加
				//////////////////////////////
				
				if(object.length == lengthCount)
				{	
					// 「社員名」・「期間」・「役職期間」をDTOに格納する
					dto.committeeFullName = committeeFullName
					dto.periodDate = periodhead
					dto.periodNameDate = periodCommittee
											
					//「社員名」・「期間」・「役職期間」をリスト型に追加する
					tmpArray.push(dto)
				}								
			}
			// DTOの型に変換したものを、リストに追加する
			_committeeListLog = new ArrayCollection(tmpArray);
		}
		
		/**
		 * 履歴取得
		 */		
		public function get CommitteeListLog():ArrayCollection
		{
			return _committeeListLog;
		}
	}
}