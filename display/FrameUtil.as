package org.asclub.display
{
	import flash.display.MovieClip;
	public final class FrameUtil
	{
		public function FrameUtil()
		{
			
		}
		
		/**
		 * 从帧标签中获取所处的帧的编号
		 * @param	target    目标影片剪辑
		 * @param	label     帧标签
		 * @return  int       所处的帧的编号
		 */
		public static function getFrameNumberForLabel(target:MovieClip, label:String):int 
		{
			var labels:Array = target.currentLabels;
			var l:int        = labels.length;
			
			while (l--)
				if (labels[l].name == label)
					return labels[l].frame;
			
			return -1;
		}
		
		/**
		 * 在帧上添加脚本
		 * @param	target     目标影片剪辑
		 * @param	frame      帧编号 或则 帧标签
		 * @param	notify     处理函数
		 * @return  Boolean    添加脚本是否成功
		 * @throws  
		 */
		public static function addFrameScript(target:MovieClip, frame:*, notify:Function):Boolean 
		{
			if (frame is String)
				frame = FrameUtil.getFrameNumberForLabel(target, frame);
			else if (!(frame is uint))
				throw new Error("不是帧编号，也不是帧标签");
			
			if (frame == -1 || frame == 0 || frame > target.totalFrames)
				return false;
			
			target.addFrameScript(frame - 1, notify);
			
			return true;
		}
		
		/**
		 * 移除帧上的脚本
		 * @param	target     目标影片剪辑
		 * @param	frame      帧编号 或则 帧标签
		 */
		public static function removeFrameScript(target:MovieClip, frame:*):void 
		{
			if (frame is String)
				frame = FrameUtil.getFrameNumberForLabel(target, frame);
			else if (!(frame is uint))
				throw new Error("不是帧编号，也不是帧标签");
			
			if (frame == -1 || frame == 0 || frame > target.totalFrames)
				return;
			
			target.addFrameScript(frame - 1, null);
		}
		
	}//end of class
}