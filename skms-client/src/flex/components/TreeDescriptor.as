package components
{
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.DefaultDataDescriptor;

	/**
	 * TreeDescriptorクラス
	 */
	public class TreeDescriptor extends DefaultDataDescriptor
	{
		/**
		 * ブランチフィールド
		 */
		private var _branchField:String = "children";
		public function get blanchField():String
		{
			return _branchField;
		}
		
		/**
		 * コンストラクタ
		 */
		public function TreeDescriptor()
		{
			super();
		}
		
		/**  
         * (override)ノードが終端であるかどうかをテストします。  
         */ 
        override public function isBranch(node:Object, model:Object=null):Boolean
        {  
        	if (node[this._branchField] != null) 
        	{
        		var children:ArrayCollection = node[this._branchField] as ArrayCollection;
	            return children.length > 0 ? true : false;  
         	}
         	return false;
        }  
   
        /**  
         * (override)ノードに実際に子がある場合は、true を返します。  
         */ 
        override public function hasChildren(node:Object, model:Object=null):Boolean
        {  
        	if (node[this._branchField] != null) 
        	{
        		var children:ArrayCollection = node[this._branchField] as ArrayCollection;
	            return children.length > 0 ? true : false;  
         	}
         	return false;
        }  

        /**  
         * (override)ノードの子へのアクセスを提供します。  
         */ 
        override public function getChildren(node:Object, model:Object=null):ICollectionView
        {
        	if (node[this._branchField] != null)
			{
				var children:ArrayCollection = node[this._branchField] as ArrayCollection;
    	    	return children;
   			}
   			return new ArrayCollection();
        } 
	}
}
