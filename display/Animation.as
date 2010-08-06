package com.riaoo.display
{
	import com.riaoo.events.AnimationEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	[Event(name="animationEnterFrame",type="com.sgf.events.AnimationEvent")]
	[Event(name="animationEnd",type="com.sgf.events.AnimationEvent")]

	/**
	 * 此类用于播放位图序列。可按指定的时间间隔（delay 属性）来播放每一帧。动画的重复次数由 timer.repeatCount 指定。
	 *
	 * @see com.sgf.display.FrameSequence
	 * @see flash.utils.Timer
	 *
	 * @author Y.Boy
	 *
	 */
	public class Animation extends Bitmap implements IAnimation
	{
		private var getTimer_prev:int; // 上一次 getTimer() 的取值

		/**
		 * 当前播放头所处的帧编号。
		 */
		protected var _currentFrame:int;

		/**
		 * 指示动画当前是否正在播放。
		 */
		protected var _isPlaying:Boolean;

		/**
		 * 用于定时播放的 timer 对象。
		 */
		public var timer:Timer;

		/**
		 * 用于播放的位图序列（帧队列）。
		 */
		public var frameSequence:IFrameSequence;

		/**
		 * 帧与帧之间的播放时间间隔（以毫秒为单位）。默认为 100 毫秒。
		 */
		public var delay:int;

		/**
		 * 指示是否采用位图副本进行播放。采用位图副本进行播放时，会占用额外的内存，但可以确保帧队列（frameSequence）里的位图不被修改。
		 *
		 */
		public var cache:Boolean;

		/**
		 * 构造函数。创建 Animation 对象并不会自动播放，请调用 play() 方法开始播放。
		 * @param timer 用于定时播放的 Timer 对象。注意：Timer.delay 必须小于或等于 Animation.delay 。
		 * @param frameSequence 帧队列。
		 * @param delay 帧与帧之间的播放时间间隔。默认是 100 毫秒。
		 * @param cache 指示是否采用位图副本进行播放。
		 *
		 */
		public function Animation(timer:Timer, frameSequence:IFrameSequence = null, delay:Number = 100, cache:Boolean = false)
		{
			init(timer, frameSequence, delay, cache);
		}

		// 初始化。
		private function init(timer:Timer, frameSequence:IFrameSequence, delay:Number, cache:Boolean):void
		{
			_currentFrame = -1;
			_isPlaying = false;

			this.timer = timer;
			this.frameSequence = frameSequence;
			this.delay = delay;
			this.cache = cache;
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function get currentFrame():uint
		{
			return _currentFrame;
		}

		public function get numFrames():int
		{
			return this.frameSequence ? this.frameSequence.length : 0;
		}

		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		public function gotoAndPlay(frameIndex:uint):void
		{
			if (this.frameSequence == null || frameIndex < 0 || frameIndex >= this.frameSequence.length) // 参数超出范围时返回
			{
				return;
			}

			setBuffer(frameIndex);
			play();
		}

		public function gotoAndStop(frameIndex:uint):void
		{
			if (this.frameSequence == null || frameIndex < 0 || frameIndex >= this.frameSequence.length) // 参数超出范围时返回
			{
				return;
			}

			stop();
			setBuffer(frameIndex);
		}

		public function nextFrame():void
		{
			nextFrameWithoutStop();
			stop();
		}

		public function prevFrame():void
		{
			prevFrameWithoutStop();
			stop();
		}

		public function play():void
		{
			if (!_isPlaying)
			{
				_isPlaying = true;
				this.timer.addEventListener(TimerEvent.TIMER, onTimer);
				this.timer.start();
			}
		}

		public function stop():void
		{
			if (_isPlaying)
			{
				_isPlaying = false;
				this.timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

		/**
		 * 设置缓冲区（Bitmap.bitmapData）。
		 * @param frameIndex 帧编号。
		 *
		 */
		protected function setBuffer(frameIndex:uint):void
		{
			_currentFrame = frameIndex;
			if (this.frameSequence != null)
			{
				var buffer:BitmapData = this.frameSequence.getFrameAt(frameIndex);
				if (buffer != null)
				{
					if (this.cache) // 只采用位图副本，不加滤镜
					{
						buffer = buffer.clone();
					}
					this.bitmapData = buffer;
				}
			}
		}

		/**
		 * 将播放头转到下一帧，但不停止。如果播放头已到达最后一帧，则跳到第一帧，依此循环。
		 *
		 */
		protected function nextFrameWithoutStop():void
		{
			if (this.frameSequence == null)
			{
				return;
			}

			var length:uint = this.frameSequence.length;
			if (length < 2) // 只有一帧或没有帧时返回
			{
				return;
			}

			if (_currentFrame < length - 1) // 如果还有下一帧
			{
				_currentFrame++;

				if (_currentFrame == this.frameSequence.length - 1)
				{
					//----------
					// 调度 END 事件
					//----------
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_END));
				}
			}
			else // 没有下一帧，回播
			{
				_currentFrame = 0;
			}
			setBuffer(_currentFrame);
		}

		/**
		 * 将播放头转到上一帧，但不停止。如果播放头已到达第一帧，则跳到最后一帧，依此循环。
		 *
		 */
		protected function prevFrameWithoutStop():void
		{
			if (this.frameSequence == null)
			{
				return;
			}

			var length:uint = this.frameSequence.length;
			if (length < 2) // 只有一帧或没有帧时返回
			{
				return;
			}

			if (_currentFrame > 0) // 如果还有上一帧
			{
				_currentFrame--;
			}
			else // 没有上一帧，从最后一帧开始播放
			{
				_currentFrame = length - 1;
			}
			setBuffer(_currentFrame);
		}

		// tick...
		private function onTimer(event:TimerEvent):void
		{
			if (this.frameSequence == null)
			{
				return;
			}

			//----------
			// 播放每帧
			//----------
			var now:int = getTimer();
			var offsetTime:int = now - this.getTimer_prev; // 两次 getTimer() 之差
			if (offsetTime >= this.delay) // 当：时差 >= 播放的延迟间隔
			{
				this.getTimer_prev = now;
				var offsetFrame:int = int(offsetTime / this.delay);
				if (offsetFrame == 1) // 下一帧
				{
					nextFrameWithoutStop();
				}
				else // 跳帧
				{
					var frameIndex:int = (_currentFrame + offsetFrame) % this.frameSequence.length;
					gotoAndPlay(frameIndex);
				}
			}

			//----------
			// 调度 ENTER_FRAME 事件
			//----------
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_ENTER_FRAME));
		}

		// good bye...
		private function onRemovedFromStage(event:Event):void
		{
			stop();

			return;
			this.timer = null;
			this.frameSequence = null;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

	}
}