package com.example.getproxy

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.net.ProxySelector
import java.net.Proxy
import java.net.URI

class GetProxyPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "get_proxy")
      channel.setMethodCallHandler(GetProxyPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "getProxyType" -> {
        var p = getProxy(call)
        result.success(p.type().toString())
      }
      "getProxyAddress" -> {
        var p = getProxy(call)
        if (p == Proxy.NO_PROXY) {
          result.success("")
        } else {
          result.success(p.address().toString())
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  fun getProxy(call: MethodCall): Proxy {
    var url = URI(call.argument<String>("url"))
    var p = ProxySelector.getDefault().select(url)
    return p[0] as Proxy
  }

}
