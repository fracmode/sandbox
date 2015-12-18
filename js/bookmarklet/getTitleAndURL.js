// jQuery 無し
javascript:(function(){var%20d=new%20Date();prompt('Title%20+%20URL','***'+d+"***%20___"+'['+document.title+']('+location.href+')');})()

// jQuery 有り
javascript:(function(d,f,s){s=d.createElement("script");s.src="//j.mp/1bPoAXq";s.onload=function(){f(jQuery.noConflict(!0))};d.body.appendChild(s)})(document,function($){$('body').append('<div%20class="K29PLR46-wrapper"%20style="position:absolute;z-index:9999;top:0;width:100%;height:9999px;background:rgba(0,0,0,0.3);"><div%20class="K29PLR46-popup-window"%20style="background:#FEFEFE;width:640px;height:480px;margin:100px%20auto%200;padding:10px;"><textarea%20class="K29PLR46-body"%20style="width:100%;height:100%;"></textarea></div></div>');var%20$el_popup=$('.K29PLR46-body');var%20d=new%20Date();$el_popup.html('***'+d+"***%20%20\n"+'['+document.title+']('+location.href+')');var%20$el_bg=$('.K29PLR46-wrapper');$el_bg.on('click',function(){if($el_popup.is(':hover')){return%20false;}$el_bg.remove();});})

