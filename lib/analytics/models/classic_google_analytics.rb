require 'active_support/inflector'

module Analytics
  module Models
    #TODO should cover all the below topics
    #Campaigns
    #Custom Variables
    #Ecommerce
    #Event Tracking
    #Experiments
    #Multiple Domains
    #Search Engines
    #Social Interactions
    #User Timings
    #Reference
    #_gat
    #_gaq
    #Basic Configuration
    #Campaign Tracking
    #Domains & Directories
    #Ecommerce
    #Event Tracking
    #Search Engines and Referrers
    #Social Interactions
    #Web Client
    #Urchin Server
    #User Timings
    #Limits and Quotas
    #Cookie Usage
    #Troubleshooting & Validation

    class ClassicGoogleAnalytics < GoogleAnalytics

      #Provides 2 global object `_gat`, the tracker and `_gaq`, the tracking queue
      #Method reference https://developers.google.com/analytics/devguides/collection/gajs/methods/
      #  _gat Object Methods : The _gat global object is used to create and retrieve tracker objects
      #    _getTracker(web_property_id) *deprecated*
      #    _createTracker(web_property_id?, tracker_name?)
      #    _getTrackerByName(tracker_name?)
      #    _anonymizeIp()
      #    _forceSSL(bool)
      #
      #  _gaq Object Methods: The _gaq global object can be used directly for asynchronous page tracking via the push(...) method
      #    _createAsyncTracker(accountId, tracker_name?) *deprecated*
      #    _getAsyncTracker(tracker_name?) *deprecated*
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

      # Initializes new ClassicGoogleAnalytics
      # opts - The Hash opts used to initialize analytics
      #        :remarketing - enable/disable remarketing with google analytics (default: false) (optional)
      def initialize opts={}
        opts.symbolize_keys!
        script_src = if opts[:remarketing]
                       "('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'"
                     else
                       "('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js'"
                     end
        super opts.reverse_merge :script_src => script_src
      end

      # creates a tracker with the 'web_property_id' and tracks the page view
      # Returns self
      def create_tracker
        self << 'var _gaq = _gaq || [];'
        push(['_setAccount', web_property_id])
        self
      end

      # returns the tracking code without page track for ClassicGoogleAnalytics
      # Returns String classic google analytics tracking code without page view track
      def tracking_code
        self << %{
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = #{script_src};
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
        }
        self
      end

      # returns the tracking code with page track for ClassicGoogleAnalytics
      # Returns String classic google analytics tracking code with page view track
      def tracking_code_with_pagetrack
        create_tracker.track_pageview.tracking_code_without_pagetrack
      end
      alias_method_chain :tracking_code, :pagetrack

      #Syntax of tracking code varies bawsed on sync or async mode,
      #async uses `push`, OOTO sync methods are directly called on tracker object

      #pushes analytics data to google analytics global object '_gaq' (asynchronous syntax)
      #args - Zero or More Objects to be tracked by google analytics
      #Returns String
      def track *args
        self << "_gaq.push(#{args.to_json});"
        self
      end
      alias_method :push, :track

      def track_pageview *args
        #opt_pageURL, _ = args
        args = [method_to_analytics(__method__)] + args
        track(*args)
      end

      #Event Tracking
      #https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiEventTracking

      #String   category The general event category (e.g. "Videos").
      #String   action The action for the event (e.g. "Play").
      #String   opt_label An optional descriptor for the event.
      #Int      opt_value An optional value associated with the event. You can see your event values in the Overview, Categories, and Actions reports, where they are listed by event or aggregated across events, depending upon your report view.
      #Boolean  opt_noninteraction Default value is false. By default, the event hit sent by _trackEvent() will impact a visitor's bounce rate. By setting this parameter to true, this event hit will not be used in bounce rate calculations.
      def track_event *args
        #category, action, opt_label, opt_value, opt_noninteraction =  args
        args = [method_to_analytics(__method__)] + args
        track(*args)
      end

      #Ecommerce Tracking
      #https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiEcommerce

      #String   transactionId Optional Order ID of the transaction to associate with item.
      #String   sku Required. Item's SKU code.
      #String   name Required. Product name. Required to see data in the product detail report.
      #String   category Optional. Product category.
      #String   price Required. Product price.
      #String   quantity Required. Purchase quantity.
      def add_item *args
        #transaction_id, sku, name, category, price, quantity = args
        args = [method_to_analytics(__method__)] + args
        track(*args)
      end

      #String   transactionId Required. Internal unique transaction ID number for this transaction.
      #String   affiliation Optional. Partner or store affiliation (undefined if absent).
      #String   total Required. Total dollar amount of the transaction. Does not include tax and shipping and should only be considered the "grand total" if you explicity include shipping and tax.
      #String   tax Optional. Tax amount of the transaction.
      #String   shipping Optional. Shipping charge for the transaction.
      #String   city Optional. City to associate with transaction.
      #String   state Optional. State to associate with transaction.
      #String   country Optional. Country to associate with transaction.
      def add_transaction *args
        #transactionId, affiliation, total, tax, shipping, city, state, country = args
        args = [method_to_analytics(__method__)] + args
        track(*args)
      end

      def track_transaction *args
        args = [method_to_analytics(__method__)] + args
        track(*args)
      end

      private
      # converts snake_case ruby method string to camelCase google analytics method.
      # method - the method name to be converted
      #
      # Examples
      #   method_to_analytics('track_pageview')
      #   # => '_trackPageview'
      # Returns lower camelCase string appended by '_'
      def method_to_analytics method
        "_#{method.to_s.camelcase(:lower)}"
      end

    end
  end
end


