package subApplications.generalAffair.dto
{
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.address.dto.MPrefectureDto")]
	public class MPrefectureDto
	{
		/**
		 * 都道府県コード
		 */
		public var code:int;
							
		/**
		 * 都道府県名
		 */
		public var name:String;
	}
}