package com.riaoo.display
{
	import flash.display.BitmapData;

	/**
	 * FrameSequence 的接口。
	 *
	 * @see com.smartgf.display.FrameSequence
	 * @see com.smartgf.display.Animation
	 *
	 * @author Y.Boy
	 *
	 */
	public interface IFrameSequence
	{
		/**
		 * 帧队列的长度。
		 * @return
		 *
		 */
		function get length():uint;
		function set length(value:uint):void;

		/**
		 * 指标帧队列的长度是否固定。如果值为 true ，则无法更改 length 属性。这表示当 fixed 为 true 时，不允许执行以下操作：
		 * <ul>
		 *   <li>直接设置 length 属性</li>
		 *   <li>将值分配给索引位置 length</li>
		 *   <li>调用可更改 length 属性的方法，包括：
		 *     <ul>
		 *       <li>pop()</li>
		 *       <li>push()</li>
		 *       <li>shift()</li>
		 *       <li>unshift()</li>
		 *       <li>setFrameAt()（如果 setFrameAt() 调用更改帧队列的 length）。</li>
		 *     </ul>
		 *   </li>
		 * </ul>
		 * @return
		 *
		 */
		function get fixed():Boolean;
		function set fixed(value:Boolean):void;

		/**
		 * 设置指定帧编号处的位图数据。
		 * @param index 帧编号。帧编号是从 0 开始递增的数，例如第 2 帧的编号为 1 。
		 * @param bitmapData 该帧的位图数据。
		 * @return 设置成功，则返回 true ；否则返回 false 。以下情况返回 false ：index > length 。
		 *
		 */
		function setFrameAt(index:uint, bitmapData:BitmapData):Boolean;

		/**
		 * 获取指定帧编号处的位图数据。
		 * @param index 帧编号。帧编号是从 0 开始递增的数，例如第 2 帧的编号为 1 。
		 * @return 指定帧编号处的位图数据。
		 *
		 */
		function getFrameAt(index:uint):BitmapData;

		/**
		 * 将一个或多个帧添加到帧队列的末尾，并返回帧队列的新长度。
		 * @param bitmapData 该帧的位图数据。
		 * @return 帧队列的新长度。
		 *
		 */
		function push(...params):uint;

		/**
		 * 将一个或多个帧添加到帧队列的开头，并返回帧队列的新长度。
		 * @param bitmapData 该帧的位图数据。
		 * @return 帧队列的新长度。
		 *
		 */
		function unshift(...params):uint;

		/**
		 * 删除帧队列中最后一个帧，并返回该帧的位图数据。
		 * @return 被删除的帧的位图数据。
		 *
		 */
		function pop():BitmapData;

		/**
		 * 删除帧队列中第一个帧，并返回该帧的位图数据。
		 * @return 被删除的帧的位图数据。
		 *
		 */
		function shift():BitmapData;

		/**
		 * 倒置帧队列。
		 *
		 */
		function reverse():void;
	}
}