package subApplications.generalAffair.workingConditions.dto
{
	import mx.collections.ArrayCollection;
	
	public class WorkingHoursMonthlyExtListDto
	{
		[Bindable]
		private var _result:ArrayCollection = new ArrayCollection();
				
		/**
		 * 一覧の作成(名前と社員ID)
		 * */
		public function WorkingHoursMonthlyExtListDto(src:Object):void
		{
			var tmpArray:Array = new Array();
			for each(var tmp:Object in src){
				var workingHoursMonthlyExtDto:WorkingHoursMonthlyExtDto = new WorkingHoursMonthlyExtDto();
				workingHoursMonthlyExtDto.staffId = tmp.staffId;
				workingHoursMonthlyExtDto.staffFullName = tmp.staffFullName;
				tmpArray.push(workingHoursMonthlyExtDto);
			}
			//TODO 合計・平均を追加するならここに処理追加
			
			_result = new ArrayCollection(tmpArray);
		}
		
		/**
		 * データの更新
		 * コンストラクタで作成した人のみデータ更新
		 * */
		public function update(src:Object):void
		{
			for each( var workingHoursMonthlyExtDto:Object in _result ){
//			for each( var workingHoursMonthlyExtDto:WorkingHoursMonthlyExtDto in _result ){
				workingHoursMonthlyExtDto.init();
				//初期化
				for each(var tmp:Object in src){
//				for each(var tmp:WorkingHoursMonthlyExtDto in src){					
					
					//社員IDが一致すれば更新					
					if( workingHoursMonthlyExtDto.update(tmp) ){
						break;
					}
				}
			}
			//TODO 合計・平均を追加するならここに処理追加			
		}
		
		/**
		 * 表示・非表示の一括変更
		 *   引数の値ですべて変更
		 * */
		public function changeAllShow( data:Boolean ):void
		{
			for each( var workingHoursMonthlyExtDto:Object in _result ){
				workingHoursMonthlyExtDto.show = data;
			}
		}
		
		/**
		 * 表示条件になっている社員ID一覧を取得
		 * */
		public function getShowStaffList():ArrayCollection
		{
			var staffList:Array = new Array();
			for each(var workingHoursMonthlyExtDto:Object in _result ){
				if( workingHoursMonthlyExtDto.show == true ){
					staffList.push(workingHoursMonthlyExtDto.staffId);
				}
			}
			return new ArrayCollection(staffList);
		}
		
		
		/**
		 * 	一覧用getter
		 * */
		public function get WorkingHoursMonthlyExtList():ArrayCollection
		{
			return _result;
		}
	}
}