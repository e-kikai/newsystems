/*
 * Lazy Load - jQuery plugin for lazy loading images
 *
 * Copyright (c) 2007-2012 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   http://www.appelsiini.net/projects/lazyload
 *
 * Version:  1.7.0
 *
 */
(function(a,b){$window=a(b),a.fn.lazyload=function(c){var d={threshold:0,failure_limit:0,event:"scroll",effect:"show",container:b,data_attribute:"original",skip_invisible:!0,appear:null,load:null};c&&(undefined!==c.failurelimit&&(c.failure_limit=c.failurelimit,delete c.failurelimit),undefined!==c.effectspeed&&(c.effect_speed=c.effectspeed,delete c.effectspeed),a.extend(d,c));var e=this;return 0==d.event.indexOf("scroll")&&a(d.container).bind(d.event,function(b){var c=0;e.each(function(){$this=a(this);if(d.skip_invisible&&!$this.is(":visible"))return;if(!a.abovethetop(this,d)&&!a.leftofbegin(this,d))if(!a.belowthefold(this,d)&&!a.rightoffold(this,d))$this.trigger("appear");else if(++c>d.failure_limit)return!1})}),this.each(function(){var b=this,c=a(b);b.loaded=!1,c.one("appear",function(){if(!this.loaded){if(d.appear){var f=e.length;d.appear.call(b,f,d)}a("<img />").bind("load",function(){c.hide().attr("src",c.data(d.data_attribute))[d.effect](d.effect_speed),b.loaded=!0;var f=a.grep(e,function(a){return!a.loaded});e=a(f);if(d.load){var g=e.length;d.load.call(b,g,d)}}).attr("src",c.data(d.data_attribute))}}),0!=d.event.indexOf("scroll")&&c.bind(d.event,function(a){b.loaded||c.trigger("appear")})}),$window.bind("resize",function(b){a(d.container).triggerHandler(d.event)}),a(d.container).triggerHandler(d.event),this},a.belowthefold=function(c,d){if(d.container===undefined||d.container===b)var e=$window.height()+$window.scrollTop();else var e=a(d.container).offset().top+a(d.container).height();return e<=a(c).offset().top-d.threshold},a.rightoffold=function(c,d){if(d.container===undefined||d.container===b)var e=$window.width()+$window.scrollLeft();else var e=a(d.container).offset().left+a(d.container).width();return e<=a(c).offset().left-d.threshold},a.abovethetop=function(c,d){if(d.container===undefined||d.container===b)var e=$window.scrollTop();else var e=a(d.container).offset().top;return e>=a(c).offset().top+d.threshold+a(c).height()},a.leftofbegin=function(c,d){if(d.container===undefined||d.container===b)var e=$window.scrollLeft();else var e=a(d.container).offset().left;return e>=a(c).offset().left+d.threshold+a(c).width()},a.inviewport=function(b,c){return!a.rightofscreen(b,c)&&!a.leftofscreen(b,c)&&!a.belowthefold(b,c)&&!a.abovethetop(b,c)},a.extend(a.expr[":"],{"below-the-fold":function(c){return a.belowthefold(c,{threshold:0,container:b})},"above-the-top":function(c){return!a.belowthefold(c,{threshold:0,container:b})},"right-of-screen":function(c){return a.rightoffold(c,{threshold:0,container:b})},"left-of-screen":function(c){return!a.rightoffold(c,{threshold:0,container:b})},"in-viewport":function(c){return!a.inviewport(c,{threshold:0,container:b})},"above-the-fold":function(c){return!a.belowthefold(c,{threshold:0,container:b})},"right-of-fold":function(c){return a.rightoffold(c,{threshold:0,container:b})},"left-of-fold":function(c){return!a.rightoffold(c,{threshold:0,container:b})}})})(jQuery,window)