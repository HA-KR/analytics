module Analytics
  module Models
    class ClassicGoogleAnalytics < GoogleAnalytics

      #Method reference https://developers.google.com/analytics/devguides/collection/gajs/methods/
      #  _gat Object Methods : The _gat global object is used to create and retrieve tracker objects
      #    Tracker _getTracker(web_property_id) *deprecated*
      #    Tracker _createTracker(web_property_id?, tracker_name?)
      #    Tracker _getTrackerByName(tracker_name?)
      #    _anonymizeIp()
      #    _forceSSL(bool)
      #
      #  _gaq Object Methods: The _gaq global object can be used directly for asynchronous page tracking via the push(...) method
      #    Tracker _createAsyncTracker(accountId, tracker_name?) *deprecated*
      #    Tracker _getAsyncTracker(tracker_name?) *deprecated*
      #    push(commandArray | Javascript function)
      #
      #  Tracker Object Methods
      #    _addIgnoredOrganic(newIgnoredOrganicKeyword)
      #    _addIgnoredRef(newIgnoredReferrer)
      #    _addItem(transactionId, sku, name, category, price, quantity)
      #    _addOrganic(newOrganicEngine, newOrganicKeyword, opt_prepend)
      #    _addTrans(transactionId, affiliation, total, tax, shipping, city, state, country)
      #    _clearIgnoredOrganic()
      #    _clearIgnoredRef()
      #    _clearOrganic()
      #    _cookiePathCopy(newPath)
      #    _deleteCustomVar(index)
      #    _getName()
      #    _setAccount()
      #    _getAccount()
      #    _getClientInfo(1)
      #    _getDetectFlash(1)
      #    _getDetectTitle(1)
      #    _getLinkerUrl(targetUrl, useHash)
      #    _getLocalGifPath()
      #    _getServiceMode()
      #    _getVersion()
      #    _getVisitorCustomVar(index)
      #    _initData() *deprecated*
      #    _link(targetUrl, useHash)
      #    _linkByPost(formObject, useHash)
      #    _setAllowAnchor(bool)
      #    _setAllowHash(bool) *deprecated*
      #    _setAllowLinker(bool)
      #    _setCampContentKey(newCampContentKey)
      #    _setCampMediumKey(newCampMedKey)
      #    _setCampNameKey(newCampNameKey)
      #    _setCampNOKey(newCampNOKey)
      #    _setCampSourceKey(newCampSrcKey)
      #    _setCampTermKey(newCampTermKey)
      #    _setCampaignCookieTimeout(cookieTimeoutMillis)
      #    _setCampaignTrack(bool)
      #    _setClientInfo(bool)
      #    _setCookiePath(newCookiePath)
      #    _setCookiePersistence(milliseconds) *deprecated*
      #    _setCookieTimeout(newDefaultTimeout) *deprecated*
      #    _setCustomVar(index, name, value, opt_scope)
      #    _setDetectFlash(bool)
      #    _setDetectTitle(bool)
      #    _setDomainName(newDomainName)
      #    _setLocalGifPath(newLocalGifPath)
      #    _setLocalRemoteServerMode()
      #    _setLocalServerMode()
      #    _setReferrerOverride(newReferrerUrl)
      #    _setRemoteServerMode()
      #    _setSampleRate(newRate)
      #    _setSessionTimeout(newTimeout) *deprecated*
      #    _setSiteSpeedSampleRate(sampleRate)
      #    _setSessionCookieTimeout(cookieTimeoutMillis)
      #    _setVar(newVal) *deprecated*
      #    _setVisitorCookieTimeout(cookieTimeoutMillis)
      #    _trackEvent(category, action, opt_label, opt_value, opt_noninteraction)
      #    _trackPageLoadTime() *deprecated*
      #    _trackPageview(opt_pageURL)
      #    _trackSocial(network, socialAction, opt_target, opt_pagePath)
      #    _trackTiming(category, variable, time, opt_label, opt_sampleRate)
      #    _trackTrans()
      #
      def initialize opts={}
        opts.symbolize_keys!
        script_src = if opts[:remarketing]
                       "('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'"
                     else
                       "('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js'"
                     end
        super opts.reverse_merge :script_src => script_src
      end

      def tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        args << opts
        <<-TRACKING_CODE
        <script type="text/javascript">
        #{create_and_send if false != opts[:create]}
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = #{script_src};
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
        </script>
        TRACKING_CODE
      end

      private
      def create_and_send opts={}
          code = ""
          if opts[:create] != false
            code << "var _gaq = _gaq || [];"
            code << "_gaq.push(['_setAccount', '#{web_property_id}']);"
            code << "_gaq.push(['_trackPageview']);"
          else
            ''
          end
      end

    end
  end
end


