package com.riaoo.display
{
	public interface IAnimation
	{
		/**
		 * 当前播放头所处的帧编号。
		 * @return
		 *
		 */
		function get currentFrame():uint;

		/**
		 * 帧的总数。
		 * @return
		 *
		 */
		function get numFrames():int;

		/**
		 * 是否循环播放。
		 * @return
		 *
		 */
		function get isPlaying():Boolean;

		/**
		 * 从指定帧编号处开始播放。
		 * @param frameIndex 帧编号。
		 *
		 */
		function gotoAndPlay(frameIndex:uint):void;

		/**
		 * 把播放头移到指定帧编号处并停留在那里。
		 * @param frameIndex 帧编号。
		 *
		 */
		function gotoAndStop(frameIndex:uint):void;

		/**
		 * 将播放头转到下一帧并停止。如果播放头已到达最后一帧，则跳到第一帧，以此循环。
		 *
		 */
		function nextFrame():void;

		/**
		 * 将播放头转到上一帧并停止。如果播放头已到达第一帧，则跳到最后一帧，以此循环。
		 *
		 */
		function prevFrame():void;

		/**
		 * 播放。
		 *
		 */
		function play():void;

		/**
		 * 停止播放头（相当于暂停，currentFrame 属性不归零）。要重新开始播放，请参考代码：gotoAndPlay(0) 。
		 *
		 */
		function stop():void;
	}
}