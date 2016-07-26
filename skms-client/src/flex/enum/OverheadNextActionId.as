package enum
{
	import mx.collections.ArrayCollection;

	public final class OverheadNextActionId
	{
		public static const COPY:int				=-2;	// 複製.
		public static const DELETE:int				=-1;	// 削除.
		public static const UPDATE:int				= 1;	// 変更
		public static const APPLY:int				= 2;	// 申請.
		public static const APPLY_CANCEL:int		= 3;	// 申請取り消し.
		public static const APPROVAL_PM:int			= 4;	// PM承認.
		public static const APPROVAL_CANCEL_PM:int	= 5;	// PM承認取り消し.
		public static const APPROVAL_REJECT_PM:int	= 6;	// PM差し戻し.
		public static const APPROVAL_GA:int			= 7;	// 総務承認.
		public static const APPROVAL_CANCEL_GA:int	= 8;	// 総務承認取り消し.
		public static const APPROVAL_REJECT_GA:int	= 9;	// 総務差し戻し.
		public static const PAY:int					=10;	// 支払.
		public static const PAY_CANCEL:int			=11;	// 支払取り消し.
		public static const ACCEPT:int				=12;	// 受領.
		public static const ACCEPT_CANCEL:int		=13;	// 受領取り消し.

		public static function check(action:int, items:ArrayCollection):Boolean
		{
			var ret:Boolean = false;
			for each (var item:int in items) {
				if (action == item) {
					ret = true;
					break;
				}
			}
			return ret;
		}
	}
}
