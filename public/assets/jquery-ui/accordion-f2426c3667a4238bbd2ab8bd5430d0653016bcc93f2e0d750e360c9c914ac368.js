!function(e){"function"==typeof define&&define.amd?define(["jquery"],e):e(jQuery)}(function(o){function n(e,t){var i,n,s,a=e.nodeName.toLowerCase();return"area"===a?(n=(i=e.parentNode).name,!(!e.href||!n||"map"!==i.nodeName.toLowerCase())&&(!!(s=o("img[usemap='#"+n+"']")[0])&&r(s))):(/^(input|select|textarea|button|object)$/.test(a)?!e.disabled:"a"===a&&e.href||t)&&r(e)}function r(e){return o.expr.filters.visible(e)&&!o(e).parents().addBack().filter(function(){return"hidden"===o.css(this,"visibility")}).length}var e,t,i,s;o.ui=o.ui||{},o.extend(o.ui,{version:"1.11.4",keyCode:{BACKSPACE:8,COMMA:188,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SPACE:32,TAB:9,UP:38}}),o.fn.extend({scrollParent:function(e){var t=this.css("position"),i="absolute"===t,n=e?/(auto|scroll|hidden)/:/(auto|scroll)/,s=this.parents().filter(function(){var e=o(this);return(!i||"static"!==e.css("position"))&&n.test(e.css("overflow")+e.css("overflow-y")+e.css("overflow-x"))}).eq(0);return"fixed"!==t&&s.length?s:o(this[0].ownerDocument||document)},uniqueId:(e=0,function(){return this.each(function(){this.id||(this.id="ui-id-"+ ++e)})}),removeUniqueId:function(){return this.each(function(){/^ui-id-\d+$/.test(this.id)&&o(this).removeAttr("id")})}}),o.extend(o.expr[":"],{data:o.expr.createPseudo?o.expr.createPseudo(function(t){return function(e){return!!o.data(e,t)}}):function(e,t,i){return!!o.data(e,i[3])},focusable:function(e){return n(e,!isNaN(o.attr(e,"tabindex")))},tabbable:function(e){var t=o.attr(e,"tabindex"),i=isNaN(t);return(i||0<=t)&&n(e,!i)}}),o("<a>").outerWidth(1).jquery||o.each(["Width","Height"],function(e,i){function n(e,t,i,n){return o.each(s,function(){t-=parseFloat(o.css(e,"padding"+this))||0,i&&(t-=parseFloat(o.css(e,"border"+this+"Width"))||0),n&&(t-=parseFloat(o.css(e,"margin"+this))||0)}),t}var s="Width"===i?["Left","Right"]:["Top","Bottom"],a=i.toLowerCase(),r={innerWidth:o.fn.innerWidth,innerHeight:o.fn.innerHeight,outerWidth:o.fn.outerWidth,outerHeight:o.fn.outerHeight};o.fn["inner"+i]=function(e){return e===undefined?r["inner"+i].call(this):this.each(function(){o(this).css(a,n(this,e)+"px")})},o.fn["outer"+i]=function(e,t){return"number"!=typeof e?r["outer"+i].call(this,e):this.each(function(){o(this).css(a,n(this,e,!0,t)+"px")})}}),o.fn.addBack||(o.fn.addBack=function(e){return this.add(null==e?this.prevObject:this.prevObject.filter(e))}),o("<a>").data("a-b","a").removeData("a-b").data("a-b")&&(o.fn.removeData=(t=o.fn.removeData,function(e){return arguments.length?t.call(this,o.camelCase(e)):t.call(this)})),o.ui.ie=!!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase()),o.fn.extend({focus:(s=o.fn.focus,function(t,i){return"number"==typeof t?this.each(function(){var e=this;setTimeout(function(){o(e).focus(),i&&i.call(e)},t)}):s.apply(this,arguments)}),disableSelection:(i="onselectstart"in document.createElement("div")?"selectstart":"mousedown",function(){return this.bind(i+".ui-disableSelection",function(e){e.preventDefault()})}),enableSelection:function(){return this.unbind(".ui-disableSelection")},zIndex:function(e){if(e!==undefined)return this.css("zIndex",e);if(this.length)for(var t,i,n=o(this[0]);n.length&&n[0]!==document;){if(("absolute"===(t=n.css("position"))||"relative"===t||"fixed"===t)&&(i=parseInt(n.css("zIndex"),10),!isNaN(i)&&0!==i))return i;n=n.parent()}return 0}}),o.ui.plugin={add:function(e,t,i){var n,s=o.ui[e].prototype;for(n in i)s.plugins[n]=s.plugins[n]||[],s.plugins[n].push([t,i[n]])},call:function(e,t,i,n){var s,a=e.plugins[t];if(a&&(n||e.element[0].parentNode&&11!==e.element[0].parentNode.nodeType))for(s=0;s<a.length;s++)e.options[a[s][0]]&&a[s][1].apply(e.element,i)}}}),function(e){"function"==typeof define&&define.amd?define(["jquery"],e):e(jQuery)}(function(c){var a,i=0,o=Array.prototype.slice;return c.cleanData=(a=c.cleanData,function(e){var t,i,n;for(n=0;null!=(i=e[n]);n++)try{(t=c._data(i,"events"))&&t.remove&&c(i).triggerHandler("remove")}catch(s){}a(e)}),c.widget=function(e,i,t){var n,s,a,r,o={},h=e.split(".")[0];return e=e.split(".")[1],n=h+"-"+e,t||(t=i,i=c.Widget),c.expr[":"][n.toLowerCase()]=function(e){return!!c.data(e,n)},c[h]=c[h]||{},s=c[h][e],a=c[h][e]=function(e,t){if(!this._createWidget)return new a(e,t);arguments.length&&this._createWidget(e,t)},c.extend(a,s,{version:t.version,_proto:c.extend({},t),_childConstructors:[]}),(r=new i).options=c.widget.extend({},r.options),c.each(t,function(t,n){var s,a;c.isFunction(n)?o[t]=(s=function(){return i.prototype[t].apply(this,arguments)},a=function(e){return i.prototype[t].apply(this,e)},function(){var e,t=this._super,i=this._superApply;return this._super=s,this._superApply=a,e=n.apply(this,arguments),this._super=t,this._superApply=i,e}):o[t]=n}),a.prototype=c.widget.extend(r,{widgetEventPrefix:s&&r.widgetEventPrefix||e},o,{constructor:a,namespace:h,widgetName:e,widgetFullName:n}),s?(c.each(s._childConstructors,function(e,t){var i=t.prototype;c.widget(i.namespace+"."+i.widgetName,a,t._proto)}),delete s._childConstructors):i._childConstructors.push(a),c.widget.bridge(e,a),a},c.widget.extend=function(e){for(var t,i,n=o.call(arguments,1),s=0,a=n.length;s<a;s++)for(t in n[s])i=n[s][t],n[s].hasOwnProperty(t)&&i!==undefined&&(c.isPlainObject(i)?e[t]=c.isPlainObject(e[t])?c.widget.extend({},e[t],i):c.widget.extend({},i):e[t]=i);return e},c.widget.bridge=function(a,t){var r=t.prototype.widgetFullName||a;c.fn[a]=function(i){var e="string"==typeof i,n=o.call(arguments,1),s=this;return e?this.each(function(){var e,t=c.data(this,r);return"instance"===i?(s=t,!1):t?c.isFunction(t[i])&&"_"!==i.charAt(0)?(e=t[i].apply(t,n))!==t&&e!==undefined?(s=e&&e.jquery?s.pushStack(e.get()):e,!1):void 0:c.error("no such method '"+i+"' for "+a+" widget instance"):c.error("cannot call methods on "+a+" prior to initialization; attempted to call method '"+i+"'")}):(n.length&&(i=c.widget.extend.apply(null,[i].concat(n))),this.each(function(){var e=c.data(this,r);e?(e.option(i||{}),e._init&&e._init()):c.data(this,r,new t(i,this))})),s}},c.Widget=function(){},c.Widget._childConstructors=[],c.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",defaultElement:"<div>",options:{disabled:!1,create:null},_createWidget:function(e,t){t=c(t||this.defaultElement||this)[0],this.element=c(t),this.uuid=i++,this.eventNamespace="."+this.widgetName+this.uuid,this.bindings=c(),this.hoverable=c(),this.focusable=c(),t!==this&&(c.data(t,this.widgetFullName,this),this._on(!0,this.element,{remove:function(e){e.target===t&&this.destroy()}}),this.document=c(t.style?t.ownerDocument:t.document||t),this.window=c(this.document[0].defaultView||this.document[0].parentWindow)),this.options=c.widget.extend({},this.options,this._getCreateOptions(),e),this._create(),this._trigger("create",null,this._getCreateEventData()),this._init()},_getCreateOptions:c.noop,_getCreateEventData:c.noop,_create:c.noop,_init:c.noop,destroy:function(){this._destroy(),this.element.unbind(this.eventNamespace).removeData(this.widgetFullName).removeData(c.camelCase(this.widgetFullName)),this.widget().unbind(this.eventNamespace).removeAttr("aria-disabled").removeClass(this.widgetFullName+"-disabled ui-state-disabled"),this.bindings.unbind(this.eventNamespace),this.hoverable.removeClass("ui-state-hover"),this.focusable.removeClass("ui-state-focus")},_destroy:c.noop,widget:function(){return this.element},option:function(e,t){var i,n,s,a=e;if(0===arguments.length)return c.widget.extend({},this.options);if("string"==typeof e)if(a={},e=(i=e.split(".")).shift(),i.length){for(n=a[e]=c.widget.extend({},this.options[e]),s=0;s<i.length-1;s++)n[i[s]]=n[i[s]]||{},n=n[i[s]];if(e=i.pop(),1===arguments.length)return n[e]===undefined?null:n[e];n[e]=t}else{if(1===arguments.length)return this.options[e]===undefined?null:this.options[e];a[e]=t}return this._setOptions(a),this},_setOptions:function(e){var t;for(t in e)this._setOption(t,e[t]);return this},_setOption:function(e,t){return this.options[e]=t,"disabled"===e&&(this.widget().toggleClass(this.widgetFullName+"-disabled",!!t),t&&(this.hoverable.removeClass("ui-state-hover"),this.focusable.removeClass("ui-state-focus"))),this},enable:function(){return this._setOptions({disabled:!1})},disable:function(){return this._setOptions({disabled:!0})},_on:function(r,o,e){var h,d=this;"boolean"!=typeof r&&(e=o,o=r,r=!1),e?(o=h=c(o),this.bindings=this.bindings.add(o)):(e=o,o=this.element,h=this.widget()),c.each(e,function(e,t){function i(){if(r||!0!==d.options.disabled&&!c(this).hasClass("ui-state-disabled"))return("string"==typeof t?d[t]:t).apply(d,arguments)}"string"!=typeof t&&(i.guid=t.guid=t.guid||i.guid||c.guid++);var n=e.match(/^([\w:-]*)\s*(.*)$/),s=n[1]+d.eventNamespace,a=n[2];a?h.delegate(a,s,i):o.bind(s,i)})},_off:function(e,t){t=(t||"").split(" ").join(this.eventNamespace+" ")+this.eventNamespace,e.unbind(t).undelegate(t),this.bindings=c(this.bindings.not(e).get()),this.focusable=c(this.focusable.not(e).get()),this.hoverable=c(this.hoverable.not(e).get())},_delay:function(e,t){function i(){return("string"==typeof e?n[e]:e).apply(n,arguments)}var n=this;return setTimeout(i,t||0)},_hoverable:function(e){this.hoverable=this.hoverable.add(e),this._on(e,{mouseenter:function(e){c(e.currentTarget).addClass("ui-state-hover")},mouseleave:function(e){c(e.currentTarget).removeClass("ui-state-hover")}})},_focusable:function(e){this.focusable=this.focusable.add(e),this._on(e,{focusin:function(e){c(e.currentTarget).addClass("ui-state-focus")},focusout:function(e){c(e.currentTarget).removeClass("ui-state-focus")}})},_trigger:function(e,t,i){var n,s,a=this.options[e];if(i=i||{},(t=c.Event(t)).type=(e===this.widgetEventPrefix?e:this.widgetEventPrefix+e).toLowerCase(),t.target=this.element[0],s=t.originalEvent)for(n in s)n in t||(t[n]=s[n]);return this.element.trigger(t,i),!(c.isFunction(a)&&!1===a.apply(this.element[0],[t].concat(i))||t.isDefaultPrevented())}},c.each({show:"fadeIn",hide:"fadeOut"},function(a,r){c.Widget.prototype["_"+a]=function(t,e,i){"string"==typeof e&&(e={effect:e});var n,s=e?!0===e||"number"==typeof e?r:e.effect||r:a;"number"==typeof(e=e||{})&&(e={duration:e}),n=!c.isEmptyObject(e),e.complete=i,e.delay&&t.delay(e.delay),n&&c.effects&&c.effects.effect[s]?t[a](e):s!==a&&t[s]?t[s](e.duration,e.easing,i):t.queue(function(e){c(this)[a](),i&&i.call(t[0]),e()})}}),c.widget}),function(e){"function"==typeof define&&define.amd?define(["jquery","./core","./widget"],e):e(jQuery)}(function(h){return h.widget("ui.accordion",{version:"1.11.4",options:{active:0,animate:{},collapsible:!1,event:"click",header:"> li > :first-child,> :not(li):even",heightStyle:"auto",icons:{activeHeader:"ui-icon-triangle-1-s",header:"ui-icon-triangle-1-e"},activate:null,beforeActivate:null},hideProps:{borderTopWidth:"hide",borderBottomWidth:"hide",paddingTop:"hide",paddingBottom:"hide",height:"hide"},showProps:{borderTopWidth:"show",borderBottomWidth:"show",paddingTop:"show",paddingBottom:"show",height:"show"},_create:function(){var e=this.options;this.prevShow=this.prevHide=h(),this.element.addClass("ui-accordion ui-widget ui-helper-reset").attr("role","tablist"),e.collapsible||!1!==e.active&&null!=e.active||(e.active=0),this._processPanels(),e.active<0&&(e.active+=this.headers.length),this._refresh()},_getCreateEventData:function(){return{header:this.active,panel:this.active.length?this.active.next():h()}},_createIcons:function(){var e=this.options.icons;e&&(h("<span>").addClass("ui-accordion-header-icon ui-icon "+e.header).prependTo(this.headers),this.active.children(".ui-accordion-header-icon").removeClass(e.header).addClass(e.activeHeader),this.headers.addClass("ui-accordion-icons"))},_destroyIcons:function(){this.headers.removeClass("ui-accordion-icons").children(".ui-accordion-header-icon").remove()},_destroy:function(){var e;this.element.removeClass("ui-accordion ui-widget ui-helper-reset").removeAttr("role"),this.headers.removeClass("ui-accordion-header ui-accordion-header-active ui-state-default ui-corner-all ui-state-active ui-state-disabled ui-corner-top").removeAttr("role").removeAttr("aria-expanded").removeAttr("aria-selected").removeAttr("aria-controls").removeAttr("tabIndex").removeUniqueId(),this._destroyIcons(),e=this.headers.next().removeClass("ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content ui-accordion-content-active ui-state-disabled").css("display","").removeAttr("role").removeAttr("aria-hidden").removeAttr("aria-labelledby").removeUniqueId(),"content"!==this.options.heightStyle&&e.css("height","")},_setOption:function(e,t){"active"!==e?("event"===e&&(this.options.event&&this._off(this.headers,this.options.event),this._setupEvents(t)),this._super(e,t),"collapsible"!==e||t||!1!==this.options.active||this._activate(0),"icons"===e&&(this._destroyIcons(),t&&this._createIcons()),"disabled"===e&&(this.element.toggleClass("ui-state-disabled",!!t).attr("aria-disabled",t),this.headers.add(this.headers.next()).toggleClass("ui-state-disabled",!!t))):this._activate(t)},_keydown:function(e){if(!e.altKey&&!e.ctrlKey){var t=h.ui.keyCode,i=this.headers.length,n=this.headers.index(e.target),s=!1;switch(e.keyCode){case t.RIGHT:case t.DOWN:s=this.headers[(n+1)%i];break;case t.LEFT:case t.UP:s=this.headers[(n-1+i)%i];break;case t.SPACE:case t.ENTER:this._eventHandler(e);break;case t.HOME:s=this.headers[0];break;case t.END:s=this.headers[i-1]}s&&(h(e.target).attr("tabIndex",-1),h(s).attr("tabIndex",0),s.focus(),e.preventDefault())}},_panelKeyDown:function(e){e.keyCode===h.ui.keyCode.UP&&e.ctrlKey&&h(e.currentTarget).prev().focus()},refresh:function(){var e=this.options;this._processPanels(),!1===e.active&&!0===e.collapsible||!this.headers.length?(e.active=!1,this.active=h()):!1===e.active?this._activate(0):this.active.length&&!h.contains(this.element[0],this.active[0])?this.headers.length===this.headers.find(".ui-state-disabled").length?(e.active=!1,this.active=h()):this._activate(Math.max(0,e.active-1)):e.active=this.headers.index(this.active),this._destroyIcons(),this._refresh()},_processPanels:function(){var e=this.headers,t=this.panels;this.headers=this.element.find(this.options.header).addClass("ui-accordion-header ui-state-default ui-corner-all"),this.panels=this.headers.next().addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom").filter(":not(.ui-accordion-content-active)").hide(),t&&(this._off(e.not(this.headers)),this._off(t.not(this.panels)))},_refresh:function(){var i,e=this.options,t=e.heightStyle,n=this.element.parent();this.active=this._findActive(e.active).addClass("ui-accordion-header-active ui-state-active ui-corner-top").removeClass("ui-corner-all"),this.active.next().addClass("ui-accordion-content-active").show(),this.headers.attr("role","tab").each(function(){var e=h(this),t=e.uniqueId().attr("id"),i=e.next(),n=i.uniqueId().attr("id");e.attr("aria-controls",n),i.attr("aria-labelledby",t)}).next().attr("role","tabpanel"),this.headers.not(this.active).attr({"aria-selected":"false","aria-expanded":"false",tabIndex:-1}).next().attr({"aria-hidden":"true"}).hide(),this.active.length?this.active.attr({"aria-selected":"true","aria-expanded":"true",tabIndex:0}).next().attr({"aria-hidden":"false"}):this.headers.eq(0).attr("tabIndex",0),this._createIcons(),this._setupEvents(e.event),"fill"===t?(i=n.height(),this.element.siblings(":visible").each(function(){var e=h(this),t=e.css("position");"absolute"!==t&&"fixed"!==t&&(i-=e.outerHeight(!0))}),this.headers.each(function(){i-=h(this).outerHeight(!0)}),this.headers.next().each(function(){h(this).height(Math.max(0,i-h(this).innerHeight()+h(this).height()))}).css("overflow","auto")):"auto"===t&&(i=0,this.headers.next().each(function(){i=Math.max(i,h(this).css("height","").height())}).height(i))},_activate:function(e){var t=this._findActive(e)[0];t!==this.active[0]&&(t=t||this.active[0],this._eventHandler({target:t,currentTarget:t,preventDefault:h.noop}))},_findActive:function(e){return"number"==typeof e?this.headers.eq(e):h()},_setupEvents:function(e){var i={keydown:"_keydown"};e&&h.each(e.split(" "),function(e,t){i[t]="_eventHandler"}),this._off(this.headers.add(this.headers.next())),this._on(this.headers,i),this._on(this.headers.next(),{keydown:"_panelKeyDown"}),this._hoverable(this.headers),this._focusable(this.headers)},_eventHandler:function(e){var t=this.options,i=this.active,n=h(e.currentTarget),s=n[0]===i[0],a=s&&t.collapsible,r=a?h():n.next(),o={oldHeader:i,oldPanel:i.next(),newHeader:a?h():n,newPanel:r};e.preventDefault(),s&&!t.collapsible||!1===this._trigger("beforeActivate",e,o)||(t.active=!a&&this.headers.index(n),this.active=s?h():n,this._toggle(o),i.removeClass("ui-accordion-header-active ui-state-active"),t.icons&&i.children(".ui-accordion-header-icon").removeClass(t.icons.activeHeader).addClass(t.icons.header),s||(n.removeClass("ui-corner-all").addClass("ui-accordion-header-active ui-state-active ui-corner-top"),t.icons&&n.children(".ui-accordion-header-icon").removeClass(t.icons.header).addClass(t.icons.activeHeader),n.next().addClass("ui-accordion-content-active")))},_toggle:function(e){var t=e.newPanel,i=this.prevShow.length?this.prevShow:e.oldPanel;this.prevShow.add(this.prevHide).stop(!0,!0),this.prevShow=t,this.prevHide=i,this.options.animate?this._animate(t,i,e):(i.hide(),t.show(),this._toggleComplete(e)),i.attr({"aria-hidden":"true"}),i.prev().attr({"aria-selected":"false","aria-expanded":"false"}),t.length&&i.length?i.prev().attr({tabIndex:-1,"aria-expanded":"false"}):t.length&&this.headers.filter(function(){return 0===parseInt(h(this).attr("tabIndex"),10)}).attr("tabIndex",-1),t.attr("aria-hidden","false").prev().attr({"aria-selected":"true","aria-expanded":"true",tabIndex:0})},_animate:function(e,i,t){var n,s,a,r=this,o=0,h=e.css("box-sizing"),d=e.length&&(!i.length||e.index()<i.index()),c=this.options.animate||{},u=d&&c.down||c,l=function(){r._toggleComplete(t)};return"number"==typeof u&&(a=u),"string"==typeof u&&(s=u),s=s||u.easing||c.easing,a=a||u.duration||c.duration,i.length?e.length?(n=e.show().outerHeight(),i.animate(this.hideProps,{duration:a,easing:s,step:function(e,t){t.now=Math.round(e)}}),void e.hide().animate(this.showProps,{duration:a,easing:s,complete:l,step:function(e,t){t.now=Math.round(e),"height"!==t.prop?"content-box"===h&&(o+=t.now):"content"!==r.options.heightStyle&&(t.now=Math.round(n-i.outerHeight()-o),o=0)}})):i.animate(this.hideProps,a,s,l):e.animate(this.showProps,a,s,l)},_toggleComplete:function(e){var t=e.oldPanel;t.removeClass("ui-accordion-content-active").prev().removeClass("ui-corner-top").addClass("ui-corner-all"),t.length&&(t.parent()[0].className=t.parent()[0].className),this._trigger("activate",null,e)}})});