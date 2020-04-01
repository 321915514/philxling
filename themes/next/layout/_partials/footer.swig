<script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-star"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>
	<div class="theme-info">
	  <div class="powered-by"></div>
	  <span class="post-count"><i class="fa fa-area-chart"> 博客全站共</i>{{ totalcount(site) }}字</span>
	</div>
  {% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">{{ __('post.totalcount') }}&#58;</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %}
</div>
<div class="busuanzi-count">
  <script async="" src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>

  <span class="site-uv">
  <i class="fa fa-user"> 本站访客数</i>
  <span class="busuanzi-value" id="busuanzi_value_site_uv"></span>
  人
  </span>

  <span class="site-pv">
  <i class="fa fa-eye"> 本站总访问量</i>
  <span class="busuanzi-value" id="busuanzi_value_site_pv"></span>
  次
  </span>
</div>
{% if theme.footer.powered %}
  <div class="powered-by">{#
  #}{{ __('footer.powered', '<a class="theme-link" target="_blank" href="https://hexo.io">Hexo</a>') }}{#
#}</div>
{% endif %}

{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}

{% if theme.footer.theme.enable %}
  <div class="theme-info">{#
  #}{{ __('footer.theme') }} &mdash; {#
  #}<a class="theme-link" target="_blank" href="https://github.com/iissnan/hexo-theme-next">{#
    #}NexT.{{ theme.scheme }}{#
  #}</a>{% if theme.footer.theme.version %} v{{ theme.version }}{% endif %}{#
#}</div>
{% endif %}

{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}
<!-- 在网页底部添加网站运行时间 -->
<div>
	<span id="timeDate">载入天数...</span><span id="times">载入时分秒...</span>
</div>
<script>
    var now = new Date();
    function createtime() {
        var grt= new Date("01/01/2020 00:00:00");//此处修改你的建站时间或者网站上线时间
        now.setTime(now.getTime()+250);
        days = (now - grt ) / 1000 / 60 / 60 / 24; dnum = Math.floor(days);
        hours = (now - grt ) / 1000 / 60 / 60 - (24 * dnum); hnum = Math.floor(hours);
        if(String(hnum).length ==1 ){hnum = "0" + hnum;} minutes = (now - grt ) / 1000 /60 - (24 * 60 * dnum) - (60 * hnum);
        mnum = Math.floor(minutes); if(String(mnum).length ==1 ){mnum = "0" + mnum;}
        seconds = (now - grt ) / 1000 - (24 * 60 * 60 * dnum) - (60 * 60 * hnum) - (60 * mnum);
        snum = Math.round(seconds); if(String(snum).length ==1 ){snum = "0" + snum;}
        document.getElementById("timeDate").innerHTML = "Run for "+dnum+" Days ";
        document.getElementById("times").innerHTML = hnum + " Hours " + mnum + " m " + snum + " s";
    }
setInterval("createtime()",250);
</script>

