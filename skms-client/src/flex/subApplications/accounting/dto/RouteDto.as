package subApplications.accounting.dto
{
	import dto.StaffDto;

	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.accounting.dto.RouteDto")]
	public class RouteDto
	{
		public function RouteDto()
		{
		}

		/** 経路ID */
		public var routeId:Number;

		/** 経路名 */
		public var routeName:String;

		/** 経路詳細リスト */
		public var routeDetails:ArrayCollection;

		/** 社員ID */
		public var staffId:int;

		/** 社員情報 */
		public var staff:StaffDto;

		/** 登録日時 */
		public var registrationTime:Date;

		/** 登録者ID */
		public var registrantId:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/** 表示順 */
		public var sortOrder:int;

		/** 削除フラグ */
		public var isDelete:Boolean = false;


//		/**
//		 * 経路作成（複数経路）.
//		 */
//		public static function createRoute(transItems:Array):RouteDto
//		{
//			var dst:RouteDto = new RouteDto();
//			dst.routeName    = makeRouteName();
//			dst.routeDetails = new ArrayCollection();
//			for each (var trans:TransportationDetailDto in transItems) {
//				dst.routeDetails.addItem(RouteDetailDto.createRoute(trans));
//			}
//			return dst;
//		}
//
//		/**
//		 * 経路作成（単経路）.
//		 */
//		public static function createRouteOne(trans:TransportationDetailDto):RouteDto
//		{
//			var dst:RouteDto = new RouteDto();
//			dst.routeName    = makeRouteName();
//			dst.routeDetails = new ArrayCollection();
//			dst.routeDetails.addItem(RouteDetailDto.createRoute(trans));
//			return dst;
//		}

//		/**
//		 * 経路情報をコピーする.
//		 * ※経路Drag&Dropで使用.
//		 */
//		public function copy():RouteDto
//		{
//			var dst:RouteDto = new RouteDto();
//			var flg:Boolean = this.routeName && StringUtil.trim(this.routeName).length > 0 ? true : false;
//			if (flg)		dst.routeName = this.routeName;			// 経路名あり.
//			else			dst.routeName = makeRouteName();		// 経路名なし.
//			dst.routeDetails = new ArrayCollection();
//			for each (var route:RouteDetailDto in this.routeDetails) {
//				dst.routeDetails.addItem(route.copy());
//			}
//			return dst;
//		 }

//		/**
//		 * 登録用データを作成する.
//		 *
//		 * @param  entryList 経路詳細リスト.
//		 * @return 登録用の経路情報.
//		 */
//		public function entryRoute():RouteDto
//		{
//			// 自オブジェクトをコピーする.
//			var dst:RouteDto = ObjectUtil.copy(this) as RouteDto;
//
//			// 詳細交通費明細リストに入力データを設定する.
//			dst.routeDetails = new ArrayCollection();
//			for each (var entryData:RouteDetailDto in this.routeDetails) {
//				// 未入力は登録対象外とする.
//				if (!(entryData && entryData.checkEntry()))	continue;
//				entryData.convertEntry();
//				dst.routeDetails.addItem(entryData);
//			}
//			// 新規＆経路詳細 0 件は 登録しない.
//			if (!(dst.routeDetails.length > 0) && !(dst.routeId > 0)) {
//				return null;
//			}
//			return dst;
//		}

		/**
		 * 経路名の作成.
		 */
		private static function makeRouteName():String
		{
			var now:Date = new Date();
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYYMMDD";
			return "経路_" + formatter.format(now);
		}

		/**
		 * 削除設定.
		 */
		public function setDelete():void
		{
		 	this.isDelete = true;
		 }

		/**
		 * 自経路の詳細経路かどうか確認する.
		 *
		 * @return 確認結果.
		 */
		public function isChild(child:RouteDetailDto):Boolean
		{
			if (!child)	return false;
		 	if (routeId > 0 && ObjectUtil.compare(this.routeId, child.routeId) == 0) {
		 		return true;
		 	}
		 	return false;
		}

		/**
		 * 登録時の入力値チェック.
		 */
		public function checkEntry():Boolean
		{
			// 入力値チェック.
			if (isValueString(this.routeName))			return true;

			// 入力値なし.
			return false;
		}

		/**
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			if (!(StringUtil.trim(value).length > 0))	return false;
			return true;
		}

		/**
		 * 経路作成.
		 *
		 * @param transItems 詳細経路リスト.
		 */
		public static function newRoute(transItems:Array = null):RouteDto
		{
			var dst:RouteDto = new RouteDto();
			dst.routeId = 0 - Math.random();
			if (transItems) {
				dst.routeName    = makeRouteName();
				dst.routeDetails = new ArrayCollection();
				for each (var trans:TransportationDetailDto in transItems) {
					var route:RouteDetailDto = RouteDetailDto.newRouteDetail(dst.routeId, trans);
					dst.routeDetails.addItem(route);
				}
			}
			return dst;
		}

		/**
		 * 登録用データを作成する.
		 *
		 * @param  entryList 経路詳細リスト.
		 * @return 登録用の経路情報.
		 */
		public function entryRoute(routeDList:ArrayCollection):RouteDto
		{
			// 自オブジェクトをコピーする.
			var dst:RouteDto = ObjectUtil.copy(this) as RouteDto;

			// 詳細交通費明細リストに入力データを設定する.
			dst.routeDetails = new ArrayCollection();
			routeDList.filterFunction = filter;
			routeDList.refresh();
			for (var i:int = 0; i < routeDList.length; i++) {
				var entryData:RouteDetailDto = routeDList.getItemAt(i) as RouteDetailDto;
				// 未入力は登録対象外とする.
				if (!(entryData && entryData.checkEntry()))	continue;
				entryData.convertEntry();
				dst.routeDetails.addItem(entryData);
			}
			// 新規＆経路詳細 0 件は 登録しない.
			if (!(dst.routeDetails.length > 0) && !(dst.routeId > 0)) {
				return null;
			}
			return dst;
		}

		/**
		 * 経路詳細フィルタリング.
		 *
		 * @param item 経路詳細.
		 */
		private function filter(item:Object):Boolean
		{
			// 現経路の経路詳細を取得する.
			return item.routeId == this.routeId;
		}

		/**
		 * 経路コピー.
		 * ※経路Drag&Dropで使用.
		 *
		 * @return コピー経路.
		 */
		public function copy():RouteDto
		{
			var dst:RouteDto = RouteDto.newRoute();
			var flg:Boolean = isValueString(this.routeName) ? true : false;
			if (flg)		dst.routeName = this.routeName;			// 経路名あり.
			else			dst.routeName = makeRouteName();		// 経路名なし.
			dst.routeDetails = new ArrayCollection();
			for each (var route:RouteDetailDto in this.routeDetails) {
				dst.routeDetails.addItem(route.copy(dst.routeId));
			}
			return dst;
		 }
	}
}