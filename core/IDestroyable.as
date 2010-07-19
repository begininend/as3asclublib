package org.asclub.core
{
	public interface IDestroyable
	{
		/**
			Removes any event listeners and stops all internal processes to help allow for prompt garbage collection.
			删除任何事件侦听器，并停止所有内部流程，帮助以便及时收集垃圾。
			<strong>Always call <code>destroy()</code> before deleting last object pointer.</strong>
			始终调用destroy（）方法删除之前最后一个对象的指针。
		*/
		function destroy():void;
	}
}