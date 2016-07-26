package dto
{

	[Bindable]
	[RemoteClass(alias="dto.LabelDto")]
	public class LabelDto
	{
		/**
		 * IDです.
		 */
		public var data:int;

		/**
		 * 付加情報です.
		 */
		public var data2:String;
		
		/**
		 * 付加情報2です.
		 */
		public var data3:int;

		/**
		 * 表示名です.
		 */
		public var label:String;

		/**
		 * 選択状態です.
		 */
		public var selected:Boolean;

		/**
		 * 操作状態です.
		 */
		public var enabled:Boolean;

		/**
		 * ツールヒントです.
		 */
		public var toolTip:String;
	}

}