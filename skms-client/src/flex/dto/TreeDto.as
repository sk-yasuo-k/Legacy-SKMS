package dto
{
	import mx.collections.ArrayCollection;
	
//	[Bindable]
//	[RemoteClass(alias="services.system.dto.TreeDto")]
	public class TreeDto
	{
		public function TreeDto()
		{
		}

		/**
		 * IDです.
		 */
		public var id:int;
	
		/**
		 * 名称です.
		 */
		public var label:String;
		
		/**
		 * 名称です.
		 */
		public var alias:String;
	
		/**
		 * URLです.
		 */
		public var url:String;
		
		/**
		 * 表示順です.
		 */
		public var sortOrder:int;
		
		/**
		 * childrenです.
		 */
		public var children:ArrayCollection;
		
		/**
		 * 操作可否フラグです.
		 */
		public var enabled:Boolean;
		
		/**
		 * メモです.
		 */
		public var memo:String;
		
		/**
		 * URL参照タイプです.
		 */
		public var urlRef:int;
	}
}